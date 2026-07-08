# 🧠 DIMHANS — Alcohol Support & Recovery App

A full-stack mobile application built with **Flutter** (frontend) and **Node.js + MongoDB** (backend), designed to support individuals seeking help with alcohol dependency. The app is developed in collaboration with **DIMHANS** (Dharwad Institute of Mental Health and Neuro Sciences) and provides educational resources, self-assessment tools, mood tracking, craving management, and a community forum.

---

## ✨ Features

### For Users
- 🔐 **Authentication** — Secure registration and login using JWT-based auth via the Node.js backend 
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

## ⚠️ Current Auth State

> **Email verification is currently disabled.**

The app includes an `EmailVerificationScreen` UI file, but it is **not enforced** — after registration, users are automatically redirected to the welcome screen without needing to verify their email. The `resendEmailVerification()` method in `auth_service.dart` is a stub (no-op).

**Firebase Authentication has been fully removed.** The app now uses a custom JWT-based auth system via the Node.js backend and MongoDB.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Frontend** | Flutter (Dart) `v1.0.1+2`, SDK `^3.8.1` |
| **Backend** | Node.js, Express.js |
| **Database** | MongoDB Atlas (via Mongoose) |
| **Authentication** | Custom JWT (bcryptjs + jsonwebtoken) |
| **State Management** | Provider + SharedPreferences |
| **Deployment** | Vercel (backend), Android APK (mobile) |

### Key Dependencies

**Flutter (Frontend)**
- `firebase_core` & `firebase_auth` — ⚠️ Still listed in `pubspec.yaml` but Firebase Auth is **not actively used**; auth is handled by the Node.js backend
- `provider` — State management
- `http` — REST API calls to backend
- `shared_preferences` — Stores JWT token and user info locally
- `url_launcher` — Open external links
- `intl` — Internationalization & date formatting

**Node.js (Backend)**
- `express` — Web framework
- `mongoose` — MongoDB ODM
- `bcryptjs` — Password hashing
- `jsonwebtoken` — JWT session tokens (30-day expiry)
- `cors` — Cross-Origin Resource Sharing
- `dotenv` — Environment variable management
- `firebase-admin` — ⚠️ Listed in `package.json` but not actively used after auth migration

---

## 📁 Project Structure

```
DimhansApp/
├── lib/                               # Flutter frontend source
│   ├── main.dart                      # App entry point & navigation
│   ├── auth_wrapper.dart              # Auth state routing (checks stored JWT)
│   ├── auth_service.dart              # Custom JWT auth helper (no Firebase)
│   ├── welcome_screen.dart            # Post-login landing screen
│   ├── home_screen.dart               # Home dashboard
│   ├── login_screen.dart              # Login UI
│   ├── register_screen.dart           # Registration UI
│   ├── forgot_password_screen.dart    # Forgot password UI (stub)
│   ├── email_verification_screen.dart # Email verification UI (disabled/pass-through)
│   ├── learn_screen.dart              # Educational content
│   ├── help_screen.dart               # Help & emergency contacts
│   ├── craving_skills_screen.dart     # Craving management exercises
│   ├── mood_tracker_screen.dart       # Mood logging
│   ├── mood_history_screen.dart       # Mood history & charts
│   ├── community_screen.dart          # Community forum
│   ├── about_screen.dart              # About DIMHANS
│   ├── assessment_screen.dart         # Self-assessment tool
│   ├── admin_dashboard_screen.dart    # Admin overview
│   ├── admin_management_screen.dart   # Admin account management
│   ├── admin_login_screen.dart        # Admin login UI
│   ├── admin_register_screen.dart     # Admin registration UI
│   ├── user_details_screen.dart       # User profile details
│   ├── firebase_options.dart          # Firebase config (kept but auth unused)
│   └── services/
│       └── api_service.dart           # REST API client (login, register, moods, etc.)
│
├── backend/                           # Node.js backend
│   ├── server.js                      # Express server entry point
│   ├── routes/
│   │   ├── authRoutes.js              # POST /api/auth/register, POST /api/auth/login
│   │   ├── userRoutes.js              # /api/users
│   │   ├── moodRoutes.js              # /api/moods
│   │   ├── assessmentRoutes.js        # /api/assessments
│   │   └── adminRoutes.js             # /api/admin
│   ├── models/                        # Mongoose data models (User, Mood, etc.)
│   ├── middleware/                    # JWT auth middleware
│   ├── package.json
│   └── vercel.json                    # Vercel deployment config
│
├── assets/                            # Images & static assets
├── android/                           # Android project files
├── pubspec.yaml                       # Flutter dependencies
└── DimhansApp-release.apk             # Latest release APK
```

