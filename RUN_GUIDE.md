# How to Run the Dimhans App

Since you are new to the code, here is a simple step-by-step guide to run the application.

## Prerequisites
1.  **MongoDB**: Ensure MongoDB is installed and running on your computer.
2.  **Node.js**: Ensure Node.js is installed.
3.  **Flutter**: Ensure Flutter is installed and configured.

## Step 1: Start the Backend Server
The backend is the "brain" of the app that talks to the database.

1.  Open a terminal (Command Prompt or PowerShell).
2.  Navigate to the backend folder:
    ```bash
    cd c:\Users\Rishita\DimhansApp\backend
    ```
3.  Start the server:
    ```bash
    node server.js
    ```
    *   You should see "Server running on port 5000" and "MongoDB Connected".
    *   *Note*: You might see a warning about `FIREBASE_SERVICE_ACCOUNT`. For full functionality (logging in), you will need to set this up later, but the server will start.

## Step 2: Run the App in Chrome
1.  Open a **new** terminal window (keep the backend running in the first one).
2.  Navigate to the app folder:
    ```bash
    cd c:\Users\Rishita\DimhansApp
    ```
3.  Run the app:
    ```bash
    flutter run -d chrome
    ```
    *   This will open a Google Chrome window with your application.

## Troubleshooting
-   **Login Fails**: If you cannot log in, it's likely because the backend needs the Firebase Service Account Key to verify your identity. You will need to download this key from the Firebase Console and configure it.
-   **Connection Refused**: Ensure the backend server is running on port 5000.
