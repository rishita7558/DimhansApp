const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    firebaseUid: {
        type: String,
        required: false, // Made optional for migration
        unique: true,
        sparse: true // Allow nulls/duplicates if null
    },
    password: {
        type: String,
        required: false // Required for new users, optional for old Firebase users until they reset
    },
    email: {
        type: String,
        required: true
    },
    displayName: String,
    isAdmin: {
        type: Boolean,
        default: false
    },
    isActive: {
        type: Boolean,
        default: true
    },
    createdAt: {
        type: Date,
        default: Date.now
    },
    lastLoginAt: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('User', userSchema);
