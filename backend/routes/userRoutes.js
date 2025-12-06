const express = require('express');
const router = express.Router();
const User = require('../models/User');
const verifyToken = require('../middleware/auth');

// Sync User (Create or Update)
router.post('/sync', verifyToken, async (req, res) => {
    try {
        const { uid, email, name } = req.user;

        let user = await User.findOne({ firebaseUid: uid });

        if (!user) {
            // Check if this is the first user ever
            const userCount = await User.countDocuments();
            const isAdmin = userCount === 0;

            user = new User({
                firebaseUid: uid,
                email: email,
                displayName: name || 'User',
                isAdmin: isAdmin,
                isActive: true
            });
        } else {
            user.lastLoginAt = Date.now();
            if (name) user.displayName = name;
        }

        await user.save();
        res.json(user);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Get Current User
router.get('/me', verifyToken, async (req, res) => {
    try {
        const user = await User.findOne({ firebaseUid: req.user.uid });
        if (!user) return res.status(404).json({ message: 'User not found' });
        res.json(user);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router;
