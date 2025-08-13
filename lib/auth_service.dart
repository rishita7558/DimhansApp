import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Get current user
  static User? get currentUser => _auth.currentUser;
  
  // Check if user is verified
  static bool get isEmailVerified => currentUser?.emailVerified ?? false;
  
  // Check if user is logged in
  static bool get isLoggedIn => currentUser != null;
  
  // Stream of auth state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Password validation rules
  static bool isPasswordStrong(String password) {
    // At least 8 characters
    if (password.length < 8) return false;
    
    // At least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    
    // At least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    
    // At least one number
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    
    // At least one special character
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    
    return true;
  }
  
  // Email validation
  static bool isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }
  
  // Sign up with email and password
  static Future<AuthResult> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Validate email and password
      if (!isEmailValid(email)) {
        throw AuthException(
          code: 'invalid-email',
          message: 'Please enter a valid email address',
        );
      }
      
      if (!isPasswordStrong(password)) {
        throw AuthException(
          code: 'weak-password',
          message: 'Password must be at least 8 characters long and contain uppercase, lowercase, number, and special character',
        );
      }
      
      // Create user account
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      // Update display name
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(displayName.trim());
        
        // Send email verification
        await userCredential.user!.sendEmailVerification();
      }
      
      return AuthResult(
        user: userCredential.user,
        isEmailVerified: false,
        message: 'Account created successfully! Please check your email for verification.',
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        code: e.code,
        message: _getErrorMessage(e.code, e.message),
      );
    } catch (e) {
      throw AuthException(
        code: 'unknown-error',
        message: 'An unexpected error occurred: $e',
      );
    }
  }
  
  // Sign in with email and password
  static Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Validate email
      if (!isEmailValid(email)) {
        throw AuthException(
          code: 'invalid-email',
          message: 'Please enter a valid email address',
        );
      }
      
      // Sign in
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      final user = userCredential.user;
      if (user == null) {
        throw AuthException(
          code: 'user-not-found',
          message: 'User not found',
        );
      }
      
      // Check if email is verified
      if (!user.emailVerified) {
        // Send verification email again if not verified
        await user.sendEmailVerification();
        throw AuthException(
          code: 'email-not-verified',
          message: 'Please verify your email before signing in. A new verification email has been sent.',
        );
      }
      
      return AuthResult(
        user: user,
        isEmailVerified: true,
        message: 'Signed in successfully!',
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        code: e.code,
        message: _getErrorMessage(e.code, e.message),
      );
    } catch (e) {
      throw AuthException(
        code: 'unknown-error',
        message: 'An unexpected error occurred: $e',
      );
    }
  }
  
  // Resend email verification
  static Future<void> resendEmailVerification() async {
    try {
      final user = currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw AuthException(
        code: 'verification-failed',
        message: 'Failed to send verification email: $e',
      );
    }
  }
  
  // Sign out
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      throw AuthException(
        code: 'signout-failed',
        message: 'Failed to sign out: $e',
      );
    }
  }
  
  // Reset password
  static Future<void> resetPassword(String email) async {
    try {
      if (!isEmailValid(email)) {
        throw AuthException(
          code: 'invalid-email',
          message: 'Please enter a valid email address',
        );
      }
      
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        code: e.code,
        message: _getErrorMessage(e.code, e.message),
      );
    } catch (e) {
      throw AuthException(
        code: 'unknown-error',
        message: 'An unexpected error occurred: $e',
      );
    }
  }
  
  // Update password
  static Future<void> updatePassword(String newPassword) async {
    try {
      if (!isPasswordStrong(newPassword)) {
        throw AuthException(
          code: 'weak-password',
          message: 'Password must be at least 8 characters long and contain uppercase, lowercase, number, and special character',
        );
      }
      
      final user = currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      } else {
        throw AuthException(
          code: 'user-not-found',
          message: 'No user is currently signed in',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        code: e.code,
        message: _getErrorMessage(e.code, e.message),
      );
    } catch (e) {
      throw AuthException(
        code: 'unknown-error',
        message: 'An unexpected error occurred: $e',
      );
    }
  }
  
  // Save user data to local storage
  static Future<void> saveUserData({
    required String email,
    required String displayName,
    required bool isLoggedIn,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', isLoggedIn);
      await prefs.setString('userEmail', email);
      await prefs.setString('userName', displayName);
      await prefs.setInt('lastLoginTime', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Warning: Could not save user data to SharedPreferences: $e');
    }
  }
  
  // Get user data from local storage
  static Future<Map<String, dynamic>> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'isLoggedIn': prefs.getBool('isLoggedIn') ?? false,
        'userEmail': prefs.getString('userEmail') ?? '',
        'userName': prefs.getString('userName') ?? '',
        'lastLoginTime': prefs.getInt('lastLoginTime') ?? 0,
      };
    } catch (e) {
      print('Warning: Could not get user data from SharedPreferences: $e');
      return {
        'isLoggedIn': false,
        'userEmail': '',
        'userName': '',
        'lastLoginTime': 0,
      };
    }
  }
  
  // Clear user data from local storage
  static Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Warning: Could not clear user data from SharedPreferences: $e');
    }
  }
  
  // Get error message based on error code
  static String _getErrorMessage(String code, String? message) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email. Please check your email or create a new account.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      case 'weak-password':
        return 'The password provided is too weak. Please use at least 8 characters with uppercase, lowercase, number, and special character.';
      case 'email-already-in-use':
        return 'An account already exists with this email. Please try logging in instead.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';
      case 'email-not-verified':
        return 'Please verify your email before signing in.';
      case 'user-token-expired':
        return 'Your session has expired. Please sign in again.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password.';
      default:
        return message ?? 'An error occurred. Please try again.';
    }
  }
}

// Custom exception class for authentication errors
class AuthException implements Exception {
  final String code;
  final String message;
  
  AuthException({required this.code, required this.message});
  
  @override
  String toString() => 'AuthException: $code - $message';
}

// Result class for authentication operations
class AuthResult {
  final User? user;
  final bool isEmailVerified;
  final String message;
  
  AuthResult({
    this.user,
    required this.isEmailVerified,
    required this.message,
  });
}
