# 🧠 DIMHANS — Alcohol Support & Recovery App

A full-stack mobile application built with **Flutter** (frontend) and **Node.js + MongoDB** (backend), designed to support individuals seeking help with alcohol dependency. The app is developed in collaboration with **DIMHANS** (Dharwad Institute of Mental Health and Neuro Sciences) and provides educational resources, self-assessment tools, mood tracking, craving management, and a community forum.

---

## ✨ Features

### For Users
- 🔐 **Authentication** — Secure registration, login, email verification, and forgot-password flow via Firebase Auth
- 🏠 **Home Screen** — Personalized dashboard with quick-access actions
- 📚 **Learn** — Educational content on alcohol effects for the general public and students
- 🆘 **Help** — Emergency contacts and professional support resources
- 🧘 **Craving Skills** — Guided exercises and techniques to manage cravings
- 📈 **Mood Tracker** — Log daily moods and view historical mood trends
- 💬 **Community** — Discussion forum for peer-to-peer support
- 🏥 **About** — Information about DIMHANS, its team, and the institution
- 📝 **Self-Assessment** — Alcohol dependency self-assessment questionnaire

### For Admins
- 🛡️ **Admin Dashboard** — Statistics overview and platform monitoring
- 👥 **User Management** — View, activate/deactivate, and delete user accounts
- 🔑 **Admin Management** — Add or remove admin accounts
- 📊 **Mood Entry Monitoring** — View recent mood entries across all users

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Frontend** | Flutter (Dart) `v1.0.1+2`, SDK `^3.8.1` |
| **Backend** | Node.js, Express.js |
| **Database** | MongoDB (via Mongoose) |
| **Authentication** | Firebase Authentication + Firebase Admin SDK |
| **State Management** | Provider |
| **Deployment** | Vercel (backend), Android APK (mobile) |

### Key Dependencies

**Flutter (Frontend)**
- `firebase_core` & `firebase_auth` — Authentication
- `provider` — State management
- `http` — REST API calls to backend
- `shared_preferences` — Local data persistence
- `url_launcher` — Open external links
- `intl` — Internationalization & date formatting

**Node.js (Backend)**
- `express` — Web framework
- `mongoose` — MongoDB ODM
- `firebase-admin` — Server-side Firebase token verification
- `bcryptjs` — Password hashing
- `jsonwebtoken` — JWT-based session tokens
- `cors` — Cross-Origin Resource Sharing
- `dotenv` — Environment variable management

---

## 📁 Project Structure

```
DimhansApp/
├── lib/                          # Flutter frontend source
│   ├── main.dart                 # App entry point & navigation
│   ├── auth_wrapper.dart         # Auth state routing
│   ├── auth_service.dart         # Firebase auth helper
│   ├── home_screen.dart          # Home dashboard
│   ├── learn_screen.dart         # Educational content
│   ├── help_screen.dart          # Help & emergency contacts
│   ├── craving_skills_screen.dart# Craving management exercises
│   ├── mood_tracker_screen.dart  # Mood logging
│   ├── mood_history_screen.dart  # Mood history & charts
│   ├── community_screen.dart     # Community forum
│   ├── about_screen.dart         # About DIMHANS
│   ├── assessment_screen.dart    # Self-assessment tool
│   ├── login_screen.dart         # Login UI
│   ├── register_screen.dart      # Registration UI
│   ├── forgot_password_screen.dart
│   ├── email_verification_screen.dart
│   ├── admin_dashboard_screen.dart
│   ├── admin_management_screen.dart
│   └── services/
│       └── api_service.dart      # REST API client
│
├── backend/                      # Node.js backend
│   ├── server.js                 # Express server entry point
│   ├── routes/
│   │   ├── authRoutes.js         # /api/auth
│   │   ├── userRoutes.js         # /api/users
│   │   ├── moodRoutes.js         # /api/moods
│   │   ├── assessmentRoutes.js   # /api/assessments
│   │   └── adminRoutes.js        # /api/admin
│   ├── models/                   # Mongoose data models
│   ├── middleware/               # Auth middleware
│   ├── package.json
│   └── vercel.json               # Vercel deployment config
│
├── assets/                       # Images & static assets
├── android/                      # Android project files
├── pubspec.yaml                  # Flutter dependencies
└── DimhansApp-release.apk        # Latest release APK
```

