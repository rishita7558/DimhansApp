import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CravingSkillsScreen extends StatefulWidget {
  const CravingSkillsScreen({super.key});

  @override
  State<CravingSkillsScreen> createState() => _CravingSkillsScreenState();
}

class _CravingSkillsScreenState extends State<CravingSkillsScreen> {
  bool _isEnglish = true;

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // Language toggle widget
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

  // Content getters
  String get _pageTitle => _isEnglish 
    ? 'Craving Management Skills'
    : 'ಮದ್ಯದ ಹುಚ್ಚು ನಿರ್ವಹಣಾ ಕೌಶಲ್ಯಗಳು';

  String get _understandingCravingsTitle => _isEnglish
    ? 'Understanding Cravings'
    : 'ಮದ್ಯದ ಹುಚ್ಚುಗಳನ್ನು ಅರ್ಥಮಾಡಿಕೊಳ್ಳುವುದು';

  String get _understandingCravingsContent => _isEnglish
    ? 'Cravings are intense urges to drink alcohol that can feel overwhelming. They typically last 15-30 minutes and come in waves. Understanding that cravings are temporary and manageable is the first step to overcoming them.'
    : 'ಮದ್ಯದ ಹುಚ್ಚುಗಳು ಮದ್ಯ ಕುಡಿಯುವ ತೀವ್ರವಾದ ಆಸೆಗಳು, ಅವು ಅತ್ಯಂತ ಬಲವಾಗಿ ಅನುಭವಿಸಬಹುದು. ಅವು ಸಾಮಾನ್ಯವಾಗಿ 15-30 ನಿಮಿಷಗಳ ಕಾಲ ಇರುತ್ತವೆ ಮತ್ತು ಅಲೆಗಳ ರೂಪದಲ್ಲಿ ಬರುತ್ತವೆ. ಮದ್ಯದ ಹುಚ್ಚುಗಳು ತಾತ್ಕಾಲಿಕ ಮತ್ತು ನಿರ್ವಹಣೀಯ ಎಂದು ಅರ್ಥಮಾಡಿಕೊಳ್ಳುವುದು ಅವುಗಳನ್ನು ಜಯಿಸುವ ಮೊದಲ ಹೆಜ್ಜೆ.';

  String get _immediateTechniquesTitle => _isEnglish
    ? 'Immediate Craving Control Techniques'
    : 'ತ್ವರಿತ ಮದ್ಯದ ಹುಚ್ಚು ನಿಯಂತ್ರಣ ತಂತ್ರಗಳು';

