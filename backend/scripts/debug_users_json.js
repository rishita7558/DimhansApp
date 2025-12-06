require('dotenv').config({ path: '../.env' });
const mongoose = require('mongoose');
const User = require('../models/User');

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/dimhans';

mongoose.connect(MONGODB_URI)
    .then(() => {
        checkUsers();
    })
    .catch(err => {
        console.error(JSON.stringify({ error: err.message }));
        process.exit(1);
    });

async function checkUsers() {
    try {
        const users = await User.find({});
        console.log(JSON.stringify(users, null, 2));
    } catch (error) {
        console.error(JSON.stringify({ error: error.message }));
    } finally {
        mongoose.disconnect();
    }
}