---

## 🚀 Getting Started

### Prerequisites

Ensure the following are installed on your machine:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (SDK `^3.8.1`)
- [Node.js](https://nodejs.org/) (v18+)
- [MongoDB](https://www.mongodb.com/try/download/community) (running locally or a MongoDB Atlas URI)
- A Firebase project with **Authentication** enabled (Email/Password provider)

---

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/DimhansApp.git
cd DimhansApp
```

---

### 2. Backend Setup

```bash
cd backend
npm install
```

Create a `.env` file inside the `backend/` directory:

```env
PORT=5000
MONGODB_URI=mongodb://localhost:27017/dimhans
FIREBASE_SERVICE_ACCOUNT=<your-firebase-service-account-json-as-string>
JWT_SECRET=your_jwt_secret_key
```

> **Getting `FIREBASE_SERVICE_ACCOUNT`:** Go to Firebase Console → Project Settings → Service Accounts → Generate New Private Key. Copy the entire JSON content and paste it as a single-line string value.

Start the backend server:

```bash
# Development (with auto-reload)
npm run dev

# Production
npm start
```

You should see:
```
MongoDB Connected
Server running on port 5000
```

---

### 3. Flutter Frontend Setup

```bash
# From project root
flutter pub get
```

Configure Firebase for Flutter by placing your `google-services.json` (Android) inside `android/app/` and updating `lib/firebase_options.dart` with your project's config.

Run the app:

```bash
# On connected Android device or emulator
flutter run

# On Chrome (web)
flutter run -d chrome
```

---

### 4. Backend API Reference

The backend is deployed at `https://dimhans-app.vercel.app`.

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/auth/register` | Register a new user |
| `POST` | `/api/auth/login` | User login |
| `GET` | `/api/users/me` | Get current user details |
| `POST` | `/api/users/sync` | Sync Firebase user to MongoDB |
| `POST` | `/api/moods` | Add a mood entry |
| `GET` | `/api/moods` | Get mood history (current user) |
| `POST` | `/api/assessments` | Submit a self-assessment |
| `GET` | `/api/admin/users` | *(Admin)* Get all users |
| `GET` | `/api/admin/stats` | *(Admin)* Get platform statistics |
| `PATCH` | `/api/admin/users/:id/status` | *(Admin)* Update user active status |
| `DELETE`| `/api/admin/users/:id` | *(Admin)* Delete a user |
| `GET` | `/api/admin/admins` | *(Admin)* List all admin accounts |
| `POST` | `/api/admin/admins` | *(Admin)* Add an admin account |
| `DELETE`| `/api/admin/admins/:id` | *(Admin)* Remove an admin account |

---

## 📦 Building for Release

**Android APK:**
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

A pre-built release APK is also available at the project root: `DimhansApp-release.apk`

---

## 🌐 Deployment

The backend is configured for **Vercel** deployment via `backend/vercel.json`. To deploy:

```bash
cd backend
npx vercel --prod
```

Set all environment variables (`MONGODB_URI`, `FIREBASE_SERVICE_ACCOUNT`, `JWT_SECRET`) in the Vercel dashboard under **Project Settings → Environment Variables**.

---

## 🔒 Security Notes

- Firebase Authentication handles all user identity verification
- The Node.js backend verifies Firebase ID tokens using the Firebase Admin SDK before processing requests
- Passwords are hashed with `bcryptjs` before storage
- JWT tokens are used for API session management
- Sensitive credentials are never committed — use `.env` files (already in `.gitignore`)

---

## 🏥 About DIMHANS

**Dharwad Institute of Mental Health and Neuro Sciences (DIMHANS)** is a premier government mental health institution in Karnataka, India. This app is designed to extend DIMHANS's reach by providing alcohol support resources, educational content, and tools for recovery directly to patients and the general public.

---

## 📄 License

This project is private and intended for use by DIMHANS and its associated partners. All rights reserved.
