import 'dart:async';
import 'package:dimhans_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Local user state
  static Map<String, dynamic>? _currentUser;
  static final _authStateController =
      StreamController<Map<String, dynamic>?>.broadcast();

  // Get current user
  static Map<String, dynamic>? get currentUser => _currentUser;

  // Check if user is verified (Always true for now in this simple auth)
  static bool get isEmailVerified => true;

  // Check if user is logged in
  static bool get isLoggedIn => _currentUser != null;

  // Stream of auth state changes
  static Stream<Map<String, dynamic>?> get authStateChanges =>
      _authStateController.stream;

  // Check if Firebase is properly initialized (Mocked to true as we don't need it)
  static bool get isFirebaseAvailable => true;

  // Password validation rules
  static bool isPasswordStrong(String password) {
    if (password.length < 8) return false;
    // Simplified for now, or keep complex regex if desired
    return true;
  }

  // Email validation
  static bool isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  // Initialize: Check for stored token/user
  static Future<void> initialize() async {
    try {
      // ApiService.getHeaders() checks for token in prefs, but we need to load user details too
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      print('AuthService: Initializing... Token found: ${token != null}');

      if (token != null) {
        // Ideally verify token with backend /me endpoint
        // For now, load stored user data
        final userData = await getUserData();
        if (userData['isLoggedIn'] == true) {
          _currentUser = {
            'email': userData['userEmail'],
            'displayName': userData['userName'],
            // 'uid': ... we might need to store ID too
          };
          _authStateController.add(_currentUser);
          print('AuthService: User restored from local storage');
        } else {
          _currentUser = null;
          _authStateController.add(null);
        }
      } else {
        // Explicitly clear user if no token
        _currentUser = null;
        _authStateController.add(null);
        print('AuthService: No token found, user cleared');
      }
    } catch (e) {
      print('Auth init error: $e');
      _currentUser = null;
      _authStateController.add(null);
    }
  }

  // Sign up with email and password
  static Future<AuthResult> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final user = await ApiService.register(email, password, displayName);

      _currentUser = user;
      _authStateController.add(_currentUser);

      await saveUserData(
        email: user['email'],
        displayName: user['displayName'] ?? 'User',
        isLoggedIn: true,
      );

      return AuthResult(
        user: user,
        isEmailVerified: true,
        message: 'Account created successfully!',
      );
    } catch (e) {
      throw AuthException(
        code: 'registration-failed',
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // Sign in with email and password
  static Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await ApiService.login(email, password);

      _currentUser = user;
      _authStateController.add(_currentUser);

      await saveUserData(
        email: user['email'],
        displayName: user['displayName'] ?? 'User',
        isLoggedIn: true,
      );

      return AuthResult(
        user: user,
        isEmailVerified: true,
        message: 'Signed in successfully!',
      );
    } catch (e) {
      throw AuthException(
        code: 'login-failed',
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      _currentUser = null;
      _authStateController.add(null);
      await clearUserData();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Resend email verification (Stub for now)
  static Future<void> resendEmailVerification() async {
    // TODO: Implement backend email verification
    print('Email verification not implemented yet');
  }

  // Reset password (Stub for now)
  static Future<void> resetPassword(String email) async {
    // TODO: Implement backend password reset
    print('Password reset not implemented yet');
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
      await prefs.setInt(
        'lastLoginTime',
        DateTime.now().millisecondsSinceEpoch,
      );
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
  final Map<String, dynamic>? user; // Changed from User? to Map
  final bool isEmailVerified;
  final String message;

  AuthResult({this.user, required this.isEmailVerified, required this.message});
}
