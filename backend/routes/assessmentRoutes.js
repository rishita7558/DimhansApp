const express = require('express');
const router = express.Router();
const Assessment = require('../models/Assessment');
const User = require('../models/User');
const verifyToken = require('../middleware/auth');

// Add Assessment
router.post('/', verifyToken, async (req, res) => {
    try {
        const user = await User.findOne({ firebaseUid: req.user.uid });
        if (!user) return res.status(404).json({ message: 'User not found' });

        const assessment = new Assessment({
            userId: user._id,
            ...req.body
        });

        const savedAssessment = await assessment.save();
        res.status(201).json(savedAssessment);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

// Get Assessments
router.get('/', verifyToken, async (req, res) => {
    try {
        const user = await User.findOne({ firebaseUid: req.user.uid });
        if (!user) return res.status(404).json({ message: 'User not found' });

        const assessments = await Assessment.find({ userId: user._id }).sort({ timestamp: -1 });
        res.json(assessments);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router;
