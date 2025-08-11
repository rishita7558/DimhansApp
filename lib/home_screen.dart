import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'mood_tracker_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onStartAssessment;
  final VoidCallback onLearnPublic;
  final VoidCallback onLearnStudents;
  const HomeScreen({super.key, required this.onStartAssessment, required this.onLearnPublic, required this.onLearnStudents});

  void _showPledgeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const PledgeDialog();
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Clear stored preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // Navigate back to auth wrapper
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      // Handle logout error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error logging out'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showQuickMoodEntry(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MoodTrackerScreen(
          assessmentAnswers: {
            'q1': 'Yes', // Assume user has completed assessment
            'q2': 'User',
            'q3': '25',
            'q4': ['Quick Entry'],
            'q5': 'Yes',
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 22,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF2D2154)),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Center(
                  child: Image.asset(
                    'assets/9636542.webp',
                    height: 220,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Your Health,\nOur Priority',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D2154),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Empowering you with knowledge, support, and tools to understand alcohol, its effects, and make healthier choices.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF8B8B8B),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: onStartAssessment,
                    child: const Text('Start Self-Assessment (Alcohol users only)'),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () => _showPledgeDialog(context),
                    child: const Text('Pledge'),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Quick Mood Entry Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9800),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () => _showQuickMoodEntry(context),
                    icon: const Icon(Icons.mood),
                    label: const Text('Quick Mood Check'),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6C63FF),
                      side: const BorderSide(color: Color(0xFF6C63FF), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: onLearnPublic,
                    child: const Text('Learn about Alcohol Addiction (for Public)'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6C63FF),
                      side: const BorderSide(color: Color(0xFF6C63FF), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: onLearnStudents,
                    child: const Text('Learn about Alcohol Addiction (for Students)'),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PledgeDialog extends StatefulWidget {
  const PledgeDialog({super.key});

  @override
  State<PledgeDialog> createState() => _PledgeDialogState();
}

class _PledgeDialogState extends State<PledgeDialog> {
  bool _isEnglish = true;
  int _pledgeCount = 0;

  @override
  void initState() {
    super.initState();
    _loadPledgeCount();
  }

  Future<void> _loadPledgeCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pledgeCount = prefs.getInt('pledge_count') ?? 0;
    });
  }

  Future<void> _incrementPledgeCount() async {
    final prefs = await SharedPreferences.getInstance();
    final newCount = _pledgeCount + 1;
    await prefs.setInt('pledge_count', newCount);
    setState(() {
      _pledgeCount = newCount;
    });
  }

  String get _pledgeText => _isEnglish
      ? '''Dear Friends,  
All we understand that change must begin with ourselves first, it is best example for others. 
Hence, I have understood clearly that, taking any kind of drug will affect on my health.          
I pledge that I will not use any kind of drug in my life. I pledge that I will do everything 
possible to the best of my ability to make my country drug free  
Jai Hind!'''
      : '''ಪ್ರಿಯ ಸ್ನೇಹಿತರೇ,  
ನಾವೆಲ್ಲರೂ ಅರ್ಥಮಾಡಿಕೊಳ್ಳುತ್ತೇವೆ, ಬದಲಾವಣೆಯು ಮೊದಲು ನಮ್ಮಿಂದಲೇ ಪ್ರಾರಂಭವಾಗಬೇಕು, ಇದು ಇತರರಿಗೆ ಉತ್ತಮ ಉದಾಹರಣೆ. 
ಆದ್ದರಿಂದ, ಯಾವುದೇ ರೀತಿಯ ಮಾದಕ ವಸ್ತುಗಳನ್ನು ಸೇವಿಸುವುದು ನನ್ನ ಆರೋಗ್ಯದ ಮೇಲೆ ಪರಿಣಾಮ ಬೀರುತ್ತದೆ ಎಂದು ನಾನು ಸ್ಪಷ್ಟವಾಗಿ ಅರ್ಥಮಾಡಿಕೊಂಡಿದ್ದೇನೆ.          
ನನ್ನ ಜೀವನದಲ್ಲಿ ಯಾವುದೇ ರೀತಿಯ ಮಾದಕ ವಸ್ತುಗಳನ್ನು ಬಳಸುವುದಿಲ್ಲ ಎಂದು ನಾನು ಪ್ರತಿಜ್ಞೆ ಮಾಡುತ್ತೇನೆ. ನನ್ನ ದೇಶವನ್ನು ಮಾದಕ ವಸ್ತುರಹಿತವಾಗಿಸಲು ನನ್ನ ಸಾಮರ್ಥ್ಯದ ಅತ್ಯುತ್ತಮ ಮಟ್ಟದಲ್ಲಿ ಎಲ್ಲವನ್ನೂ ಮಾಡುತ್ತೇನೆ ಎಂದು ನಾನು ಪ್ರತಿಜ್ಞೆ ಮಾಡುತ್ತೇನೆ  
ಜೈ ಹಿಂದ್!''';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF3EFFF), Colors.white],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Language Toggle
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.language,
                    size: 16,
                    color: Color(0xFF6C63FF),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'English',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _isEnglish ? const Color(0xFF6C63FF) : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF6C63FF).withOpacity(0.3),
                      ),
                    ),
                    child: Transform.scale(
                      scale: 0.6,
                      child: Switch(
                        value: _isEnglish,
                        onChanged: (value) {
                          setState(() {
                            _isEnglish = value;
                          });
                        },
                        activeColor: const Color(0xFF6C63FF),
                        activeTrackColor: const Color(0xFF6C63FF).withOpacity(0.3),
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ಕನ್ನಡ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: !_isEnglish ? const Color(0xFF6C63FF) : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            // Title
            Text(
              _isEnglish ? 'Pledge' : 'ಪ್ರತಿಜ್ಞೆ',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2154),
              ),
            ),
            const SizedBox(height: 12),
            
            // Pledge Count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.people,
                    size: 16,
                    color: Color(0xFF4CAF50),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isEnglish 
                      ? '$_pledgeCount people have taken the pledge'
                      : '$_pledgeCount ಜನರು ಪ್ರತಿಜ್ಞೆ ಮಾಡಿದ್ದಾರೆ',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Pledge Text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF6C63FF).withOpacity(0.2),
                ),
              ),
              child: Text(
                _pledgeText,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 24),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6C63FF),
                      side: const BorderSide(color: Color(0xFF6C63FF), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(_isEnglish ? 'Cancel' : 'ರದ್ದುಮಾಡಿ'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      // Increment pledge count
                      await _incrementPledgeCount();
                      
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isEnglish 
                              ? 'Thank you for taking the pledge! Stay strong and drug-free!' 
                              : 'ಪ್ರತಿಜ್ಞೆ ಮಾಡಿದಕ್ಕಾಗಿ ಧನ್ಯವಾದಗಳು! ಬಲಶಾಲಿಯಾಗಿ ಮತ್ತು ಮಾದಕ ವಸ್ತುರಹಿತವಾಗಿ ಇರಿ!',
                          ),
                          backgroundColor: const Color(0xFF4CAF50),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text(_isEnglish ? 'I Pledge' : 'ನಾನು ಪ್ರತಿಜ್ಞೆ ಮಾಡುತ್ತೇನೆ'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 