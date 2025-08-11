import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'welcome_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> with TickerProviderStateMixin {
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
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutCubic,
    ));
    
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
      
      // Check Firebase Auth first (if available)
      try {
        final firebaseUser = FirebaseAuth.instance.currentUser;
        print('AuthWrapper: Firebase user: ${firebaseUser?.uid ?? 'null'}');
        
        if (firebaseUser != null) {
          print('AuthWrapper: User is logged in via Firebase');
          setState(() {
            _isLoggedIn = true;
            _userName = firebaseUser.displayName ?? 'User';
            _userEmail = firebaseUser.email ?? '';
            _isLoading = false;
          });
          return;
        }
      } catch (e) {
        print('AuthWrapper: Firebase not available: $e');
        // Continue with SharedPreferences check
      }
      
      // Check SharedPreferences as fallback
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      final userName = prefs.getString('userName') ?? '';
      final userEmail = prefs.getString('userEmail') ?? '';
      final lastLoginTime = prefs.getInt('lastLoginTime') ?? 0;
      
      print('AuthWrapper: SharedPreferences - isLoggedIn: $isLoggedIn, userName: $userName');
      
      if (isLoggedIn && userName.isNotEmpty) {
        // Check if session is still valid (7 days)
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        final sessionValid = (currentTime - lastLoginTime) < (7 * 24 * 60 * 60 * 1000);
        
        if (sessionValid) {
          print('AuthWrapper: Session is valid, user is logged in');
          setState(() {
            _isLoggedIn = true;
            _userName = userName;
            _userEmail = userEmail;
            _isLoading = false;
          });
          return;
        } else {
          print('AuthWrapper: Session expired, clearing preferences');
          await prefs.clear();
        }
      }
      
      print('AuthWrapper: User is not logged in');
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
    print('AuthWrapper build called - isLoading: $_isLoading, isLoggedIn: $_isLoggedIn');
    
    if (_isLoading) {
      return _buildLoadingScreen();
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
} 