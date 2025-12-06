# Firebase to Node.js Migration Walkthrough

This document outlines the changes made to migrate the DimhansApp backend from Firebase (Firestore/Storage) to a Node.js and MongoDB solution, while retaining Firebase Authentication.

## 1. Backend Setup

A new `backend` directory has been created with the following structure:

-   **`server.js`**: Main entry point. Connects to MongoDB, initializes Firebase Admin SDK, and sets up routes.
-   **`models/`**: Mongoose models for `User`, `MoodEntry`, and `Assessment`.
-   **`routes/`**: Express routes for:
    -   `/api/users`: User synchronization and profile fetching.
    -   `/api/moods`: Mood tracking (add entry, get history).
    -   `/api/assessments`: Assessment submission and retrieval.
    -   `/api/admin`: Admin functionalities (stats, user management, global mood entries).
-   **`middleware/auth.js`**: Middleware to verify Firebase ID tokens.

### Prerequisites
-   Node.js and npm installed.
-   MongoDB installed and running locally (default: `mongodb://localhost:27017/dimhans`).
-   Firebase Service Account Key (JSON file) for the project.

### Running the Backend
1.  Navigate to the `backend` directory:
    ```bash
    cd backend
    ```
2.  Install dependencies:
    ```bash
    npm install
    ```
3.  Set environment variables (create a `.env` file or set in terminal):
    -   `MONGODB_URI=mongodb://localhost:27017/dimhans`
    -   `FIREBASE_SERVICE_ACCOUNT`: The content of your service account JSON file (as a string).
    -   `PORT=5000` (optional, default is 5000)
4.  Start the server:
    ```bash
    node server.js
    ```

## 2. Flutter Frontend Refactoring

The Flutter application has been updated to communicate with the new Node.js backend via HTTP requests instead of direct Firestore calls.

### Key Changes
-   **`pubspec.yaml`**: Removed `cloud_firestore` and `firebase_storage`. Added `http`.
-   **`lib/services/api_service.dart`**: New service class handling all backend communication.
    -   **Base URL**: Currently set to `http://localhost:5000/api`. **IMPORTANT**: Update this to your machine's IP address (e.g., `http://10.0.2.2:5000` for Android emulator) when testing on devices.
-   **`lib/auth_service.dart`**: Updated to call `ApiService.syncUser()` after Firebase login/signup.
-   **`lib/mood_tracker_screen.dart`**: Updated to use `ApiService.addMoodEntry()`.
-   **`lib/mood_history_screen.dart`**: Updated to use `ApiService.getMoodHistory()`.
-   **`lib/assessment_screen.dart`**: Updated to use `ApiService.addAssessment()`.
-   **`lib/admin_service.dart`**: Completely refactored to use `ApiService` for all admin operations.
-   **`lib/admin_dashboard_screen.dart`**: Updated to fetch data via `ApiService` and `AdminService`.

### Running the App
1.  Ensure the backend is running.
2.  Update `baseUrl` in `lib/services/api_service.dart` if necessary.
3.  Run the Flutter app:
    ```bash
    flutter run
    ```

## 3. Verification

### User Flow
1.  **Sign Up/Login**: Authenticate using Firebase. The app will sync user data to MongoDB.
2.  **Mood Tracking**: Submit a mood entry. Verify it appears in MongoDB `moodentries` collection.
3.  **History**: Check Mood History screen. It should load entries from MongoDB.
4.  **Assessment**: Complete an assessment. Verify it saves to MongoDB `assessments` collection.

### Admin Flow
1.  **Admin Access**: Ensure your user has `isAdmin: true` in MongoDB `users` collection.
2.  **Dashboard**: Access Admin Dashboard. It should show stats and recent mood entries from all users.
3.  **User Management**: View user list, toggle active status, and view specific user details.
4.  **Admin Management**: Add/remove other admins (requires existing user email).

## 4. Next Steps
-   **Data Migration**: If you need to keep historical data, write a script to export data from Firestore and import it into MongoDB.
-   **Deployment**: Deploy the Node.js backend to a server (e.g., Heroku, AWS, DigitalOcean) and update the Flutter app's `baseUrl`.
-   **Craving Skills**: Implement backend support for Craving Skills if data tracking is required for that feature.
