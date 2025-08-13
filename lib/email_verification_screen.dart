import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'welcome_screen.dart';
import 'login_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String displayName;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.displayName,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  bool _isLoading = false;
  bool _isEnglish = true;
  bool _isEmailVerified = false;
  Timer? _verificationCheckTimer;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startAnimations();
    _startVerificationCheck();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _startVerificationCheck() {
    // Check email verification status every 3 seconds
    _verificationCheckTimer = Timer.periodic(const Duration(seconds: 3), (
      timer,
    ) {
      _checkEmailVerification();
    });
  }

  Future<void> _checkEmailVerification() async {
    try {
      // Reload user to get latest verification status
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        setState(() {
          _isEmailVerified = true;
        });

        // Stop the timer
        _verificationCheckTimer?.cancel();

        // Show success message and navigate
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isEnglish
                    ? 'Email verified successfully! Redirecting...'
                    : 'ಇಮೇಲ್ ಯಶಸ್ವಿಯಾಗಿ ದೃಢೀಕರಿಸಲಾಗಿದೆ! ಮರುನಿರ್ದೇಶಿಸಲಾಗುತ್ತಿದೆ...',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          // Wait a bit then navigate
          await Future.delayed(const Duration(seconds: 2));

          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => WelcomeScreen(userName: widget.displayName),
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error checking email verification: $e');
    }
  }

  Future<void> _resendVerificationEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.resendEmailVerification();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEnglish
                  ? 'Verification email sent! Please check your inbox.'
                  : 'ದೃಢೀಕರಣ ಇಮೇಲ್ ಕಳುಹಿಸಲಾಗಿದೆ! ದಯವಿಟ್ಟು ನಿಮ್ಮ ಇನ್‌ಬಾಕ್ಸ್ ಪರಿಶೀಲಿಸಿ.',
            ),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEnglish
                  ? 'Failed to send verification email. Please try again.'
                  : 'ದೃಢೀಕರಣ ಇಮೇಲ್ ಕಳುಹಿಸಲು ವಿಫಲವಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.',
            ),
            backgroundColor: Colors.red,
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

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _verificationCheckTimer?.cancel();
    super.dispose();
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
          Icon(Icons.language, size: 20, color: theme.primaryColor),
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
  String get _pageTitle =>
      _isEnglish ? 'Verify Your Email' : 'ನಿಮ್ಮ ಇಮೇಲ್ ದೃಢೀಕರಿಸಿ';

  String get _subtitle => _isEnglish
      ? 'We\'ve sent a verification link to your email'
      : 'ನಾವು ನಿಮ್ಮ ಇಮೇಲ್‌ಗೆ ದೃಢೀಕರಣ ಲಿಂಕ್ ಕಳುಹಿಸಿದ್ದೇವೆ';

  String get _emailText =>
      _isEnglish ? 'Email: ${widget.email}' : 'ಇಮೇಲ್: ${widget.email}';

  String get _instructionText => _isEnglish
      ? 'Please check your email and click the verification link to activate your account. You won\'t be able to sign in until you verify your email.'
      : 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಇಮೇಲ್ ಪರಿಶೀಲಿಸಿ ಮತ್ತು ನಿಮ್ಮ ಖಾತೆಯನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಲು ದೃಢೀಕರಣ ಲಿಂಕ್ ಕ್ಲಿಕ್ ಮಾಡಿ. ನಿಮ್ಮ ಇಮೇಲ್ ದೃಢೀಕರಿಸುವವರೆಗೆ ನೀವು ಸೈನ್ ಇನ್ ಮಾಡಲು ಸಾಧ್ಯವಿಲ್ಲ.';

  String get _resendButtonText =>
      _isEnglish ? 'Resend Email' : 'ಇಮೇಲ್ ಮರುಕಳುಹಿಸಿ';
  String get _backToLoginText =>
      _isEnglish ? 'Back to Login' : 'ಲಾಗಿನ್‌ಗೆ ಹಿಂತಿರುಗಿ';
  String get _checkingText =>
      _isEnglish ? 'Checking verification...' : 'ದೃಢೀಕರಣ ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Enhanced Language Toggle
              _buildLanguageToggle(theme),

              const SizedBox(height: 40),

              // Enhanced Email Icon with Animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.primaryColor.withOpacity(0.2),
                          theme.primaryColor.withOpacity(0.1),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.mark_email_unread,
                      size: 100,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Enhanced Title
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  _pageTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),

              // Enhanced Subtitle
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  _subtitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[700],
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),

              // Email Display
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, color: theme.primaryColor, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        _emailText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Instructions
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.primaryColor.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    _instructionText,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Verification Status
              if (!_isEmailVerified) ...[
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          color: Colors.orange[700],
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _checkingText,
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Resend Email Button
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
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
                    onPressed: _isLoading ? null : _resendVerificationEmail,
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
                            _resendButtonText,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Back to Login Button
              FadeTransition(
                opacity: _fadeAnimation,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: Text(
                    _backToLoginText,
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
