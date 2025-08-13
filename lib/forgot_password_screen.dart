import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isEmailSent = false;
  bool _isEnglish = true;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.resetPassword(_emailController.text.trim());
      
      setState(() {
        _isEmailSent = true;
        _isLoading = false;
      });
    } on AuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      
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
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEnglish 
              ? 'An unexpected error occurred: $e'
              : 'ಅನಿರೀಕ್ಷಿತ ದೋಷ ಸಂಭವಿಸಿದೆ: $e'),
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
    }
  }

  void _goBackToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  // Language toggle widget
  Widget _buildLanguageToggle(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() => _isEnglish = true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isEnglish ? theme.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'English',
                style: TextStyle(
                  color: _isEnglish ? Colors.white : theme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _isEnglish = false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: !_isEnglish ? theme.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'ಕನ್ನಡ',
                style: TextStyle(
                  color: !_isEnglish ? Colors.white : theme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced text field builder
  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
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
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(prefixIcon, color: Theme.of(context).primaryColor),
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

  // Language-specific text getters
  String get _pageTitle => _isEnglish ? 'Forgot Password' : 'ಪಾಸ್‌ವರ್ಡ್ ಮರೆತಿರುವಿರಾ';
  String get _subtitle => _isEnglish 
    ? 'Enter your email to receive a password reset link'
    : 'ಪಾಸ್‌ವರ್ಡ್ ರೀಸೆಟ್ ಲಿಂಕ್ ಪಡೆಯಲು ನಿಮ್ಮ ಇಮೇಲ್ ನಮೂದಿಸಿ';
  String get _emailLabel => _isEnglish ? 'Email' : 'ಇಮೇಲ್';
  String get _emailHint => _isEnglish ? 'Enter your email address' : 'ನಿಮ್ಮ ಇಮೇಲ್ ವಿಳಾಸವನ್ನು ನಮೂದಿಸಿ';
  String get _resetButtonText => _isEnglish ? 'Send Reset Link' : 'ರೀಸೆಟ್ ಲಿಂಕ್ ಕಳುಹಿಸಿ';
  String get _backToLoginText => _isEnglish ? 'Back to Login' : 'ಲಾಗಿನ್‌ಗೆ ಹಿಂತಿರುಗಿ';
  String get _successTitle => _isEnglish ? 'Reset Link Sent!' : 'ರೀಸೆಟ್ ಲಿಂಕ್ ಕಳುಹಿಸಲಾಗಿದೆ!';
  String get _successMessage => _isEnglish 
    ? 'We\'ve sent a password reset link to your email. Please check your inbox and follow the instructions to reset your password.'
    : 'ನಾವು ನಿಮ್ಮ ಇಮೇಲ್‌ಗೆ ಪಾಸ್‌ವರ್ಡ್ ರೀಸೆಟ್ ಲಿಂಕ್ ಕಳುಹಿಸಿದ್ದೇವೆ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಇನ್‌ಬಾಕ್ಸ್ ಪರಿಶೀಲಿಸಿ ಮತ್ತು ನಿಮ್ಮ ಪಾಸ್‌ವರ್ಡ್ ರೀಸೆಟ್ ಮಾಡಲು ಸೂಚನೆಗಳನ್ನು ಅನುಸರಿಸಿ.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_isEmailSent) {
      return _buildSuccessScreen(theme);
    }

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
                
                // Language Toggle
                _buildLanguageToggle(theme),
                
                const SizedBox(height: 40),
                
                // App Logo/Icon
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
                    Icons.lock_reset,
                    size: 80,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Title
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
                
                // Subtitle
                Text(
                  _subtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // Email Field
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
                const SizedBox(height: 40),
                
                // Reset Button
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
                    onPressed: _isLoading ? null : _resetPassword,
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
                          _resetButtonText,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Back to Login Link
                TextButton(
                  onPressed: _goBackToLogin,
                  child: Text(
                    _backToLoginText,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
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

  Widget _buildSuccessScreen(ThemeData theme) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Icon
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 120,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 40),

                // Success Title
                Center(
                  child: Text(
                    _successTitle,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Success Message
                Center(
                  child: Text(
                    _successMessage,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),

                // Back to Login Button
                ElevatedButton.icon(
                  onPressed: _goBackToLogin,
                  icon: const Icon(Icons.login),
                  label: Text(_backToLoginText),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
