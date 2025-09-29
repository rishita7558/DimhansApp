import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_screen.dart';
import 'welcome_screen.dart';
import 'migrate_users.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isLoading = true;
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    print('AuthWrapper initState called');

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );

    _checkAuthStatus();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthStatus() async {
    print('AuthWrapper: Checking authentication status...');

    try {
      // Start animations
      _fadeController.forward();
      await Future.delayed(const Duration(milliseconds: 300));
      _scaleController.forward();

      // Security check: Ensure Firebase is available before proceeding
      if (!AuthService.isFirebaseAvailable) {
        print(
          'AuthWrapper: Firebase is not available - authentication cannot work',
        );
        setState(() {
          _isLoggedIn = false;
          _isLoading = false;
        });
        return;
      }

      // Check Firebase Auth - this is the ONLY authentication method
      try {
        final firebaseUser = AuthService.currentUser;
        print('AuthWrapper: Firebase user: ${firebaseUser?.uid ?? 'null'}');

        if (firebaseUser != null && AuthService.isEmailVerified) {
          print('AuthWrapper: User is logged in and verified via Firebase');

          // Migrate user to Firestore if not already there
          await UserMigration.migrateUser(firebaseUser);

          setState(() {
            _isLoggedIn = true;
            _userName = firebaseUser.displayName ?? 'User';
            _userEmail = firebaseUser.email ?? '';
            _isLoading = false;
          });
          return;
        } else if (firebaseUser != null && !AuthService.isEmailVerified) {
          print('AuthWrapper: User exists but email not verified');
          // User exists but email not verified, redirect to login
          setState(() {
            _isLoggedIn = false;
            _isLoading = false;
          });
          return;
        }
      } catch (e) {
        print('AuthWrapper: Firebase not available: $e');
        // If Firebase is not available, authentication cannot work
        // This ensures security - no fallback to local storage
        print(
          'AuthWrapper: Firebase authentication required - no fallback available',
        );
      }

      // No fallback authentication - user must authenticate through Firebase
      print(
        'AuthWrapper: User is not logged in - Firebase authentication required',
      );
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
    } catch (e) {
      print('AuthWrapper: Error checking auth status: $e');
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
      'AuthWrapper build called - isLoading: $_isLoading, isLoggedIn: $_isLoggedIn',
    );

    if (_isLoading) {
      return _buildLoadingScreen();
    }

    // Check if Firebase is available
    if (!AuthService.isFirebaseAvailable) {
      return _buildFirebaseErrorScreen();
    }

    if (_isLoggedIn) {
      return WelcomeScreen(userName: _userName);
    }

    return const LoginScreen();
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Enhanced App Logo
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.2),
                        Theme.of(context).primaryColor.withOpacity(0.1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.local_hospital,
                    size: 120,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 40),

                // Enhanced App Title
                Text(
                  'DIMHANS',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 8),

                // Enhanced Subtitle
                Text(
                  'Alcohol Support & Recovery',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 60),

                // Enhanced Loading Indicator
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFirebaseErrorScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error Icon
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 120,
                    color: Colors.red[700],
                  ),
                ),
                const SizedBox(height: 40),

                // Error Title
                Center(
                  child: Text(
                    'Authentication Service Unavailable',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Error Message
                Center(
                  child: Text(
                    'The authentication service is currently not available. This could be due to:\n\n• Network connectivity issues\n• Firebase configuration problems\n• Service maintenance\n\nPlease check your internet connection and try again later.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Retry Button
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    _checkAuthStatus();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
