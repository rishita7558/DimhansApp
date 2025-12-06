const mongoose = require('mongoose');

const moodEntrySchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    moodLevel: {
        type: Number,
        required: true
    },
    moodDescription: String,
    triggers: [String],
    copingStrategies: [String],
    assessmentData: {
        type: Map,
        of: mongoose.Schema.Types.Mixed
    },
    timestamp: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('MoodEntry', moodEntrySchema);
