require('dotenv').config({ path: '../.env' });
const mongoose = require('mongoose');
const User = require('../models/User');

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/dimhans';

mongoose.connect(MONGODB_URI)
    .then(async () => {
        console.log('Connected to MongoDB');
        await forceAdmin();
    })
    .catch(err => {
        console.error('Connection Error:', err);
        process.exit(1);
    });

async function forceAdmin() {
    try {
        const result = await User.updateMany({}, { $set: { isAdmin: true } });
        console.log(`Updated ${result.modifiedCount} users to Admin.`);

        const users = await User.find({});
        users.forEach(u => console.log(`User ${u.email} is now Admin: ${u.isAdmin}`));

    } catch (error) {
        console.error('Error updating users:', error);
    } finally {
        mongoose.disconnect();
    }
}
