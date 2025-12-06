const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

// Register
router.post('/register', async (req, res) => {
    try {
        const { email, password, displayName } = req.body;

        // Check if user exists
        let user = await User.findOne({ email });
        if (user && user.password) {
            return res.status(400).json({ message: 'User already exists' });
        }

        // Hash password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        if (user) {
            // Update existing user (migrated from Firebase)
            user.password = hashedPassword;
            user.displayName = displayName || user.displayName;
            // Force admin for specific email
            if (email === 'rishitasaladi2007@gmail.com') {
                user.isAdmin = true;
            }
        } else {
            // Create new user
            user = new User({
                email,
                password: hashedPassword,
                displayName: displayName || 'User',
                isAdmin: email === 'rishitasaladi2007@gmail.com', // Auto-admin for this email
                isActive: true
            });
        }

        await user.save();

        // Create Token
        const payload = {
            user: {
                id: user.id,
                isAdmin: user.isAdmin
            }
        };

        jwt.sign(
            payload,
            process.env.JWT_SECRET || 'secret', // Use env var in production
            { expiresIn: '30d' },
            (err, token) => {
                if (err) throw err;
                res.json({ token, user: { id: user.id, email: user.email, displayName: user.displayName, isAdmin: user.isAdmin } });
            }
        );

    } catch (error) {
        console.error(error.message);
        res.status(500).send('Server error');
    }
});

// Login
router.post('/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        // Check if user exists
        let user = await User.findOne({ email });
        if (!user) {
            return res.status(400).json({ message: 'Invalid Credentials' });
        }

        // Check password
        // Note: For migrated Firebase users who haven't reset password, this will fail.
        // We could add a check here if user.password is missing, prompt to reset.
        if (!user.password) {
            return res.status(400).json({ message: 'Please reset your password' });
        }

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ message: 'Invalid Credentials' });
        }

        // Auto-promote specific email to admin if not already
        if (email === 'rishitasaladi2007@gmail.com' && !user.isAdmin) {
            user.isAdmin = true;
            await user.save();
            console.log(`[Auth] Auto-promoted ${email} to admin`);
        }

        // Create Token
        const payload = {
            user: {
                id: user.id,
                isAdmin: user.isAdmin
            }
        };

        jwt.sign(
            payload,
            process.env.JWT_SECRET || 'secret',
            { expiresIn: '30d' },
            (err, token) => {
                if (err) throw err;
                res.json({ token, user: { id: user.id, email: user.email, displayName: user.displayName, isAdmin: user.isAdmin } });
            }
        );

    } catch (error) {
        console.error(error.message);
        res.status(500).send('Server error');
    }
});

// Get User (Protected)
router.get('/me', require('../middleware/auth'), async (req, res) => {
    try {
        const user = await User.findById(req.user.id).select('-password');
        res.json(user);
    } catch (error) {
        console.error(error.message);
        res.status(500).send('Server Error');
    }
});

module.exports = router;