  List<Map<String, String>> get _immediateTechniques => _isEnglish
    ? [
        {
          'title': 'Deep Breathing (4-7-8 Technique)',
          'description': 'Inhale for 4 seconds, hold for 7, exhale for 8. Repeat 4 times.',
          'icon': '🫁'
        },
        {
          'title': 'Urge Surfing',
          'description': 'Observe the craving like a wave - it rises, peaks, and falls naturally.',
          'icon': '🌊'
        },
        {
          'title': '5-4-3-2-1 Grounding',
          'description': 'Name 5 things you see, 4 you touch, 3 you hear, 2 you smell, 1 you taste.',
          'icon': '🎯'
        },
        {
          'title': 'Cold Water Splash',
          'description': 'Splash cold water on your face or hold ice cubes to shock your system.',
          'icon': '💧'
        },
        {
          'title': 'Physical Activity',
          'description': 'Do 10 jumping jacks, push-ups, or take a brisk 5-minute walk.',
          'icon': '🏃‍♂️'
        },
        {
          'title': 'Call a Support Person',
          'description': 'Reach out to a trusted friend, family member, or sponsor immediately.',
          'icon': '📞'
        }
      ]
    : [
        {
          'title': 'ಆಳವಾದ ಉಸಿರಾಟ (4-7-8 ತಂತ್ರ)',
          'description': '4 ಸೆಕೆಂಡುಗಳ ಕಾಲ ಉಸಿರೆಳೆದುಕೊಳ್ಳಿ, 7 ಸೆಕೆಂಡುಗಳ ಕಾಲ ಹಿಡಿದಿಡಿ, 8 ಸೆಕೆಂಡುಗಳ ಕಾಲ ಉಸಿರು ಬಿಡಿ. 4 ಬಾರಿ ಪುನರಾವರ್ತಿಸಿ.',
          'icon': '🫁'
        },
        {
          'title': 'ಆಸೆಯ ಅಲೆ ಸವಾರಿ',
          'description': 'ಮದ್ಯದ ಹುಚ್ಚನ್ನು ಅಲೆಯಂತೆ ಗಮನಿಸಿ - ಅದು ಏರುತ್ತದೆ, ಶಿಖರವನ್ನು ತಲುಪುತ್ತದೆ ಮತ್ತು ಸ್ವಾಭಾವಿಕವಾಗಿ ಇಳಿಯುತ್ತದೆ.',
          'icon': '🌊'
        },
        {
          'title': '5-4-3-2-1 ನೆಲಗಟ್ಟುವಿಕೆ',
          'description': 'ನೀವು ನೋಡುವ 5 ವಸ್ತುಗಳು, ಮುಟ್ಟುವ 4 ವಸ್ತುಗಳು, ಕೇಳುವ 3 ಧ್ವನಿಗಳು, ವಾಸನೆ ಮಾಡುವ 2 ವಸ್ತುಗಳು, ರುಚಿ ನೋಡುವ 1 ವಸ್ತು ಹೆಸರಿಸಿ.',
          'icon': '🎯'
        },
        {
          'title': 'ತಣ್ಣನೆಯ ನೀರಿನ ಸಿಂಪಡಿಸುವಿಕೆ',
          'description': 'ನಿಮ್ಮ ಮುಖದ ಮೇಲೆ ತಣ್ಣನೆಯ ನೀರನ್ನು ಸಿಂಪಡಿಸಿ ಅಥವಾ ನಿಮ್ಮ ವ್ಯವಸ್ಥೆಯನ್ನು ಆಘಾತಗೊಳಿಸಲು ಮಂಜುಗಡ್ಡೆಗಳನ್ನು ಹಿಡಿದಿಡಿ.',
          'icon': '💧'
        },
        {
          'title': 'ದೈಹಿಕ ಚಟುವಟಿಕೆ',
          'description': '10 ಜಂಪಿಂಗ್ ಜ್ಯಾಕ್‌ಗಳು, ಪುಷ್-ಅಪ್‌ಗಳು ಮಾಡಿ ಅಥವಾ 5 ನಿಮಿಷಗಳ ವೇಗದ ನಡಿಗೆ ಮಾಡಿ.',
          'icon': '🏃‍♂️'
        },
        {
          'title': 'ಬೆಂಬಲ ವ್ಯಕ್ತಿಯನ್ನು ಕರೆ ಮಾಡಿ',
          'description': 'ತ್ವರಿತವಾಗಿ ನಂಬಲರ್ಹ ಸ್ನೇಹಿತ, ಕುಟುಂಬದ ಸದಸ್ಯ ಅಥವಾ ಸ್ಪಾನ್ಸರ್‌ಗೆ ಸಂಪರ್ಕಿಸಿ.',
          'icon': '📞'
        }
      ];

  String get _longTermStrategiesTitle => _isEnglish
    ? 'Long-term Craving Management Strategies'
    : 'ದೀರ್ಘಕಾಲಿಕ ಮದ್ಯದ ಹುಚ್ಚು ನಿರ್ವಹಣಾ ತಂತ್ರಗಳು';

