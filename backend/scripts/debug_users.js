require('dotenv').config({ path: '../.env' });
const mongoose = require('mongoose');
const User = require('../models/User');

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/dimhans';

mongoose.connect(MONGODB_URI)
    .then(() => {
        console.log('Connected to MongoDB');
        checkUsers();
    })
    .catch(err => {
        console.error('Connection Error:', err);
        process.exit(1);
    });

async function checkUsers() {
    try {
        const users = await User.find({});
        console.log('--- User List ---');
        if (users.length === 0) {
            console.log('No users found in MongoDB.');
        } else {
            users.forEach(u => {
                console.log(`Email: ${u.email}, UID: ${u.firebaseUid}, IsAdmin: ${u.isAdmin}, IsActive: ${u.isActive}`);
            });
        }
        console.log('-----------------');
    } catch (error) {
        console.error('Error fetching users:', error);
    } finally {
        mongoose.disconnect();
    }
}
