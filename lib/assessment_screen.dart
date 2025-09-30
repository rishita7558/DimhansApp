import 'package:flutter/material.dart';
import 'package:dimhans_app/learn_screen.dart'; // Added import for LearnScreen
import 'package:url_launcher/url_launcher.dart';
import 'mood_tracker_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  String lang = 'en';
  int _step = 0;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _answers = {
    'q1': null,
    'q2': null,
    'q3': '',
    'q4': <String>[],
    'q5': null,
  };

  final List<String> _reasons = [
    'Peer Pressure',
    'Recreation',
    'Financial Issues',
    'Personal Reasons',
    'Family Issues',
    'Friends Pressure',
    'Work Pressure',
    'Stress',
    'Tension',
    'Sleep Issues',
    'Other',
  ];

  void _next() {
    if (_step == 2) {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() => _step++);
      }
    } else if (_step == 5) {
      // Save assessment data when user reaches the final step
      _saveAssessmentData();
      setState(() => _step++);
    } else {
      setState(() => _step++);
    }
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  Future<void> _saveAssessmentData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('Debug: Saving assessment for user: ${user.uid}');
        print('Debug: Assessment answers: $_answers');

        // Calculate assessment score
        int score = 0;
        if (_answers['q1'] == 'Yes') score += 1;

        switch (_answers['q2']) {
          case 'Daily':
            score += 4;
            break;
          case 'Weekly':
            score += 3;
            break;
          case 'Monthly':
            score += 2;
            break;
          case 'Rarely':
            score += 1;
            break;
        }

        if (_answers['q4'] is List) {
          score += (_answers['q4'] as List).length;
        }

        if (_answers['q5'] == 'No') score += 2;

        print('Debug: Calculated score: $score');

        // Save to Firestore
        final docRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('assessments')
            .add({
              'score': score,
              'answers': _answers,
              'timestamp': FieldValue.serverTimestamp(),
            });

        print('Debug: Assessment saved successfully with ID: ${docRef.id}');

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Assessment completed and saved successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        print('Debug: No user logged in');
      }
    } catch (e) {
      print('Error saving assessment data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving assessment: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _questionStep(
          'Do you consume alcohol?',
          Column(
            children: [
              RadioListTile<String>(
                title: const Text('Yes'),
                value: 'Yes',
                groupValue: _answers['q1'],
                onChanged: (val) => setState(() => _answers['q1'] = val),
              ),
              RadioListTile<String>(
                title: const Text('No'),
                value: 'No',
                groupValue: _answers['q1'],
                onChanged: (val) => setState(() => _answers['q1'] = val),
              ),
            ],
          ),
          onNext: _answers['q1'] != null ? _next : null,
          isFirst: true,
        );
      case 1:
        return _questionStep(
          'Your Gender',
          Column(
            children: [
              RadioListTile<String>(
                title: const Text('Male'),
                value: 'Male',
                groupValue: _answers['q2'],
                onChanged: (val) => setState(() => _answers['q2'] = val),
              ),
              RadioListTile<String>(
                title: const Text('Female'),
                value: 'Female',
                groupValue: _answers['q2'],
                onChanged: (val) => setState(() => _answers['q2'] = val),
              ),
              RadioListTile<String>(
                title: const Text('Other'),
                value: 'Other',
                groupValue: _answers['q2'],
                onChanged: (val) => setState(() => _answers['q2'] = val),
              ),
            ],
          ),
          onNext: _answers['q2'] != null ? _next : null,
          onBack: _back,
        );
      case 2:
        return _questionStep(
          'Your Age',
          Form(
            key: _formKey,
            child: TextFormField(
              initialValue: _answers['q3'],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter your age'),
              onChanged: (val) => setState(() => _answers['q3'] = val),
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please enter your age';
                final age = int.tryParse(val);
                if (age == null || age < 0 || age > 120) {
                  return 'Enter a valid age';
                }
                return null;
              },
            ),
          ),
          onNext:
              (_answers['q3'] != null && _answers['q3'].toString().isNotEmpty)
              ? _next
              : null,
          onBack: _back,
        );
      case 3:
        return _questionStep(
          'What made you consume alcohol?',
          Column(
            children: _reasons
                .map(
                  (opt) => CheckboxListTile(
                    title: Text(opt),
                    value: (_answers['q4'] as List<String>).contains(opt),
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          (_answers['q4'] as List<String>).add(opt);
                        } else {
                          (_answers['q4'] as List<String>).remove(opt);
                        }
                      });
                    },
                  ),
                )
                .toList(),
          ),
          onNext: (_answers['q4'] as List).isNotEmpty ? _next : null,
          onBack: _back,
        );
      case 4:
        return _questionStep(
          'Do you want to learn craving management skills?',
          Column(
            children: [
              RadioListTile<String>(
                title: const Text('Yes'),
                value: 'Yes',
                groupValue: _answers['q5'],
                onChanged: (val) => setState(() => _answers['q5'] = val),
              ),
              RadioListTile<String>(
                title: const Text('No'),
                value: 'No',
                groupValue: _answers['q5'],
                onChanged: (val) => setState(() => _answers['q5'] = val),
              ),
            ],
          ),
          onNext: _answers['q5'] != null ? _next : null,
          onBack: _back,
        );
      case 5:
        return _questionStep(
          'Do you want to talk to someone?',
          Column(
            children: [
              ListTile(
                title: const Text('Call TeleManas (Dial 14416)'),
                leading: const Icon(Icons.phone),
                onTap: () async {
                  final uri = Uri.parse('tel:14416');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
              ),
              ListTile(
                title: const Text('Find Nearby Psychiatrist'),
                leading: const Icon(Icons.location_on),
                onTap: () async {
                  // Open Google Maps with a search for psychiatrists near the user
                  final url = Uri.parse(
                    'https://www.google.com/maps/search/psychiatrist+near+me/',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
              ),
              ListTile(
                title: const Text('Contact Our Team (dummy)'),
                leading: const Icon(Icons.email),
                onTap: () async {
                  final uri = Uri.parse(
                    'mailto:support@dimhans.org?subject=Support%20Request',
                  );
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
              ),
            ],
          ),
          onNext: _next,
          onBack: _back,
          isLast: true,
        );
      case 6:
        return _resultScreen();
      default:
        return Center(
          child: Text(
            'Something went wrong. Please restart the assessment.',
            style: const TextStyle(color: Colors.red, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        );
    }
  }

  Widget _questionStep(
    String question,
    Widget child, {
    VoidCallback? onNext,
    VoidCallback? onBack,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          question,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        child,
        const SizedBox(height: 32),
        if (!isFirst)
          OutlinedButton(onPressed: onBack, child: const Text('Back')),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: onNext,
          child: Text(isLast ? 'Submit' : 'Next'),
        ),
      ],
    );
  }

  Widget _resultScreen() {
    String message = 'Thank you for completing the assessment!';
    if (_answers['q1'] == 'Yes') {
      message +=
          '\nWe recommend exploring craving management skills and talking to a professional.';
    } else {
      message += '\nStay informed and support others!';
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Assessment Result',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Always show mood tracker button to save assessment data
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MoodTrackerScreen(assessmentAnswers: _answers),
              ),
            );
          },
          icon: const Icon(Icons.mood),
          label: const Text('Track Your Mood'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Back to Home'),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            // Navigate to Learn screen with Awareness tab (index 2)
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const LearnScreen(initialTabIndex: 2),
              ),
            );
          },
          child: const Text('Learn More / Get Support'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Self-Assessment')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'English',
                  style: TextStyle(
                    fontWeight: lang == 'en'
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                Switch(
                  value: lang == 'kn',
                  onChanged: (v) => setState(() => lang = v ? 'kn' : 'en'),
                ),
                Text(
                  'Kannada',
                  style: TextStyle(
                    fontWeight: lang == 'kn'
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: lang == 'en'
                ? Center(
                    child: SingleChildScrollView(
                      child: Container(
                        width: 500,
                        padding: const EdgeInsets.all(24),
                        child: _buildStep(),
                      ),
                    ),
                  )
                : const AssessmentKannadaContent(),
          ),
        ],
      ),
    );
  }
}

