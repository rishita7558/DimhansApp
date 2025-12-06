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

// Connect to MongoDB
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/dimhans';
mongoose.connect(MONGODB_URI)
    .then(() => console.log('MongoDB Connected'))
    .catch(err => {
        console.error('MongoDB Connection Error:', err);
        process.exit(1);
    });

const email = process.argv[2];

if (!email) {
    console.error('Please provide an email address.');
    console.log('Usage: node create_admin.js <email>');
    process.exit(1);
}

async function createAdmin() {
    try {
        console.log(`Fetching user ${email} from Firebase...`);
        const firebaseUser = await admin.auth().getUserByEmail(email);

        console.log(`Found Firebase User: ${firebaseUser.uid}`);

        let user = await User.findOne({ firebaseUid: firebaseUser.uid });

        if (user) {
            console.log('User exists in MongoDB. Updating to Admin...');
            user.isAdmin = true;
            user.email = email; // Ensure email is up to date
            user.displayName = firebaseUser.displayName || user.displayName;
            await user.save();
            console.log('Success! User updated to Admin.');
        } else {
            console.log('User not found in MongoDB. Creating new Admin user...');
            user = new User({
                firebaseUid: firebaseUser.uid,
                email: email,
                displayName: firebaseUser.displayName || 'Admin',
                isAdmin: true,
                isActive: true
            });
            await user.save();
            console.log('Success! New Admin user created.');
        }

    } catch (error) {
        console.error('Error:', error.message);
        if (error.code === 'auth/user-not-found') {
            console.error('User not found in Firebase. Please sign up in the app first or create the user in Firebase Console.');
        }
    } finally {
        mongoose.disconnect();
    }
}

createAdmin();