---

## 🚀 Getting Started

### Prerequisites

Ensure the following are installed on your machine:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (SDK `^3.8.1`)
- [Node.js](https://nodejs.org/) (v18+)
- A MongoDB Atlas cluster (or local MongoDB instance)

> **Note:** Firebase is no longer required for authentication. The `google-services.json` and Firebase config files are still present but only Firebase Core is initialized (not Auth).

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
MONGODB_URI=mongodb+srv://<username>:<password>@cluster0.mongodb.net/dimhans
JWT_SECRET=your_jwt_secret_key
```

> **Note:** `FIREBASE_SERVICE_ACCOUNT` is optional — it was required in the previous Firebase-based auth system but is no longer needed for core auth. The server will warn if it is missing but will still run.

Start the backend server:

```bash
# Development (with auto-reload via nodemon)
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

Run the app:

```bash
# On connected Android device or emulator
flutter run

# On Chrome (web)
flutter run -d chrome
```

> The app stores the JWT token in `SharedPreferences` after login. On next launch, `AuthWrapper` checks for a stored token and restores the session automatically.

---

### 4. Backend API Reference

The backend is deployed at `https://dimhans-app.vercel.app`.

| Method | Endpoint | Auth Required | Description |
|--------|----------|:---:|-------------|
| `POST` | `/api/auth/register` | ❌ | Register a new user |
| `POST` | `/api/auth/login` | ❌ | Login & get JWT token |
| `GET` | `/api/auth/me` | ✅ | Get authenticated user info |
| `GET` | `/api/users/me` | ✅ | Get current user details |
| `POST` | `/api/users/sync` | ✅ | Sync user data |
| `POST` | `/api/moods` | ✅ | Add a mood entry |
| `GET` | `/api/moods` | ✅ | Get mood history (current user) |
| `POST` | `/api/assessments` | ✅ | Submit a self-assessment |
| `GET` | `/api/admin/users` | ✅ Admin | Get all users |
| `GET` | `/api/admin/stats` | ✅ Admin | Get platform statistics |
| `PATCH` | `/api/admin/users/:id/status` | ✅ Admin | Update user active status |
| `DELETE` | `/api/admin/users/:id` | ✅ Admin | Delete a user |
| `GET` | `/api/admin/admins` | ✅ Admin | List all admin accounts |
| `POST` | `/api/admin/admins` | ✅ Admin | Add an admin account |
| `DELETE` | `/api/admin/admins/:id` | ✅ Admin | Remove an admin account |

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

Set the following environment variables in the Vercel dashboard under **Project Settings → Environment Variables**:

| Variable | Required | Description |
|----------|:--------:|-------------|
| `MONGODB_URI` | ✅ | MongoDB Atlas connection string |
| `JWT_SECRET` | ✅ | Secret key for signing JWT tokens |
| `FIREBASE_SERVICE_ACCOUNT` | ❌ | Legacy Firebase admin key (not needed for auth) |
| `PORT` | ❌ | Defaults to 5000 |

---

## 🔒 Security Notes

- All passwords are hashed with `bcryptjs` (10 salt rounds) before storage
- JWT tokens are signed with `JWT_SECRET` and expire after **30 days**
- Protected API routes require a valid JWT in the `Authorization: Bearer <token>` header
- Sensitive credentials are never committed — use `.env` files (already listed in `.gitignore`)
- **Email verification is currently not enforced** — users can log in immediately after registration

---

## 🚧 Known Limitations / TODO

- [ ] **Email verification** — The screen exists (`email_verification_screen.dart`) but the verification check is hardcoded to `true`. Needs real implementation (e.g., send a token via Nodemailer and verify on backend).
- [ ] **Forgot password** — `AuthService.resetPassword()` is a stub; no backend endpoint exists for password reset.
- [ ] **Firebase cleanup** — `firebase_core`, `firebase_auth`, and `firebase-admin` are still in dependencies but are no longer used for auth. Consider removing to reduce bundle size.
- [ ] **Admin auto-promote** — A specific email is hardcoded in `authRoutes.js` to auto-receive admin status. Should be managed via an env variable or seed script.

---

## 🏥 About DIMHANS

**Dharwad Institute of Mental Health and Neuro Sciences (DIMHANS)** is a premier government mental health institution in Karnataka, India. This app is designed to extend DIMHANS's reach by providing alcohol support resources, educational content, and tools for recovery directly to patients and the general public.

---

## 📄 License

This project is private and intended for use by DIMHANS and its associated partners. All rights reserved.
