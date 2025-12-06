require('dotenv').config({ path: '../.env' });
const mongoose = require('mongoose');
const User = require('../models/User');
const MoodEntry = require('../models/MoodEntry');
const Assessment = require('../models/Assessment');

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/dimhans';

mongoose.connect(MONGODB_URI)
    .then(async () => {
        console.log('Connected to MongoDB');
        await resetDb();
    })
    .catch(err => {
        console.error('Connection Error:', err);
        process.exit(1);
    });

async function resetDb() {
    try {
        await User.deleteMany({});
        await MoodEntry.deleteMany({});
        await Assessment.deleteMany({});
        console.log('Database cleared successfully.');
    } catch (error) {
        console.error('Error clearing database:', error);
    } finally {
        mongoose.disconnect();
    }
}
