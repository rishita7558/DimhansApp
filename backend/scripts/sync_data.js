require('dotenv').config({ path: '../.env' });
const mongoose = require('mongoose');
const admin = require('firebase-admin');
const User = require('../models/User');
const MoodEntry = require('../models/MoodEntry');
const Assessment = require('../models/Assessment');

// Initialize Firebase Admin
if (process.env.FIREBASE_SERVICE_ACCOUNT) {
    const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
    admin.initializeApp({
        credential: admin.credential.cert(serviceAccount)
    });
} else {
    console.warn('Warning: FIREBASE_SERVICE_ACCOUNT not provided. Using default credentials.');
    admin.initializeApp();
}

const db = admin.firestore();

// Connect to MongoDB
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/dimhans';
mongoose.connect(MONGODB_URI)
    .then(() => console.log('MongoDB Connected'))
    .catch(err => {
        console.error('MongoDB Connection Error:', err);
        process.exit(1);
    });

async function syncData() {
    try {
        console.log('Starting Data Sync...');

        // 1. Sync Users
        console.log('Syncing Users...');
        // Note: Listing all users from Auth requires paging. For simplicity, we'll fetch from Firestore 'users' collection if it exists, 
        // or we can just rely on Auth if we want to create stubs. 
        // Better approach: If the app stores user profiles in Firestore 'users' collection, fetch that.
        const usersSnapshot = await db.collection('users').get();

        for (const doc of usersSnapshot.docs) {
            const userData = doc.data();
            const firebaseUid = doc.id; // Assuming doc ID is UID

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
                console.log(`Created user: ${userData.email}`);
            } else {
                // Update existing?
                // console.log(`User already exists: ${userData.email}`);
            }
        }

        // 2. Sync Mood Entries
        console.log('Syncing Mood Entries...');
        const moodsSnapshot = await db.collection('moods').get(); // Adjust collection name if needed

        for (const doc of moodsSnapshot.docs) {
            const moodData = doc.data();
            // Find Mongo User ID
            const user = await User.findOne({ firebaseUid: moodData.userId });
            if (!user) {
                console.warn(`Skipping mood entry ${doc.id}: User ${moodData.userId} not found in MongoDB`);
                continue;
            }

            // Check if entry exists (deduplication)
            // Assuming we can use timestamp + userId as unique key or store original ID
            // For now, let's just check if one exists with same timestamp and user
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
                    // Add other fields as per schema
                });
                await newMood.save();
                console.log(`Imported mood for user ${user.email}`);
            }
        }

        // 3. Sync Assessments
        console.log('Syncing Assessments...');
        const assessmentsSnapshot = await db.collection('assessments').get(); // Adjust collection name

        for (const doc of assessmentsSnapshot.docs) {
            const assessmentData = doc.data();
            const user = await User.findOne({ firebaseUid: assessmentData.userId });
            if (!user) {
                console.warn(`Skipping assessment ${doc.id}: User ${assessmentData.userId} not found in MongoDB`);
                continue;
            }

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
                console.log(`Imported assessment for user ${user.email}`);
            }
        }

        console.log('Data Sync Complete!');

    } catch (error) {
        console.error('Sync Error:', error);
    } finally {
        mongoose.disconnect();
    }
}

syncData();
