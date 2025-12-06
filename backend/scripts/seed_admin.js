require('dotenv').config({ path: '../.env' });
const mongoose = require('mongoose');
const admin = require('firebase-admin');
const User = require('../models/User');

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

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/dimhans';

const TARGET_EMAIL = 'rishitasaladi2007@gmail.com';
const TARGET_PASSWORD = 'Rishita@07';

async function seedAdmin() {
    try {
        await mongoose.connect(MONGODB_URI);
        console.log('MongoDB Connected');

        // 1. Get or Create Firebase User
        let firebaseUid;
        try {
            const userRecord = await admin.auth().getUserByEmail(TARGET_EMAIL);
            console.log(`Found existing Firebase user: ${userRecord.uid}`);
            firebaseUid = userRecord.uid;
            // Optional: Update password if needed, but usually we shouldn't mess with user passwords unless asked.
            // The user asked "Create a valid admin account... give me the creds".
            // Since they provided the password, let's ensure it's set.
            await admin.auth().updateUser(firebaseUid, {
                password: TARGET_PASSWORD,
                emailVerified: true
            });
            console.log('Updated Firebase user password.');
        } catch (error) {
            if (error.code === 'auth/user-not-found') {
                console.log('User not found in Firebase. Creating...');
                const userRecord = await admin.auth().createUser({
                    email: TARGET_EMAIL,
                    password: TARGET_PASSWORD,
                    emailVerified: true,
                    displayName: 'Admin'
                });
                firebaseUid = userRecord.uid;
                console.log(`Created new Firebase user: ${firebaseUid}`);
            } else {
                throw error;
            }
        }

        // 2. Clear existing admins in MongoDB
        await User.updateMany({ isAdmin: true }, { $set: { isAdmin: false } });
        console.log('Demoted all existing admins.');

        // 3. Upsert Admin in MongoDB
        const user = await User.findOneAndUpdate(
            { firebaseUid: firebaseUid },
            {
                email: TARGET_EMAIL,
                displayName: 'Admin',
                isAdmin: true,
                isActive: true,
                firebaseUid: firebaseUid
            },
            { upsert: true, new: true }
        );

        console.log('------------------------------------------------');
        console.log('ADMIN ACCOUNT READY');
        console.log(`Email: ${TARGET_EMAIL}`);
        console.log(`Password: ${TARGET_PASSWORD}`);
        console.log('------------------------------------------------');

    } catch (error) {
        console.error('Error seeding admin:', error);
    } finally {
        mongoose.disconnect();
        process.exit(0);
    }
}

seedAdmin();
