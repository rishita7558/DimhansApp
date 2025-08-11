import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodTrackerScreen extends StatefulWidget {
  final Map<String, dynamic> assessmentAnswers;
  
  const MoodTrackerScreen({super.key, required this.assessmentAnswers});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  bool _isEnglish = true;
  int _currentMood = 3; // Default to neutral (scale 1-5)
  String _moodDescription = '';
  List<String> _selectedTriggers = [];
  List<String> _selectedCopingStrategies = [];
  bool _isLoading = false;

  final List<String> _moodLabels = ['Very Low', 'Low', 'Neutral', 'Good', 'Excellent'];
  final List<String> _moodEmojis = ['😢', '😔', '😐', '🙂', '😊'];

  final List<String> _triggers = [
    'Stress at work',
    'Family issues',
    'Financial problems',
    'Relationship conflicts',
    'Health concerns',
    'Social pressure',
    'Loneliness',
    'Past trauma',
    'Sleep problems',
    'Physical pain',
    'Boredom',
    'Celebration',
    'Other'
  ];

  final List<String> _copingStrategies = [
    'Deep breathing',
    'Exercise',
    'Talking to someone',
    'Meditation',
    'Journaling',
    'Hobbies',
    'Music',
    'Nature walk',
    'Professional help',
    'Support groups',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      appBar: AppBar(
        title: Text(_isEnglish ? 'Mood Tracker' : 'ಮನಸ್ಥಿತಿ ಟ್ರ್ಯಾಕರ್'),
        backgroundColor: Colors.white,
        foregroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Language Toggle
            _buildLanguageToggle(theme),
            
            // Header
            Text(
              _isEnglish 
                ? 'How are you feeling today?'
                : 'ನೀವು ಇಂದು ಹೇಗೆ ಭಾವಿಸುತ್ತಿದ್ದೀರಿ?',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _isEnglish
                ? 'Track your mood to understand patterns and triggers'
                : 'ನಿಮ್ಮ ಮನಸ್ಥಿತಿಯನ್ನು ಟ್ರ್ಯಾಕ್ ಮಾಡಿ ಮತ್ತು ಅದರ ಮಾದರಿಗಳನ್ನು ಅರ್ಥಮಾಡಿಕೊಳ್ಳಿ',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Mood Scale
            _buildMoodScale(theme),
            const SizedBox(height: 32),

            // Mood Description
            _buildMoodDescription(theme),
            const SizedBox(height: 32),

            // Triggers Section
            _buildTriggersSection(theme),
            const SizedBox(height: 32),

            // Coping Strategies Section
            _buildCopingStrategiesSection(theme),
            const SizedBox(height: 40),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitMoodEntry,
              child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(_isEnglish ? 'Save Mood Entry' : 'ಮನಸ್ಥಿತಿ ನಮೂದನ್ನು ಉಳಿಸಿ'),
            ),
            const SizedBox(height: 16),

            // Skip Button
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(_isEnglish ? 'Skip for now' : 'ಇದೀಗ ಬಿಟ್ಟುಬಿಡಿ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageToggle(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.language,
            size: 16,
            color: theme.primaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            'English',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _isEnglish ? theme.primaryColor : Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.3),
              ),
            ),
            child: Transform.scale(
              scale: 0.7,
              child: Switch(
                value: _isEnglish,
                onChanged: (value) {
                  setState(() {
                    _isEnglish = value;
                  });
                },
                activeColor: theme.primaryColor,
                activeTrackColor: theme.primaryColor.withOpacity(0.3),
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.withOpacity(0.3),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'ಕನ್ನಡ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: !_isEnglish ? theme.primaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodScale(ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? 'Current Mood' : 'ಪ್ರಸ್ತುತ ಮನಸ್ಥಿತಿ',
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
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? theme.primaryColor 
                            : Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isSelected 
                              ? theme.primaryColor 
                              : Colors.grey[400]!,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _moodEmojis[index],
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _moodLabels[index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? theme.primaryColor : Colors.grey[600],
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

  Widget _buildMoodDescription(ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? 'Additional Notes' : 'ಹೆಚ್ಚುವರಿ ಟಿಪ್ಪಣಿಗಳು',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: _isEnglish 
                  ? 'Describe how you\'re feeling or what\'s on your mind...'
                  : 'ನೀವು ಹೇಗೆ ಭಾವಿಸುತ್ತಿದ್ದೀರಿ ಅಥವಾ ನಿಮ್ಮ ಮನಸ್ಸಿನಲ್ಲಿ ಏನಿದೆ ಎಂದು ವಿವರಿಸಿ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.primaryColor),
                ),
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

  Widget _buildTriggersSection(ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? 'What triggered this mood?' : 'ಈ ಮನಸ್ಥಿತಿಯನ್ನು ಯಾವುದು ಪ್ರಚೋದಿಸಿತು?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _triggers.map((trigger) {
                final isSelected = _selectedTriggers.contains(trigger);
                return FilterChip(
                  label: Text(trigger),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTriggers.add(trigger);
                      } else {
                        _selectedTriggers.remove(trigger);
                      }
                    });
                  },
                  selectedColor: theme.primaryColor.withOpacity(0.2),
                  checkmarkColor: theme.primaryColor,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCopingStrategiesSection(ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? 'What helps you cope?' : 'ನಿಮಗೆ ಏನು ಸಹಾಯ ಮಾಡುತ್ತದೆ?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _copingStrategies.map((strategy) {
                final isSelected = _selectedCopingStrategies.contains(strategy);
                return FilterChip(
                  label: Text(strategy),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCopingStrategies.add(strategy);
                      } else {
                        _selectedCopingStrategies.remove(strategy);
                      }
                    });
                  },
                  selectedColor: theme.primaryColor.withOpacity(0.2),
                  checkmarkColor: theme.primaryColor,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitMoodEntry() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Save to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('mood_entries')
            .add({
          'mood_level': _currentMood,
          'mood_description': _moodDescription,
          'triggers': _selectedTriggers,
          'coping_strategies': _selectedCopingStrategies,
          'timestamp': FieldValue.serverTimestamp(),
          'assessment_data': widget.assessmentAnswers,
        });

        // Save to local storage for offline access
        final prefs = await SharedPreferences.getInstance();
        final moodEntries = prefs.getStringList('mood_entries') ?? [];
        final entry = {
          'mood_level': _currentMood.toString(),
          'mood_description': _moodDescription,
          'triggers': _selectedTriggers.join(','),
          'coping_strategies': _selectedCopingStrategies.join(','),
          'timestamp': DateTime.now().toIso8601String(),
        };
        moodEntries.add(entry.toString());
        await prefs.setStringList('mood_entries', moodEntries);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isEnglish 
                ? 'Mood entry saved successfully!'
                : 'ಮನಸ್ಥಿತಿ ನಮೂದನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಉಳಿಸಲಾಗಿದೆ!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          
          // Navigate back to home
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEnglish 
              ? 'Error saving mood entry. Please try again.'
              : 'ಮನಸ್ಥಿತಿ ನಮೂದನ್ನು ಉಳಿಸುವಲ್ಲಿ ದೋಷ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.'),
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