# Authentication System Setup

This document explains how to set up and use the authentication system in the DIMHANS Flutter app.

## Features

- **User Registration**: New users can create accounts with email and password
- **User Login**: Existing users can sign in with their credentials
- **Forgot Password**: Secure password reset through email verification
- **Bilingual Support**: Both English and Kannada language support
- **Form Validation**: Comprehensive input validation for all fields
- **Secure Authentication**: Firebase Authentication integration
- **Persistent Login**: Users stay logged in between app sessions
- **Logout Functionality**: Users can log out from any screen

## Setup Requirements

### 1. Firebase Configuration

The app requires Firebase to be properly configured. Make sure you have:

- Firebase project created
- Firebase Authentication enabled
- Email/Password sign-in method enabled
- Proper Firebase configuration files

### 2. Dependencies

The following dependencies are already included in `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^3.15.2
  firebase_auth: ^5.7.0
  shared_preferences: ^2.2.2
```

## File Structure

```
lib/
├── auth_wrapper.dart          # Main authentication wrapper
├── login_screen.dart          # Login screen
├── register_screen.dart       # Registration screen
├── forgot_password_screen.dart # Forgot password screen
├── welcome_screen.dart        # Welcome screen after login
├── main.dart                  # Main app entry point
└── home_screen.dart           # Home screen with logout
```

## Authentication Flow

1. **App Launch**: `AuthWrapper` checks if user is logged in
2. **Not Logged In**: Shows `LoginScreen`
3. **Login Success**: Navigates to `WelcomeScreen` briefly, then to main app
4. **Registration**: Users can navigate to `RegisterScreen` from login
5. **Forgot Password**: Users can access `ForgotPasswordScreen` from login
6. **Logged In**: Direct access to main app
7. **Logout**: Available from home screen and other screens with app bar

## User Experience

### Login Screen
- Email and password fields with validation
- Language toggle (English/Kannada)
- Link to registration
- Forgot password link
- Error handling with user-friendly messages

### Registration Screen
- Full name, email, password, and confirm password fields
- Comprehensive form validation
- Language toggle support
- Link back to login

### Forgot Password Screen
- Email input field with validation
- Language toggle (English/Kannada)
- Password reset functionality
- Success confirmation screen
- Link back to login

### Welcome Screen
- Personalized welcome message
- Brief 2-second display before main app
- Smooth transition animation

## Security Features

- Password minimum length requirement (6 characters)
- Email format validation
- Firebase Authentication integration
- Secure password storage
- Session management

## Error Handling

The app handles various authentication errors:

- Invalid email format
- Weak passwords
- User not found
- Wrong password
- Account already exists
- Network errors

All errors are displayed in the user's selected language.

## Language Support

Both screens support English and Kannada:
- Form labels
- Error messages
- Button text
- Placeholder text
- Validation messages

## Testing

To test the authentication system:

1. Run the app
2. Try registering with invalid data to test validation
3. Register a new account
4. Test login with the created account
5. Test forgot password functionality
6. Test logout functionality
7. Verify persistent login across app restarts

## Troubleshooting

### Common Issues

1. **Firebase not initialized**: Ensure Firebase is properly configured
2. **Authentication errors**: Check Firebase console for enabled sign-in methods
3. **Navigation issues**: Verify all import statements are correct

### Debug Mode

Enable debug logging by checking the console for authentication flow messages.

## Future Enhancements

Potential improvements:
- Enhanced password reset options (SMS, security questions)
- Social media authentication
- Biometric authentication
- Two-factor authentication
- Account deletion
- Profile management 