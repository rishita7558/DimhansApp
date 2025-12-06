const express = require('express');
const router = express.Router();
const User = require('../models/User');
const MoodEntry = require('../models/MoodEntry');
const Assessment = require('../models/Assessment');
const verifyToken = require('../middleware/auth');

// Middleware to check if user is admin
// Middleware to check if user is admin
const verifyAdmin = async (req, res, next) => {
    try {
        console.log(`[Admin Auth] Verifying admin for ID: ${req.user.id}`);
        // req.user.id is the MongoDB _id from the JWT payload
        const user = await User.findById(req.user.id);
        console.log(`[Admin Auth] Found User: ${user ? user.email : 'None'}, IsAdmin: ${user?.isAdmin}`);

        if (!user || !user.isAdmin) {
            console.warn(`[Admin Auth] Access denied for user: ${req.user.id}`);
            return res.status(403).json({ message: 'Access denied. Admin only.' });
        }
        next();
    } catch (error) {
        console.error('[Admin Auth] Error:', error);
        res.status(500).json({ message: error.message });
    }
};

// Get All Users
router.get('/users', verifyToken, verifyAdmin, async (req, res) => {
    try {
        const users = await User.find().sort({ createdAt: -1 });
        res.json(users);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Get Stats
router.get('/stats', verifyToken, verifyAdmin, async (req, res) => {
    try {
        const totalUsers = await User.countDocuments();
        const activeUsers = await User.countDocuments({ isActive: true });
        const totalMoodEntries = await MoodEntry.countDocuments();
        const totalAssessments = await Assessment.countDocuments();

        res.json({
            totalUsers,
            activeUsers,
            inactiveUsers: totalUsers - activeUsers,
            totalMoodEntries,
            totalAssessments
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Get User Details
router.get('/users/:userId', verifyToken, verifyAdmin, async (req, res) => {
    try {
        const user = await User.findById(req.params.userId);
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        const moodEntries = await MoodEntry.find({ userId: req.params.userId }).sort({ timestamp: -1 });
        const assessments = await Assessment.find({ userId: req.params.userId }).sort({ timestamp: -1 });
        // const cravingSkills = await CravingSkill.find({ userId: req.params.userId }).sort({ timestamp: -1 }); // TODO: Implement CravingSkill model

        res.json({
            ...user.toObject(),
            moodEntries,
            assessments,
            cravingSkills: [] // Placeholder until CravingSkill is implemented
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Update User Status
router.patch('/users/:userId/status', verifyToken, verifyAdmin, async (req, res) => {
    try {
        const { isActive } = req.body;
        const user = await User.findByIdAndUpdate(
            req.params.userId,
            { isActive },
            { new: true }
        );
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }
        res.json(user);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Clear User Data
router.delete('/users/:userId', verifyToken, verifyAdmin, async (req, res) => {
    try {
        const userId = req.params.userId;

        // Delete related data
        await MoodEntry.deleteMany({ userId });
        await Assessment.deleteMany({ userId });
        // await CravingSkill.deleteMany({ userId });

        // Delete user
        const user = await User.findByIdAndDelete(userId);

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        // Note: We cannot delete from Firebase Auth easily without Firebase Admin SDK here 
        // and proper setup. The frontend service mentioned using Firebase Console for that.

        res.json({ message: 'User data deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Get Recent Mood Entries (Global)
router.get('/moods', verifyToken, verifyAdmin, async (req, res) => {
    try {
        const limit = parseInt(req.query.limit) || 10;
        const moodEntries = await MoodEntry.find()
            .sort({ timestamp: -1 })
            .limit(limit);

        // Enrich with user email if possible (fetching user for each entry might be slow, 
        // better to populate if using refs, but User is linked by userId string.
        // For now, let's just return entries. Frontend might need to fetch user details or we do it here.
        // Let's try to populate user details manually since we store userId as string.

        const enrichedEntries = await Promise.all(moodEntries.map(async (entry) => {
            const user = await User.findById(entry.userId);
            return {
                ...entry.toObject(),
                user_email: user ? user.email : 'Unknown'
            };
        }));

        res.json(enrichedEntries);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Get All Admins
router.get('/admins', verifyToken, verifyAdmin, async (req, res) => {
    try {
        const admins = await User.find({ isAdmin: true }).sort({ createdAt: -1 });
        // Map to format expected by frontend
        const adminList = admins.map(admin => ({
            id: admin.firebaseUid,
            email: admin.email,
            displayName: admin.displayName,
            role: 'Admin', // Hardcoded for now as we only have boolean isAdmin
            createdAt: admin.createdAt
        }));
        res.json(adminList);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Add Admin Account
router.post('/admins', verifyToken, verifyAdmin, async (req, res) => {
    try {
        const { email, displayName, role } = req.body;
        const admin = require('firebase-admin');

        // 1. Check if user exists in MongoDB
        let user = await User.findOne({ email });

        if (user) {
            // User exists, promote to admin
            user.isAdmin = true;
            await user.save();
            return res.json({ message: 'User promoted to admin successfully', user });
        }

        // 2. Check if user exists in Firebase
        try {
            const firebaseUser = await admin.auth().getUserByEmail(email);
            // Create in MongoDB
            user = new User({
                firebaseUid: firebaseUser.uid,
                email: firebaseUser.email,
                displayName: displayName || firebaseUser.displayName || 'Admin',
                isAdmin: true,
                isActive: true
            });
            await user.save();
            return res.json({ message: 'User linked and promoted to admin', user });
        } catch (firebaseError) {
            if (firebaseError.code === 'auth/user-not-found') {
                // 3. Create new user in Firebase
                try {
                    const newFirebaseUser = await admin.auth().createUser({
                        email: email,
                        emailVerified: true,
                        password: 'ChangeMe123!', // Default password
                        displayName: displayName
                    });

                    user = new User({
                        firebaseUid: newFirebaseUser.uid,
                        email: newFirebaseUser.email,
                        displayName: displayName,
                        isAdmin: true,
                        isActive: true
                    });
                    await user.save();
                    return res.json({ message: 'New admin user created with default password "ChangeMe123!"', user });
                } catch (createError) {
                    return res.status(500).json({ message: 'Error creating user in Firebase: ' + createError.message });
                }
            } else {
                throw firebaseError;
            }
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Sync Data from Firebase
router.post('/sync', verifyToken, verifyAdmin, async (req, res) => {
    try {
        const admin = require('firebase-admin');
        const db = admin.firestore();

        console.log('Starting Data Sync...');
        let stats = { users: 0, moods: 0, assessments: 0 };

        // 1. Sync Users
        const usersSnapshot = await db.collection('users').get();
        for (const doc of usersSnapshot.docs) {
            const userData = doc.data();
            const firebaseUid = doc.id;

            let user = await User.findOne({ firebaseUid });
            if (!user) {
                user = new User({
                    firebaseUid,
                    email: userData.email,
                    displayName: userData.displayName || userData.name,
                    isAdmin: userData.isAdmin || false,
                    isActive: true
                });
                await user.save();
                stats.users++;
            }
        }

        // 2. Sync Mood Entries
        const moodsSnapshot = await db.collection('moods').get();
        for (const doc of moodsSnapshot.docs) {
            const moodData = doc.data();
            const user = await User.findOne({ firebaseUid: moodData.userId });
            if (user) {
                const existing = await MoodEntry.findOne({
                    userId: user._id,
                    timestamp: moodData.timestamp ? new Date(moodData.timestamp.toDate()) : undefined
                });

                if (!existing) {
                    const newMood = new MoodEntry({
                        userId: user._id,
                        mood: moodData.mood,
                        note: moodData.note,
                        timestamp: moodData.timestamp ? moodData.timestamp.toDate() : new Date(),
                    });
                    await newMood.save();
                    stats.moods++;
                }
            }
        }

        // 3. Sync Assessments
        const assessmentsSnapshot = await db.collection('assessments').get();
        for (const doc of assessmentsSnapshot.docs) {
            const assessmentData = doc.data();
            const user = await User.findOne({ firebaseUid: assessmentData.userId });
            if (user) {
                const existing = await Assessment.findOne({
                    userId: user._id,
                    timestamp: assessmentData.timestamp ? new Date(assessmentData.timestamp.toDate()) : undefined
                });

                if (!existing) {
                    const newAssessment = new Assessment({
                        userId: user._id,
                        type: assessmentData.type,
                        score: assessmentData.score,
                        answers: assessmentData.answers,
                        timestamp: assessmentData.timestamp ? assessmentData.timestamp.toDate() : new Date(),
                    });
                    await newAssessment.save();
                    stats.assessments++;
                }
            }
        }

        res.json({ message: 'Sync complete', stats });
    } catch (error) {
        console.error('Sync Error:', error);
        res.status(500).json({ message: error.message });
    }
});

// Remove Admin Account
router.delete('/admins/:adminId', verifyToken, verifyAdmin, async (req, res) => {
    try {
        const adminId = req.params.adminId;

        // Don't allow deleting self
        if (req.user.uid === adminId) {
            return res.status(400).json({ message: 'Cannot remove your own admin privileges' });
        }

        const user = await User.findOne({ firebaseUid: adminId });
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        user.isAdmin = false;
        await user.save();

        res.json({ message: 'Admin privileges removed successfully' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router;
