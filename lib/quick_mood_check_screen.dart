import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class QuickMoodCheckScreen extends StatefulWidget {
  const QuickMoodCheckScreen({super.key});

  @override
  State<QuickMoodCheckScreen> createState() => _QuickMoodCheckScreenState();
}

class _QuickMoodCheckScreenState extends State<QuickMoodCheckScreen> {
  bool _isEnglish = true;
  int _currentMood = 3; // Default to neutral (scale 1-5)
  String _moodDescription = '';
  bool _isLoading = false;
  List<Map<String, dynamic>> _recentMoods = [];

  final List<String> _moodLabels = [
    'Very Low',
    'Low',
    'Neutral',
    'Good',
    'Excellent',
  ];
  final List<String> _moodEmojis = ['😢', '😔', '😐', '🙂', '😊'];
  final List<Color> _moodColors = [
    Colors.red[400]!,
    Colors.orange[400]!,
    Colors.yellow[600]!,
    Colors.lightGreen[400]!,
    Colors.green[400]!,
  ];

  @override
  void initState() {
    super.initState();
    _loadRecentMoods();
  }

  Future<void> _loadRecentMoods() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('quick_mood_entries')
            .orderBy('timestamp', descending: true)
            .limit(7)
            .get();

        setState(() {
          _recentMoods = snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'mood_level': data['mood_level'] ?? 3,
              'mood_description': data['mood_description'] ?? '',
              'timestamp': (data['timestamp'] as Timestamp).toDate(),
            };
          }).toList();
        });
      }
    } catch (e) {
      // Handle error silently for now
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      appBar: AppBar(
        title: Text(
          _isEnglish ? 'Quick Mood Check' : 'ತ್ವರಿತ ಮನಸ್ಥಿತಿ ಪರಿಶೀಲನೆ',
        ),
        backgroundColor: Colors.white,
        foregroundColor: theme.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEnglish ? Icons.language : Icons.language),
            onPressed: () {
              setState(() {
                _isEnglish = !_isEnglish;
              });
            },
            tooltip: _isEnglish ? 'ಕನ್ನಡಕ್ಕೆ ಬದಲಾಯಿಸಿ' : 'Switch to English',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              _isEnglish
                  ? 'How are you feeling right now?'
                  : 'ನೀವು ಇದೀಗ ಹೇಗೆ ಭಾವಿಸುತ್ತಿದ್ದೀರಿ?',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _isEnglish
                  ? 'Take a moment to check in with yourself'
                  : 'ನಿಮ್ಮೊಂದಿಗೆ ಸಂಪರ್ಕಿಸಲು ಒಂದು ಕ್ಷಣ ತೆಗೆದುಕೊಳ್ಳಿ',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Quick Mood Scale
            _buildQuickMoodScale(theme),
            const SizedBox(height: 24),

            // Quick Notes
            _buildQuickNotes(theme),
            const SizedBox(height: 24),

            // Submit Button
            _buildSubmitButton(theme),
            const SizedBox(height: 32),

            // Recent Moods
            if (_recentMoods.isNotEmpty) _buildRecentMoods(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMoodScale(ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? 'Select Your Mood' : 'ನಿಮ್ಮ ಮನಸ್ಥಿತಿಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            // Mood Scale
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                final isSelected = _currentMood == index + 1;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentMood = index + 1;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _moodColors[index]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(35),
                          border: Border.all(
                            color: isSelected
                                ? _moodColors[index]
                                : Colors.grey[400]!,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: _moodColors[index].withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            _moodEmojis[index],
                            style: const TextStyle(fontSize: 35),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _moodLabels[index],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? _moodColors[index]
                              : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickNotes(ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish
                  ? 'Quick Notes (Optional)'
                  : 'ತ್ವರಿತ ಟಿಪ್ಪಣಿಗಳು (ಐಚ್ಛಿಕ)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 2,
              decoration: InputDecoration(
                hintText: _isEnglish
                    ? 'How are you feeling? Any specific thoughts?'
                    : 'ನೀವು ಹೇಗೆ ಭಾವಿಸುತ್ತಿದ್ದೀರಿ? ಯಾವುದೇ ನಿರ್ದಿಷ್ಟ ಆಲೋಚನೆಗಳು?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.primaryColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                _moodDescription = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _moodColors[_currentMood - 1],
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        onPressed: _isLoading ? null : _submitQuickMood,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(_isEnglish ? 'Save Mood' : 'ಮನಸ್ಥಿತಿಯನ್ನು ಉಳಿಸಿ'),
      ),
    );
  }

  Widget _buildRecentMoods(ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? 'Your Recent Moods' : 'ನಿಮ್ಮ ಇತ್ತೀಚಿನ ಮನಸ್ಥಿತಿಗಳು',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            // Mood History
            Column(
              children: _recentMoods.map((mood) {
                final date = DateFormat(
                  'MMM dd, yyyy',
                ).format(mood['timestamp']);
                final time = DateFormat('HH:mm').format(mood['timestamp']);
                final moodLevel = mood['mood_level'] as int;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _moodColors[moodLevel - 1].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _moodColors[moodLevel - 1].withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _moodColors[moodLevel - 1],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            _moodEmojis[moodLevel - 1],
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _moodLabels[moodLevel - 1],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _moodColors[moodLevel - 1],
                              ),
                            ),
                            if (mood['mood_description'].isNotEmpty)
                              Text(
                                mood['mood_description'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitQuickMood() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      print('Debug: Current user: ${user?.uid}'); // Debug log

      if (user != null) {
        print('Debug: Attempting to save mood to Firestore...'); // Debug log

        // Save to Firestore
        final docRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('quick_mood_entries')
            .add({
              'mood_level': _currentMood,
              'mood_description': _moodDescription,
              'timestamp': FieldValue.serverTimestamp(),
              'user_id': user.uid,
              'user_email': user.email,
            });

        print(
          'Debug: Mood saved successfully with ID: ${docRef.id}',
        ); // Debug log

        // Reload recent moods
        await _loadRecentMoods();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isEnglish
                    ? 'Mood saved successfully!'
                    : 'ಮನಸ್ಥಿತಿಯನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಉಳಿಸಲಾಗಿದೆ!',
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Reset form
          setState(() {
            _currentMood = 3;
            _moodDescription = '';
          });
        }
      } else {
        print('Debug: No user found!'); // Debug log
        throw Exception('User not authenticated');
      }
    } catch (e) {
      print('Debug: Error saving mood: $e'); // Debug log
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEnglish
                  ? 'Error saving mood: $e'
                  : 'ಮನಸ್ಥಿತಿಯನ್ನು ಉಳಿಸುವಲ್ಲಿ ದೋಷ: $e',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
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
}