  List<Map<String, String>> get _longTermStrategies => _isEnglish
    ? [
        {
          'title': 'Identify Triggers',
          'description': 'Keep a journal to track what situations, emotions, or people trigger your cravings.',
          'icon': '📝'
        },
        {
          'title': 'Develop Healthy Routines',
          'description': 'Create daily schedules with exercise, hobbies, and social activities to replace drinking time.',
          'icon': '📅'
        },
        {
          'title': 'Build a Support Network',
          'description': 'Join support groups, maintain relationships with sober friends, and involve family in your recovery.',
          'icon': '👥'
        },
        {
          'title': 'Practice Mindfulness',
          'description': 'Learn meditation, yoga, or other mindfulness techniques to manage stress and emotions.',
          'icon': '🧘‍♂️'
        },
        {
          'title': 'Avoid High-Risk Situations',
          'description': 'Stay away from bars, parties, or social events where alcohol is the main focus.',
          'icon': '⚠️'
        },
        {
          'title': 'Have a Relapse Prevention Plan',
          'description': 'Create a detailed plan for what to do if you experience strong cravings or feel like drinking.',
          'icon': '🛡️'
        }
      ]
    : [
        {
          'title': 'ಕಾರಣಗಳನ್ನು ಗುರುತಿಸಿ',
          'description': 'ಯಾವ ಪರಿಸ್ಥಿತಿಗಳು, ಭಾವನೆಗಳು ಅಥವಾ ಜನರು ನಿಮ್ಮ ಮದ್ಯದ ಹುಚ್ಚುಗಳನ್ನು ಪ್ರಚೋದಿಸುತ್ತವೆ ಎಂದು ಟ್ರ್ಯಾಕ್ ಮಾಡಲು ಡೈರಿ ಇಡಿ.',
          'icon': '📝'
        },
        {
          'title': 'ಆರೋಗ್ಯಕರ ದಿನಚರಿಗಳನ್ನು ಬೆಳೆಸಿ',
          'description': 'ಮದ್ಯಪಾನದ ಸಮಯವನ್ನು ಬದಲಾಯಿಸಲು ವ್ಯಾಯಾಮ, ಹವ್ಯಾಸಗಳು ಮತ್ತು ಸಾಮಾಜಿಕ ಚಟುವಟಿಕೆಗಳೊಂದಿಗೆ ದೈನಂದಿನ ವೇಳಾಪಟ್ಟಿಗಳನ್ನು ರಚಿಸಿ.',
          'icon': '📅'
        },
        {
          'title': 'ಬೆಂಬಲ ಜಾಲವನ್ನು ನಿರ್ಮಿಸಿ',
          'description': 'ಬೆಂಬಲ ಗುಂಪುಗಳಿಗೆ ಸೇರಿ, ಮದ್ಯರಹಿತ ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಂಬಂಧಗಳನ್ನು ಕಾಯ್ದುಕೊಳ್ಳಿ ಮತ್ತು ನಿಮ್ಮ ಪುನರ್ವಸತಿಯಲ್ಲಿ ಕುಟುಂಬವನ್ನು ಒಳಗೊಳ್ಳಿ.',
          'icon': '👥'
        },
        {
          'title': 'ಸ್ಮರಣೆಯನ್ನು ಅಭ್ಯಾಸ ಮಾಡಿ',
          'description': 'ಒತ್ತಡ ಮತ್ತು ಭಾವನೆಗಳನ್ನು ನಿರ್ವಹಿಸಲು ಧ್ಯಾನ, ಯೋಗ ಅಥವಾ ಇತರ ಸ್ಮರಣೆ ತಂತ್ರಗಳನ್ನು ಕಲಿಯಿರಿ.',
          'icon': '🧘‍♂️'
        },
        {
          'title': 'ಅಪಾಯಕಾರಿ ಪರಿಸ್ಥಿತಿಗಳನ್ನು ತಪ್ಪಿಸಿ',
          'description': 'ಮದ್ಯವು ಮುಖ್ಯ ಗಮನವಾಗಿರುವ ಬಾರ್‌ಗಳು, ಪಾರ್ಟಿಗಳು ಅಥವಾ ಸಾಮಾಜಿಕ ಕಾರ್ಯಕ್ರಮಗಳಿಂದ ದೂರವಿರಿ.',
          'icon': '⚠️'
        },
        {
          'title': 'ಮರುಪತನ ತಡೆಗಟ್ಟುವ ಯೋಜನೆಯನ್ನು ಹೊಂದಿರಿ',
          'description': 'ನೀವು ಬಲವಾದ ಮದ್ಯದ ಹುಚ್ಚುಗಳನ್ನು ಅನುಭವಿಸಿದರೆ ಅಥವಾ ಕುಡಿಯಲು ಭಾವಿಸಿದರೆ ಏನು ಮಾಡಬೇಕೆಂದು ವಿವರವಾದ ಯೋಜನೆಯನ್ನು ರಚಿಸಿ.',
          'icon': '🛡️'
        }
      ];

  String get _emergencyPlanTitle => _isEnglish
    ? 'Emergency Craving Response Plan'
    : 'ತುರ್ತು ಮದ್ಯದ ಹುಚ್ಚು ಪ್ರತಿಕ್ರಿಯೆ ಯೋಜನೆ';

