const express = require('express');
const router = express.Router();
const MoodEntry = require('../models/MoodEntry');
const User = require('../models/User');
const verifyToken = require('../middleware/auth');

// Add Mood Entry
router.post('/', verifyToken, async (req, res) => {
    try {
        // req.user.id comes from the JWT payload (User._id)
        const moodEntry = new MoodEntry({
            userId: req.user.id,
            ...req.body
        });

        const savedEntry = await moodEntry.save();
        res.status(201).json(savedEntry);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

// Get Mood History
router.get('/', verifyToken, async (req, res) => {
    try {
        const moodEntries = await MoodEntry.find({ userId: req.user.id }).sort({ timestamp: -1 });
        res.json(moodEntries);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router;
