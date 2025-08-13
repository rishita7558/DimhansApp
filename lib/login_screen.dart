import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'welcome_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isEnglish = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      print('Starting login process...');
      print('Email: ${_emailController.text.trim()}');
      
      // Use the new AuthService for secure authentication
      final result = await AuthService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      print('User logged in successfully: ${result.user?.uid}');

      if (result.user != null && result.isEmailVerified) {
        // Save user data to local storage
        await AuthService.saveUserData(
          email: result.user!.email ?? '',
          displayName: result.user!.displayName ?? 'User',
          isLoggedIn: true,
        );

        if (mounted) {
          print('Navigating to WelcomeScreen...');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => WelcomeScreen(
              userName: result.user!.displayName ?? 'User',
            )),
          );
        }
      }
    } on AuthException catch (e) {
      print('AuthException: ${e.code} - ${e.message}');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      print('Unexpected error during login: $e');
      String errorMessage = _isEnglish 
        ? 'An unexpected error occurred: $e'
        : 'ಅನಿರೀಕ್ಷಿತ ದೋಷ ಸಂಭವಿಸಿದೆ: $e';
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Enhanced language toggle widget
  Widget _buildLanguageToggle(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor.withOpacity(0.1),
            theme.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.language,
            size: 20,
            color: theme.primaryColor,
          ),
          const SizedBox(width: 12),
          Text(
            'English',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _isEnglish ? theme.primaryColor : Colors.grey[600],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Transform.scale(
              scale: 0.8,
              child: Switch(
                value: _isEnglish,
                onChanged: (value) {
                  setState(() {
                    _isEnglish = value;
                  });
                },
                activeColor: theme.primaryColor,
                activeTrackColor: theme.primaryColor.withOpacity(0.3),
                inactiveThumbColor: Colors.grey[400],
                inactiveTrackColor: Colors.grey[300],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'ಕನ್ನಡ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: !_isEnglish ? theme.primaryColor : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced content getters
  String get _pageTitle => _isEnglish 
    ? 'Welcome Back'
    : 'ಮತ್ತೆ ಸುಸ್ವಾಗತ';

  String get _subtitle => _isEnglish
    ? 'Sign in to continue your recovery journey'
    : 'ನಿಮ್ಮ ಪುನರ್ವಸತಿ ಪ್ರಯಾಣವನ್ನು ಮುಂದುವರಿಸಲು ಸೈನ್ ಇನ್ ಮಾಡಿ';

  String get _emailLabel => _isEnglish ? 'Email' : 'ಇಮೇಲ್';
  String get _passwordLabel => _isEnglish ? 'Password' : 'ಪಾಸ್‌ವರ್ಡ್';
  String get _signInText => _isEnglish ? 'Sign In' : 'ಸೈನ್ ಇನ್';
  String get _dontHaveAccountText => _isEnglish ? 'Don\'t have an account?' : 'ಖಾತೆ ಇಲ್ಲವೇ?';
  String get _createAccountText => _isEnglish ? 'Create Account' : 'ಖಾತೆ ರಚಿಸಿ';
  String get _forgotPasswordText => _isEnglish ? 'Forgot Password?' : 'ಪಾಸ್‌ವರ್ಡ್ ಮರೆತಿರುವಿರಾ?';
  String get _emailHint => _isEnglish ? 'Enter your email' : 'ನಿಮ್ಮ ಇಮೇಲ್ ನಮೂದಿಸಿ';
  String get _passwordHint => _isEnglish ? 'Enter your password' : 'ನಿಮ್ಮ ಪಾಸ್‌ವರ್ಡ್ ನಮೂದಿಸಿ';

  @override
  Widget build(BuildContext context) {
    print('LoginScreen build called');
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // Enhanced Language Toggle
                _buildLanguageToggle(theme),
                
                // Enhanced App Logo/Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColor.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.login,
                    size: 80,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Enhanced Title
                Text(
                  _pageTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                
                // Enhanced Subtitle
                Text(
                  _subtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // Enhanced Email Field
                _buildEnhancedTextField(
                  controller: _emailController,
                  labelText: _emailLabel,
                  hintText: _emailHint,
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return _isEnglish ? 'Please enter your email' : 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಇಮೇಲ್ ನಮೂದಿಸಿ';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                      return _isEnglish ? 'Please enter a valid email' : 'ದಯವಿಟ್ಟು ಮಾನ್ಯ ಇಮೇಲ್ ನಮೂದಿಸಿ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Enhanced Password Field
                _buildEnhancedTextField(
                  controller: _passwordController,
                  labelText: _passwordLabel,
                  hintText: _passwordHint,
                  prefixIcon: Icons.lock,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: theme.primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _isEnglish ? 'Please enter your password' : 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಪಾಸ್‌ವರ್ಡ್ ನಮೂದಿಸಿ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isEnglish 
                            ? 'Forgot password feature coming soon!'
                            : 'ಮರೆತ ಪಾಸ್‌ವರ್ಡ್ ವೈಶಿಷ್ಟ್ಯವು ಶೀಘ್ರದಲ್ಲೇ ಬರುತ್ತದೆ!'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    child: Text(
                      _forgotPasswordText,
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Enhanced Sign In Button
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        theme.primaryColor,
                        theme.primaryColor.withOpacity(0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          _signInText,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Enhanced Create Account Link
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.primaryColor.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _dontHaveAccountText,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const RegisterScreen()),
                          );
                        },
                        child: Text(
                          _createAccountText,
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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

  // Enhanced text field builder
  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(prefixIcon, color: Theme.of(context).primaryColor),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red[300]!),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }
} 