  String get _emergencyPlanContent => _isEnglish
    ? 'When cravings feel overwhelming, follow this emergency plan:\n\n1. STOP - Pause and take 3 deep breaths\n2. DISTANCE - Remove yourself from the situation\n3. DISTRACT - Engage in a healthy activity\n4. DELAY - Wait 15 minutes before making any decision\n5. DECIDE - Choose your health over temporary relief'
    : 'ಮದ್ಯದ ಹುಚ್ಚುಗಳು ಅತ್ಯಂತ ಬಲವಾಗಿ ಅನುಭವಿಸಿದಾಗ, ಈ ತುರ್ತು ಯೋಜನೆಯನ್ನು ಅನುಸರಿಸಿ:\n\n1. ನಿಲ್ಲಿಸಿ - ನಿಲ್ಲಿಸಿ ಮತ್ತು 3 ಆಳವಾದ ಉಸಿರುಗಳನ್ನು ತೆಗೆದುಕೊಳ್ಳಿ\n2. ದೂರವಿರಿ - ಪರಿಸ್ಥಿತಿಯಿಂದ ನಿಮ್ಮನ್ನು ತೆಗೆದುಕೊಳ್ಳಿ\n3. ಗಮನ ತಿರುಗಿಸಿ - ಆರೋಗ್ಯಕರ ಚಟುವಟಿಕೆಯಲ್ಲಿ ತೊಡಗಿಸಿಕೊಳ್ಳಿ\n4. ವಿಳಂಬ - ಯಾವುದೇ ನಿರ್ಧಾರ ತೆಗೆದುಕೊಳ್ಳುವ ಮೊದಲು 15 ನಿಮಿಷಗಳ ಕಾಯಿರಿ\n5. ನಿರ್ಧರಿಸಿ - ತಾತ್ಕಾಲಿಕ ಪರಿಹಾರಕ್ಕಿಂತ ನಿಮ್ಮ ಆರೋಗ್ಯವನ್ನು ಆರಿಸಿ';

  String get _watchLearnTitle => _isEnglish
    ? 'Watch & Learn'
    : 'ನೋಡಿ ಮತ್ತು ಕಲಿಯಿರಿ';

  List<Map<String, String>> get _videos => [
    {
      'title': _isEnglish ? 'Urge Surfing Technique' : 'ಆಸೆಯ ಅಲೆ ಸವಾರಿ ತಂತ್ರ',
      'url': 'https://www.youtube.com/watch?v=5h3CtiG99yE&t=2s'
    },
    {
      'title': _isEnglish ? 'Breathing Exercise for Craving Control' : 'ಮದ್ಯದ ಹುಚ್ಚು ನಿಯಂತ್ರಣಕ್ಕಾಗಿ ಉಸಿರಾಟ ವ್ಯಾಯಾಮ',
      'url': 'https://www.youtube.com/watch?v=FJJazKtH_9I'
    },
    {
      'title': _isEnglish ? 'Meditation for Addiction Recovery' : 'ವ್ಯಸನ ಪುನರ್ವಸತಿಗಾಗಿ ಸ್ಮರಣೆ',
      'url': 'https://youtu.be/jfhMlfxaIvw?si=Tg9GD4eQu8AMsSm1'
    },
    {
      'title': _isEnglish ? 'Relapse Prevention Strategies' : 'ಮರುಪತನ ತಡೆಗಟ್ಟುವ ತಂತ್ರಗಳು',
      'url': 'https://youtu.be/Z1jtmFlNB-c?si=cNJ3Z_fV11QdBbcW'
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildLanguageToggle(theme),
          
          // Page Title
          Text(
            _pageTitle,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Understanding Cravings Section
          _buildSectionCard(
            theme,
            title: _understandingCravingsTitle,
            content: _understandingCravingsContent,
            icon: Icons.psychology,
            color: Colors.blue,
          ),
          const SizedBox(height: 20),

          // Immediate Techniques Section
          _buildTechniquesSection(
            theme,
            title: _immediateTechniquesTitle,
            techniques: _immediateTechniques,
            icon: Icons.flash_on,
            color: Colors.orange,
          ),
          const SizedBox(height: 20),

          // Long-term Strategies Section
          _buildTechniquesSection(
            theme,
            title: _longTermStrategiesTitle,
            techniques: _longTermStrategies,
            icon: Icons.trending_up,
            color: Colors.green,
          ),
          const SizedBox(height: 20),

          // Emergency Plan Section
          _buildSectionCard(
            theme,
            title: _emergencyPlanTitle,
            content: _emergencyPlanContent,
            icon: Icons.emergency,
            color: Colors.red,
          ),
          const SizedBox(height: 20),

          // Watch & Learn Section
          _buildVideoSection(theme),
        ],
      ),
    );
  }

  Widget _buildSectionCard(ThemeData theme, {
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechniquesSection(ThemeData theme, {
    required String title,
    required List<Map<String, String>> techniques,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...techniques.map((technique) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    technique['icon']!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          technique['title']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          technique['description']!,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoSection(ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.withOpacity(0.1),
              Colors.purple.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.play_circle_fill, color: Colors.purple, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _watchLearnTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._videos.map((video) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.play_circle_fill, color: Colors.purple),
                  title: Text(
                    video['title']!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    video['url']!,
                    style: const TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                  onTap: () => _openUrl(video['url']!),
                ),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
} 