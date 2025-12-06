require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const admin = require('firebase-admin');

// Initialize Express
const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Database Connection
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/dimhans';
mongoose.connect(MONGODB_URI)
  .then(() => console.log('MongoDB Connected'))
  .catch(err => console.error('MongoDB Connection Error:', err));

// Firebase Admin Setup
// Note: You need to set GOOGLE_APPLICATION_CREDENTIALS in .env or provide serviceAccountKey.json
// For now, we'll assume default credentials or a placeholder if not provided
if (process.env.FIREBASE_SERVICE_ACCOUNT) {
  const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
} else {
  console.warn('Warning: FIREBASE_SERVICE_ACCOUNT not provided. Auth verification might fail.');
  // Initialize with default application credentials (useful for GCP hosting) or mock for dev
  admin.initializeApp();
}

// Routes
app.get('/', (req, res) => {
  res.send('Dimhans Backend is running');
});

// Import Routes
const userRoutes = require('./routes/userRoutes');
const moodRoutes = require('./routes/moodRoutes');
const assessmentRoutes = require('./routes/assessmentRoutes');
const adminRoutes = require('./routes/adminRoutes');
const authRoutes = require('./routes/authRoutes');

app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/moods', moodRoutes);
app.use('/api/assessments', assessmentRoutes);
app.use('/api/admin', adminRoutes);

// Start Server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