class AssessmentKannadaContent extends StatelessWidget {
  const AssessmentKannadaContent({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Text("""
ನನಗೆ ವೈದ್ಯಕೀಯ ಸಹಾಯ ಬೇಕೇ ಎಂಬುದು ನನಗೆ ಹೇಗೆ ತಿಳಿಯುವುದು?

ಕೆಳಗಿನ ಈ ಪ್ರಶ್ನೆಗಳ ಬಗ್ಗೆ ಯೋಚಿಸುವಷ್ಟು ಸಮರ್ಥ ಸಮಯ ತಗೊಳ್ಳಿ...

೧. ನಮ್ಮ ವೈದ್ಯಕೀಯವನ್ನು ಕಡಿಮೆ ಮಾಡುವದರಿಂದ ನನಗೆ ಲಾಭವಿದೆಯಾ?

೨. ನನ್ನ ವೈದ್ಯಕೀಯ ಕಾರಣದಿಂದಾಗಿ ಇತರರಿಂದ ನನಗೆ ಟೀಕೆಗಳಿಂದ ತಟ್ಟು ಬಂದಿದೆಯಾ?

೩. ನನ್ನ ಹೃದಯ ಬಗ್ಗೆ ತೀವ್ರತ ಭಾವನೆಗಳಿವೆಯೆ?

೪. ಕಣ್ಣ ತಿರುಗುವಂತೆ ಬೆನ್ನುಗೆ ನೋವು ವೈದ್ಯಕೀಯವಾಗಿತ್ತಾ?

ಮೇಲಿನ ಪ್ರಶ್ನೆಗಳಲ್ಲಿ ಒಂದಕ್ಕೆ ನಿಮ್ಮ ಹೌದು ಉತ್ತರಿದರೆ, ನಿಮಗೆ ಕೊಡಬೇಕಾದ ಸಹಾಯ ಇರಬಹುದು, ಮತ್ತು ಮೇಲಿನ ಎರೆಡು ಅಥವಾ ಹೆಚ್ಚು ಪ್ರಶ್ನೆಗಳಿಗೆ ಹೌದು ಎಂದಾದರೆ, ನಿಮಗೆ ಕೊಡಬೇಕಾದ ಸಹಾಯ ಇನ್ನೂ ಸೂಕ್ತತೆ ಹಚ್ಚುವ ವೈದ್ಯಕೀಯ ಸಹಾಯದ ಅಗತ್ಯವಿದೆ.
""", style: const TextStyle(fontSize: 18)),
    );
  }
}
