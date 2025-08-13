import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnScreen extends StatelessWidget {
  final int initialTabIndex;
  const LearnScreen({super.key, this.initialTabIndex = 0});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: initialTabIndex,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3EFFF),
        appBar: AppBar(
          title: const Text('Learn About Alcohol Addiction'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'For Public'),
              Tab(text: 'For Students'),
              Tab(text: 'Awareness'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LearnTabContentWithLang(audience: 'Public'),
            LearnTabContentWithLang(audience: 'Students'),
            AwarenessTabContent(),
          ],
        ),
      ),
    );
  }
}

class LearnTabContentWithLang extends StatefulWidget {
  final String audience;
  const LearnTabContentWithLang({required this.audience, super.key});
  @override
  State<LearnTabContentWithLang> createState() => _LearnTabContentWithLangState();
}

class _LearnTabContentWithLangState extends State<LearnTabContentWithLang> {
  bool _isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return LearnTabContent(audience: widget.audience, isEnglish: _isEnglish, onLanguageChanged: (value) {
      setState(() {
        _isEnglish = value;
      });
    });
  }
}

class LearnTabContent extends StatelessWidget {
  final String audience;
  final bool isEnglish;
  final Function(bool) onLanguageChanged;
  const LearnTabContent({required this.audience, required this.isEnglish, required this.onLanguageChanged, super.key});

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Language toggle
    Widget languageToggle = Container(
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
              color: isEnglish ? theme.primaryColor : Colors.grey,
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
                value: isEnglish,
                onChanged: onLanguageChanged,
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
              color: !isEnglish ? theme.primaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );

    // Content based on language and audience
    final info = isEnglish
        ? (audience == 'Public'
        ? 'Alcohol can impact your physical and mental health, relationships, and work. Excessive drinking increases the risk of liver disease, heart problems, cancer, and mental health issues. It can also lead to accidents, violence, and family or work difficulties. Remember, even moderate drinking can have risks, and support is available for those who want to cut down or quit.'
            : 'Alcohol use among students can negatively affect academics, friendships, and future goals. It impairs memory, concentration, and decision-making, leading to poor grades and risky behaviors. Underage drinking can disrupt brain development and increase the risk of addiction later in life. Choosing to stay alcohol-free helps you stay focused, healthy, and in control of your future.')
        : (audience == 'Public'
            ? 'ಮದ್ಯವು ನಿಮ್ಮ ದೈಹಿಕ ಮತ್ತು ಮಾನಸಿಕ ಆರೋಗ್ಯ, ಸಂಬಂಧಗಳು ಮತ್ತು ಕೆಲಸದ ಮೇಲೆ ಪರಿಣಾಮ ಬೀರಬಹುದು. ಅತಿಯಾದ ಮದ್ಯಪಾನವು ಯಕೃತ್ತಿನ ರೋಗ, ಹೃದಯದ ಸಮಸ್ಯೆಗಳು, ಕ್ಯಾನ್ಸರ್ ಮತ್ತು ಮಾನಸಿಕ ಆರೋಗ್ಯದ ಸಮಸ್ಯೆಗಳ ಅಪಾಯವನ್ನು ಹೆಚ್ಚಿಸುತ್ತದೆ. ಇದು ಅಪಘಾತಗಳು, ಹಿಂಸೆ ಮತ್ತು ಕುಟುಂಬ ಅಥವಾ ಕೆಲಸದ ತೊಂದರೆಗಳಿಗೆ ಕಾರಣವಾಗಬಹುದು. ಸ್ಮರಿಸಿ, ಸಮತೋಲಿತ ಮದ್ಯಪಾನವೂ ಸಹ ಅಪಾಯಗಳನ್ನು ಹೊಂದಿರಬಹುದು, ಮತ್ತು ಕಡಿಮೆ ಮಾಡಲು ಅಥವಾ ನಿಲ್ಲಿಸಲು ಬಯಸುವವರಿಗೆ ಬೆಂಬಲ ಲಭ್ಯವಿದೆ.'
            : 'ವಿದ್ಯಾರ್ಥಿಗಳಲ್ಲಿ ಮದ್ಯಪಾನವು ಶೈಕ್ಷಣಿಕ, ಸ್ನೇಹ ಮತ್ತು ಭವಿಷ್ಯದ ಗುರಿಗಳ ಮೇಲೆ ನಕಾರಾತ್ಮಕ ಪರಿಣಾಮ ಬೀರಬಹುದು. ಇದು ನೆನಪು, ಏಕಾಗ್ರತೆ ಮತ್ತು ನಿರ್ಧಾರ ತೆಗೆದುಕೊಳ್ಳುವ ಸಾಮರ್ಥ್ಯವನ್ನು ಕುಗ್ಗಿಸುತ್ತದೆ, ಕಳಪೆ ಶ್ರೇಣಿಗಳು ಮತ್ತು ಅಪಾಯಕಾರಿ ವರ್ತನೆಗಳಿಗೆ ಕಾರಣವಾಗುತ್ತದೆ. ವಯಸ್ಸಿಗಿಂತ ಮುಂಚಿನ ಮದ್ಯಪಾನವು ಮೆದುಳಿನ ಬೆಳವಣಿಗೆಯನ್ನು ಅಡ್ಡಿಪಡಿಸಬಹುದು ಮತ್ತು ನಂತರ ಜೀವನದಲ್ಲಿ ವ್ಯಸನದ ಅಪಾಯವನ್ನು ಹೆಚ್ಚಿಸಬಹುದು. ಮದ್ಯರಹಿತವಾಗಿರಲು ಆಯ್ಕೆ ಮಾಡುವುದು ನಿಮ್ಮನ್ನು ಕೇಂದ್ರೀಕೃತ, ಆರೋಗ್ಯಕರ ಮತ್ತು ನಿಮ್ಮ ಭವಿಷ್ಯದ ಮೇಲೆ ನಿಯಂತ್ರಣವನ್ನು ಹೊಂದಿರಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ.');

    final misconceptions = isEnglish
        ? (audience == 'Public'
        ? [
            'Myth: Alcohol relieves stress.\nFact: It can worsen anxiety and depression.',
            'Myth: Only daily drinkers get addicted.\nFact: Binge drinking is also risky.',
            'Myth: Beer or wine is safer than hard liquor.\nFact: All types of alcohol can be harmful.',
            'Myth: You can sober up quickly with coffee or a cold shower.\nFact: Only time can reduce blood alcohol levels.',
            'Myth: Alcohol makes you more social.\nFact: It can impair judgment and lead to risky behavior.',
            'Myth: Alcohol is not addictive.\nFact: Alcohol can be highly addictive for some people.',
          ]
        : [
            'Myth: Drinking makes you look cool or grown-up.\nFact: Alcohol can harm your health and reputation.',
            'Myth: Everyone drinks at parties.\nFact: Many students choose not to drink.',
            'Myth: Alcohol helps you do better in school.\nFact: It impairs memory and concentration.',
            'Myth: You can control your drinking easily.\nFact: Alcohol lowers self-control and can lead to risky choices.',
                'Myth: It\'s safe to drink if your friends are doing it.\nFact: Peer pressure can lead to dangerous situations.',
                'Myth: Underage drinking is not a big deal.\nFact: It\'s illegal and can have serious consequences.',
              ])
        : (audience == 'Public'
            ? [
                'ಮಿಥ್ಯ: ಮದ್ಯವು ಒತ್ತಡವನ್ನು ನಿವಾರಿಸುತ್ತದೆ.\nಸತ್ಯ: ಇದು ಆತಂಕ ಮತ್ತು ಖಿನ್ನತೆಯನ್ನು ಹೆಚ್ಚಿಸಬಹುದು.',
                'ಮಿಥ್ಯ: ಕೇವಲ ದೈನಂದಿನ ಕುಡಿಕರು ವ್ಯಸನಿಗಳಾಗುತ್ತಾರೆ.\nಸತ್ಯ: ಅತಿಯಾದ ಕುಡಿತವೂ ಸಹ ಅಪಾಯಕಾರಿ.',
                'ಮಿಥ್ಯ: ಬಿಯರ್ ಅಥವಾ ವೈನ್ ಗಟ್ಟಿ ಮದ್ಯಕ್ಕಿಂತ ಸುರಕ್ಷಿತ.\nಸತ್ಯ: ಎಲ್ಲಾ ರೀತಿಯ ಮದ್ಯವೂ ಹಾನಿಕಾರಕವಾಗಿರಬಹುದು.',
                'ಮಿಥ್ಯ: ಕಾಫಿ ಅಥವಾ ತಣ್ಣನೆಯ ಸ್ನಾನದಿಂದ ತ್ವರಿತವಾಗಿ ಮತ್ತೆ ಸ್ವಸ್ಥರಾಗಬಹುದು.\nಸತ್ಯ: ಕೇವಲ ಸಮಯವು ರಕ್ತದ ಮದ್ಯದ ಮಟ್ಟವನ್ನು ಕಡಿಮೆ ಮಾಡಬಹುದು.',
                'ಮಿಥ್ಯ: ಮದ್ಯವು ನಿಮ್ಮನ್ನು ಹೆಚ್ಚು ಸಾಮಾಜಿಕವಾಗಿಸುತ್ತದೆ.\nಸತ್ಯ: ಇದು ತೀರ್ಪಿನ ಸಾಮರ್ಥ್ಯವನ್ನು ಕುಗ್ಗಿಸಬಹುದು ಮತ್ತು ಅಪಾಯಕಾರಿ ವರ್ತನೆಗೆ ಕಾರಣವಾಗಬಹುದು.',
                'ಮಿಥ್ಯ: ಮದ್ಯವು ವ್ಯಸನಕಾರಕವಲ್ಲ.\nಸತ್ಯ: ಮದ್ಯವು ಕೆಲವು ಜನರಿಗೆ ಹೆಚ್ಚು ವ್ಯಸನಕಾರಕವಾಗಿರಬಹುದು.',
              ]
            : [
                'ಮಿಥ್ಯ: ಕುಡಿಯುವುದು ನಿಮ್ಮನ್ನು ತಂಪು ಅಥವಾ ವಯಸ್ಕರಂತೆ ಕಾಣಿಸುತ್ತದೆ.\nಸತ್ಯ: ಮದ್ಯವು ನಿಮ್ಮ ಆರೋಗ್ಯ ಮತ್ತು ಖ್ಯಾತಿಗೆ ಹಾನಿ ಮಾಡಬಹುದು.',
                'ಮಿಥ್ಯ: ಎಲ್ಲರೂ ಪಾರ್ಟಿಗಳಲ್ಲಿ ಕುಡಿಯುತ್ತಾರೆ.\nಸತ್ಯ: ಅನೇಕ ವಿದ್ಯಾರ್ಥಿಗಳು ಕುಡಿಯದಿರಲು ಆಯ್ಕೆ ಮಾಡುತ್ತಾರೆ.',
                'ಮಿಥ್ಯ: ಮದ್ಯವು ಶಾಲೆಯಲ್ಲಿ ಉತ್ತಮವಾಗಿ ಮಾಡಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ.\nಸತ್ಯ: ಇದು ನೆನಪು ಮತ್ತು ಏಕಾಗ್ರತೆಯನ್ನು ಕುಗ್ಗಿಸುತ್ತದೆ.',
                'ಮಿಥ್ಯ: ನಿಮ್ಮ ಕುಡಿತವನ್ನು ಸುಲಭವಾಗಿ ನಿಯಂತ್ರಿಸಬಹುದು.\nಸತ್ಯ: ಮದ್ಯವು ಸ್ವಯಂ ನಿಯಂತ್ರಣವನ್ನು ಕಡಿಮೆ ಮಾಡುತ್ತದೆ ಮತ್ತು ಅಪಾಯಕಾರಿ ಆಯ್ಕೆಗಳಿಗೆ ಕಾರಣವಾಗಬಹುದು.',
                'ಮಿಥ್ಯ: ನಿಮ್ಮ ಸ್ನೇಹಿತರು ಮಾಡುತ್ತಿದ್ದರೆ ಕುಡಿಯುವುದು ಸುರಕ್ಷಿತ.\nಸತ್ಯ: ಸಮಾನರ ಒತ್ತಡವು ಅಪಾಯಕಾರಿ ಪರಿಸ್ಥಿತಿಗಳಿಗೆ ಕಾರಣವಾಗಬಹುದು.',
                'ಮಿಥ್ಯ: ವಯಸ್ಸಿಗಿಂತ ಮುಂಚಿನ ಕುಡಿತವು ದೊಡ್ಡ ವಿಷಯವಲ್ಲ.\nಸತ್ಯ: ಇದು ಕಾನೂನುಬಾಹಿರ ಮತ್ತು ಗಂಭೀರ ಪರಿಣಾಮಗಳನ್ನು ಹೊಂದಬಹುದು.',
              ]);

    final symptoms = isEnglish
        ? (audience == 'Public'
        ? [
            'Frequent or excessive drinking',
            'Neglecting responsibilities',
            'Withdrawal symptoms',
            'Loss of control over drinking',
            'Relationship or work problems',
            'Health issues (liver, heart, etc.)',
          ]
        : [
            'Declining academic performance',
            'Loss of interest in studies or activities',
            'Frequent absenteeism or tardiness',
            'Mood swings or irritability',
            'Problems with friends or family',
            'Risky behaviors (driving, fights, etc.)',
            'Neglecting responsibilities',
            'Withdrawal symptoms',
              ])
        : (audience == 'Public'
            ? [
                'ಆಗಾಗ್ಗೆ ಅಥವಾ ಅತಿಯಾದ ಕುಡಿತ',
                'ಜವಾಬ್ದಾರಿಗಳನ್ನು ನಿರ್ಲಕ್ಷಿಸುವುದು',
                'ವಿಮುಕ್ತಿ ಲಕ್ಷಣಗಳು',
                'ಕುಡಿತದ ಮೇಲೆ ನಿಯಂತ್ರಣ ಕಳೆದುಕೊಳ್ಳುವುದು',
                'ಸಂಬಂಧ ಅಥವಾ ಕೆಲಸದ ಸಮಸ್ಯೆಗಳು',
                'ಆರೋಗ್ಯದ ಸಮಸ್ಯೆಗಳು (ಯಕೃತ್ತು, ಹೃದಯ, ಇತ್ಯಾದಿ)',
              ]
            : [
                'ಅಧ್ಯಯನದ ಕಾರ್ಯಕ್ಷಮತೆಯಲ್ಲಿ ಇಳಿಕೆ',
                'ಅಧ್ಯಯನ ಅಥವಾ ಚಟುವಟಿಕೆಗಳಲ್ಲಿ ಆಸಕ್ತಿ ಕಳೆದುಕೊಳ್ಳುವುದು',
                'ಆಗಾಗ್ಗೆ ಗೈರುಹಾಜರಿ ಅಥವಾ ತಡವಾಗಿ ಬರುವುದು',
                'ಮನಸ್ಥಿತಿಯ ಬದಲಾವಣೆಗಳು ಅಥವಾ ಕಿರಿಕಿರಿ',
                'ಸ್ನೇಹಿತರು ಅಥವಾ ಕುಟುಂಬದೊಂದಿಗೆ ಸಮಸ್ಯೆಗಳು',
                'ಅಪಾಯಕಾರಿ ವರ್ತನೆಗಳು (ವಾಹನ ಓಡಿಸುವುದು, ಕಾದಾಟಗಳು, ಇತ್ಯಾದಿ)',
                'ಜವಾಬ್ದಾರಿಗಳನ್ನು ನಿರ್ಲಕ್ಷಿಸುವುದು',
                'ವಿಮುಕ್ತಿ ಲಕ್ಷಣಗಳು',
              ]);

    final treatments = isEnglish
        ? (audience == 'Public'
        ? [
            'Counseling and therapy',
            'Support groups (Alcoholics Anonymous)',
            'Medication (if prescribed by a doctor)',
            'Lifestyle changes and support',
            'Family and community support',
            'Rehabilitation programs',
          ]
        : [
            'School counseling services',
            'Talking to a trusted teacher or adult',
            'Peer support groups',
            'Youth helplines and online resources',
            'Family involvement and support',
            'Professional therapy if needed',
              ])
        : (audience == 'Public'
            ? [
                'ಸಲಹೆ ಮತ್ತು ಚಿಕಿತ್ಸೆ',
                'ಬೆಂಬಲ ಗುಂಪುಗಳು (ಅಲ್ಕೊಹಾಲಿಕ್ಸ್ ಅನಾನಿಮಸ್)',
                'ಔಷಧಿ (ವೈದ್ಯರಿಂದ ನಿರ್ದೇಶಿಸಿದರೆ)',
                'ಜೀವನಶೈಲಿಯ ಬದಲಾವಣೆಗಳು ಮತ್ತು ಬೆಂಬಲ',
                'ಕುಟುಂಬ ಮತ್ತು ಸಮುದಾಯದ ಬೆಂಬಲ',
                'ಪುನರ್ವಸತಿ ಕಾರ್ಯಕ್ರಮಗಳು',
              ]
            : [
                'ಶಾಲಾ ಸಲಹಾ ಸೇವೆಗಳು',
                'ನಂಬಲರ್ಹ ಶಿಕ್ಷಕ ಅಥವಾ ವಯಸ್ಕರೊಂದಿಗೆ ಮಾತನಾಡುವುದು',
                'ಸಮಾನರ ಬೆಂಬಲ ಗುಂಪುಗಳು',
                'ಯುವರ ಸಹಾಯ ಲೈನ್‌ಗಳು ಮತ್ತು ಆನ್‌ಲೈನ್ ಸಂಪನ್ಮೂಲಗಳು',
                'ಕುಟುಂಬದ ಒಳಗೊಳ್ಳುವಿಕೆ ಮತ್ತು ಬೆಂಬಲ',
                'ಅಗತ್ಯವಿದ್ದರೆ ವೃತ್ತಿಪರ ಚಿಕಿತ್ಸೆ',
              ]);

    final video = audience == 'Public'
        ? {'title': isEnglish ? 'Alcohol & Health (YouTube)' : 'ಮದ್ಯ ಮತ್ತು ಆರೋಗ್ಯ (ಯೂಟ್ಯೂಬ್)', 'url': 'https://youtu.be/9IizjqPQyK8?si=ciRJqwFSLmiyuWpP'}
        : {'title': isEnglish ? "Alcohol's effect on Teenage Brain" : 'ವಯಸ್ಕರ ಮೆದುಳಿನ ಮೇಲೆ ಮದ್ಯದ ಪರಿಣಾಮ', 'url': 'https://youtu.be/EY37BFmVxwQ?si=pevzou4keD9SYtK9'};

    final mindImpactTitle = isEnglish ? 'Impact on the Mind (Mental & Emotional Health)' : 'ಮನಸ್ಸಿನ ಮೇಲೆ ಪರಿಣಾಮ (ಮಾನಸಿಕ ಮತ್ತು ಭಾವನಾತ್ಮಕ ಆರೋಗ್ಯ)';
    final bodyImpactTitle = isEnglish ? 'Impact on the Body (Physical Health)' : 'ದೇಹದ ಮೇಲೆ ಪರಿಣಾಮ (ದೈಹಿಕ ಆರೋಗ್ಯ)';

    final mindImpactPoints = isEnglish
        ? [
            'Alcohol reduces your ability to think clearly and make decisions.',
            'Memory Loss – Long-term use can lead to memory problems and blackouts.',
            'Mood Changes – It can cause mood swings, anxiety, and depression issues',
            'Addiction – Leads to physical and psychological dependence issues. Increases the risk of mental disorders like depression, psychosis, or suicidal thoughts.',
            'Aggressive Behavior – Can lead to irritability, violence, or risky behavior.',
            'Reduced Focus – Affects concentration, learning, and mental sharpness.',
          ]
        : [
            'ಮದ್ಯವು ಸ್ಪಷ್ಟವಾಗಿ ಯೋಚಿಸುವ ಮತ್ತು ನಿರ್ಧಾರ ತೆಗೆದುಕೊಳ್ಳುವ ಸಾಮರ್ಥ್ಯವನ್ನು ಕುಗ್ಗಿಸುತ್ತದೆ.',
            'ನೆನಪಿನ ನಷ್ಟ – ದೀರ್ಘಕಾಲದ ಬಳಕೆಯು ನೆನಪಿನ ಸಮಸ್ಯೆಗಳು ಮತ್ತು ಮರೆವುಗಳಿಗೆ ಕಾರಣವಾಗಬಹುದು.',
            'ಮನಸ್ಥಿತಿಯ ಬದಲಾವಣೆಗಳು – ಇದು ಮನಸ್ಥಿತಿಯ ಬದಲಾವಣೆಗಳು, ಆತಂಕ ಮತ್ತು ಖಿನ್ನತೆಯ ಸಮಸ್ಯೆಗಳಿಗೆ ಕಾರಣವಾಗಬಹುದು',
            'ವ್ಯಸನ – ದೈಹಿಕ ಮತ್ತು ಮಾನಸಿಕ ಅವಲಂಬನೆಯ ಸಮಸ್ಯೆಗಳಿಗೆ ಕಾರಣವಾಗುತ್ತದೆ. ಖಿನ್ನತೆ, ಮನೋವಿಕೃತಿ ಅಥವಾ ಆತ್ಮಹತ್ಯೆಯ ಯೋಚನೆಗಳಂತಹ ಮಾನಸಿಕ ಅಸ್ವಸ್ಥತೆಗಳ ಅಪಾಯವನ್ನು ಹೆಚ್ಚಿಸುತ್ತದೆ.',
            'ಆಕ್ರಮಣಕಾರಿ ವರ್ತನೆ – ಕಿರಿಕಿರಿ, ಹಿಂಸೆ ಅಥವಾ ಅಪಾಯಕಾರಿ ವರ್ತನೆಗೆ ಕಾರಣವಾಗಬಹುದು.',
            'ಕಡಿಮೆ ಏಕಾಗ್ರತೆ – ಏಕಾಗ್ರತೆ, ಕಲಿಕೆ ಮತ್ತು ಮಾನಸಿಕ ಚುರಿಕೆತನದ ಮೇಲೆ ಪರಿಣಾಮ ಬೀರುತ್ತದೆ.',
          ];

    final bodyImpactPoints = isEnglish
        ? [
            'Liver Damage issues– Causes fatty liver, hepatitis, and cirrhosis (permanent liver failure).',
            'Heart Problems – Leads to high blood pressure, irregular heartbeat, and heart disease.',
            'Digestive Issues – Irritates stomach lining, causes ulcers, vomiting, and poor absorption of nutrients.',
            'Weakens Immune System – Makes the body more prone to infections.',
            'Cancer Risk – Increases the risk of cancers (mouth, throat, liver, breast, etc.).',
            'Weight Gain – High in calories, alcohol can lead to obesity.',
            'Sleep Disruption – Disturbs normal sleep patterns and leads to fatigue.',
            'Sexual Dysfunction issues– Can lead to reduced libido and sexual performance.',
            'Nerve Damage – Chronic use can damage nerves',
            'Pancreatitis – Inflammation of the pancreas causing severe abdominal pain.',
          ]
        : [
            'ಯಕೃತ್ತಿನ ಹಾನಿ ಸಮಸ್ಯೆಗಳು – ಕೊಬ್ಬಿನ ಯಕೃತ್ತು, ಹೆಪಟೈಟಿಸ್ ಮತ್ತು ಸಿರೋಸಿಸ್ (ಶಾಶ್ವತ ಯಕೃತ್ತಿನ ವೈಫಲ್ಯ) ಕಾರಣವಾಗುತ್ತದೆ.',
            'ಹೃದಯದ ಸಮಸ್ಯೆಗಳು – ಹೆಚ್ಚಿನ ರಕ್ತದೊತ್ತಡ, ಅನಿಯಮಿತ ಹೃದಯ ಬಡಿತ ಮತ್ತು ಹೃದಯ ರೋಗಕ್ಕೆ ಕಾರಣವಾಗುತ್ತದೆ.',
            'ಜೀರ್ಣಕ್ರಿಯೆಯ ಸಮಸ್ಯೆಗಳು – ಹೊಟ್ಟೆಯ ಒಳಪದರವನ್ನು ಕಿರಿಕಿರಿ ಮಾಡುತ್ತದೆ, ಹುಣ್ಣುಗಳು, ವಾಂತಿ ಮತ್ತು ಪೋಷಕಾಂಶಗಳ ಕಳಪೆ ಹೀರಿಕೊಳ್ಳುವಿಕೆಗೆ ಕಾರಣವಾಗುತ್ತದೆ.',
            'ರೋಗನಿರೋಧಕ ವ್ಯವಸ್ಥೆಯನ್ನು ದುರ್ಬಲಗೊಳಿಸುತ್ತದೆ – ದೇಹವನ್ನು ಸೋಂಕುಗಳಿಗೆ ಹೆಚ್ಚು ಒಳಗಾಗುವಂತೆ ಮಾಡುತ್ತದೆ.',
            'ಕ್ಯಾನ್ಸರ್ ಅಪಾಯ – ಕ್ಯಾನ್ಸರ್‌ಗಳ ಅಪಾಯವನ್ನು ಹೆಚ್ಚಿಸುತ್ತದೆ (ಬಾಯಿ, ಗಂಟಲು, ಯಕೃತ್ತು, ಸ್ತನ, ಇತ್ಯಾದಿ).',
            'ತೂಕ ಹೆಚ್ಚಳ – ಕ್ಯಾಲರಿಗಳಲ್ಲಿ ಹೆಚ್ಚು, ಮದ್ಯವು ಸ್ಥೂಲಕಾಯಕ್ಕೆ ಕಾರಣವಾಗಬಹುದು.',
            'ನಿದ್ರೆಯ ಅಡಚಣೆ – ಸಾಮಾನ್ಯ ನಿದ್ರೆಯ ಮಾದರಿಗಳನ್ನು ಅಡ್ಡಿಪಡಿಸುತ್ತದೆ ಮತ್ತು ಆಯಾಸಕ್ಕೆ ಕಾರಣವಾಗುತ್ತದೆ.',
            'ಲೈಂಗಿಕ ಕ್ರಿಯೆಯ ಸಮಸ್ಯೆಗಳು – ಕಾಮಾಸಕ್ತಿ ಮತ್ತು ಲೈಂಗಿಕ ಕಾರ್ಯಕ್ಷಮತೆಯ ಕಡಿಮೆಯಾಗಬಹುದು.',
            'ನರಗಳ ಹಾನಿ – ದೀರ್ಘಕಾಲದ ಬಳಕೆಯು ನರಗಳಿಗೆ ಹಾನಿ ಮಾಡಬಹುದು',
            'ಮೇದೋಜೀರಕ ಉರಿಯೂತ – ಮೇದೋಜೀರಕದ ಉರಿಯೂತವು ತೀವ್ರವಾದ ಹೊಟ್ಟೆ ನೋವಿಗೆ ಕಾರಣವಾಗುತ್ತದೆ.',
          ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        languageToggle,
        Text(isEnglish ? 'Info' : 'ಮಾಹಿತಿ', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(
          color: Colors.blue[50],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(info, style: const TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(height: 24),
        Text(isEnglish ? 'Misconceptions & Facts' : 'ತಪ್ಪು ಕಲ್ಪನೆಗಳು ಮತ್ತು ಸತ್ಯಗಳು', style: theme.textTheme.titleLarge),
        ...misconceptions.map((m) => Card(
          child: ListTile(leading: const Icon(Icons.psychology, color: Colors.blue), title: Text(m))),
        ),
        const SizedBox(height: 24),
        Text(isEnglish ? 'Impact of alcohol consumption on the body and mind' : 'ದೇಹ ಮತ್ತು ಮನಸ್ಸಿನ ಮೇಲೆ ಮದ್ಯಪಾನದ ಪರಿಣಾಮ', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        
        // Impact on the Mind Card
        Card(
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
                  Colors.blue.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🧠', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        mindImpactTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...mindImpactPoints.map((point) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6, right: 12),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          point,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Impact on the Body Card
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red.withOpacity(0.1),
                  Colors.orange.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('💪', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        bodyImpactTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...bodyImpactPoints.map((point) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6, right: 12),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          point,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(isEnglish ? 'Addiction Symptoms' : 'ವ್ಯಸನದ ಲಕ್ಷಣಗಳು', style: theme.textTheme.titleLarge),
        ...symptoms.map((s) => Card(
          child: ListTile(leading: const Icon(Icons.warning_amber, color: Colors.orange), title: Text(s))),
        ),
        const SizedBox(height: 24),
        Text(isEnglish ? 'Treatment Options' : 'ಚಿಕಿತ್ಸೆಯ ಆಯ್ಕೆಗಳು', style: theme.textTheme.titleLarge),
        ...treatments.map((t) => Card(
          child: ListTile(leading: const Icon(Icons.healing, color: Colors.green), title: Text(t))),
        ),
        const SizedBox(height: 24),
        Text(isEnglish ? 'Expert Video' : 'ತಜ್ಞರ ವೀಡಿಯೊ', style: theme.textTheme.titleLarge),
        Card(
          color: Colors.green[50],
          child: ListTile(
            leading: const Icon(Icons.play_circle_fill, color: Colors.green),
            title: Text(video['title']!),
            subtitle: Text(video['url']!, style: const TextStyle(color: Colors.blue)),
            onTap: () => _openUrl(video['url']!),
          ),
        ),
      ],
    );
  }
} 

class AwarenessTabContent extends StatefulWidget {
  const AwarenessTabContent({super.key});

  @override
  State<AwarenessTabContent> createState() => _AwarenessTabContentState();
}

class _AwarenessTabContentState extends State<AwarenessTabContent> {
  bool _isEnglish = true;

  String get _motivationalQuotesTitle => _isEnglish 
    ? 'Motivational Quotes on Quitting Alcohol'
    : 'ಮದ್ಯಪಾನ ತ್ಯಜಿಸುವ ಕುರಿತು ಪ್ರೇರಣಾದಾಯಕ ಉಕ್ತಿಗಳು';

  String get _lifestyleTipsTitle => _isEnglish 
    ? 'Tips to maintain a good lifestyle'
    : 'ಉತ್ತಮ ಜೀವನಶೈಲಿಯನ್ನು ಕಾಯ್ದುಕೊಳ್ಳಲು ಸಲಹೆಗಳು';

  List<String> get _motivationalQuotes => _isEnglish 
    ? [
        '"You don\'t have to be great to start, but you have to start to be great."',
        '"Alcohol may drown your sorrows, but it also sinks your life."',
        '"Quitting alcohol doesn\'t make life boring. It makes you free."',
        '"Recovery is not for people who need it. It\'s for people who want it."',
        '"One day at a time. One step at a time. You can do this."',
        '"You don\'t need alcohol to celebrate life. There are other good ways to celebrate it."',
        '"Say no to the bottle, say yes to life."',
        '"Your future is more important than any drink."',
      ]
    : [
        '"ಮದ್ಯವು ನಿಮ್ಮ ದುಃಖವನ್ನು ಮುಳುಗಿಸಬಹುದು, ಆದರೆ ಅದು ನಿಮ್ಮ ಬದುಕನ್ನೂ ಮುಳುಗಿಸುತ್ತದೆ."',
        '"ಮದ್ಯಪಾನ ನಿಲ್ಲಿಸಿದರೆ ಜೀವನ ಬೋರ್ ಆಗುವುದಿಲ್ಲ – ಅದು ಸ್ವಾತಂತ್ರ್ಯವು ನೀಡುತ್ತದೆ."',
        '"ಒಂದು ದಿನ, ಒಂದು ಹೆಜ್ಜೆ – ನೀವು ಈತನಕ ಬಂದಿದ್ದೀರಾ ಅಂದರೆ ಮುಂದುವರಿಯಲು ಶಕ್ತಿಯು ನಿಮ್ಮಲ್ಲಿದೆ."',
        '"ನೀವು ಎಲ್ಲೂ ಹೋಗಬೇಕೆಂದಿದ್ದರೆ, ಈಗಿರುವ ಸ್ಥಿತಿಯನ್ನು ಬದಲಾಯಿಸಲು ನಿರ್ಧರಿಸಿ."',
        '"ಜೀವನವನ್ನು ಆಚರಿಸಲು ಮದ್ಯ ಬೇಕಾಗಿಲ್ಲ – ನಿಜವಾದ ಸ್ವಾತಂತ್ರ್ಯವು ಮದ್ಯವಿಲ್ಲದ ಜೀವನ."',
        '"ಬಾಟಲಿಗೆ \'ಇಲ್ಲ\' ಹೇಳಿ – ಬದುಕಿಗೆ \'ಹೌದು\' ಹೇಳಿ."',
        '"ನಿಮ್ಮ ಭವಿಷ್ಯವು ಒಂದು ಕುಡಿಯುವ ಹೊತ್ತಿಗಿಂತ ಹೆಚ್ಚಿನ ಮೌಲ್ಯದ್ದು."',
        '"ನಿಮ್ಮ ಜೀವನ ಮೌಲ್ಯಯುತ ವಾಗಬೇಕಾದರೆ – ಮದ್ಯಚಟವಿಲ್ಲದ ಜೀವನವೇ ನಿಮ್ಮದಾಗಲಿ."',
      ];

  List<Map<String, String>> get _lifestyleTips => _isEnglish 
    ? [
        {
          'icon': '🥗',
          'title': '1. Healthy Diet Habits',
          'content': 'Eat a balanced diet with fruits, vegetables, whole grains, and lean proteins.\nLimit sugar, salt, and saturated fats.\nStay hydrated – drink at least 6–8 glasses of water daily.\nAvoid junk food, processed foods, and sugary drinks.'
        },
        {
          'icon': '🏃‍♀',
          'title': '2. Regular Physical Activity',
          'content': 'Exercise for at least 30 minutes daily (e.g., walking, jogging, yoga, or cycling).\nInclude strength training 2–3 times a week.\nPractice stretching or flexibility exercises.'
        },
        {
          'icon': '😴',
          'title': '3. Proper Sleep Routine',
          'content': 'Maintain a consistent sleep schedule (7–9 hours/night).\nAvoid screen time at least 1 hour before bedtime.\nCreate a peaceful, dark, and quiet sleeping environment.'
        },
        {
          'icon': '🧘‍♂',
          'title': '4. Stress Management',
          'content': 'Practice meditation, deep breathing, or mindfulness.\nTake regular breaks during work or study.\nEngage in hobbies or creative activities.'
        },
        {
          'icon': '🚭',
          'title': '5. Avoid Harmful Habits',
          'content': 'Quit smoking and avoid tobacco products.\nLimit or avoid alcohol consumption.\nStay away from recreational drugs or misuse of medicines.'
        },
        {
          'icon': '💧',
          'title': '6. Maintain Personal Hygiene',
          'content': 'Bathe daily and wear clean clothes.\nBrush teeth twice a day and maintain oral hygiene.\nWash hands before meals and after using the restroom.'
        },
        {
          'icon': '💉',
          'title': '7. Regular Health Checkups',
          'content': 'Visit doctors for annual health screenings.\nMonitor blood pressure, sugar, and cholesterol regularly.\nTake medications as prescribed and complete vaccinations.'
        },
        {
          'icon': '🧠',
          'title': '8. Mental and Emotional Wellness',
          'content': 'Talk to someone you trust about your feelings.\nSeek professional help if needed (e.g., therapy).\nPractice gratitude and positive thinking.'
        },
        {
          'icon': '👥',
          'title': '9. Build Strong Social Connections',
          'content': 'Spend time with family and friends.\nParticipate in community or spiritual activities.\nAvoid toxic relationships and maintain healthy boundaries.'
        },
        {
          'icon': '📱',
          'title': '10. Digital Wellness',
          'content': 'Limit screen time, especially social media.\nTake digital detox breaks regularly.\nDon\'t use your mobile excessively.'
        },
      ]
    : [
        {
          'icon': '🥗',
          'title': '1. ಆರೋಗ್ಯಕರ ಆಹಾರ ಪದ್ಧತಿ',
          'content': 'ಹಣ್ಣುಗಳು, ತರಕಾರಿಗಳು, ಧಾನ್ಯಗಳು ಮತ್ತು ಪ್ರೋಟೀನ್‌ಗಳು ಹೊಂದಿರುವ ಸಮತೋಲ ಆಹಾರ ಸೇವಿಸಿ.\nಸಕ್ಕರೆ, ಉಪ್ಪು ಮತ್ತು ಕೊಬ್ಬಿನ ಹೆಚ್ಚು ಇರುವ ಆಹಾರ ತಪ್ಪಿಸಿ.\nಪ್ರತಿದಿನವೂ ದೇಹಕ್ಕೆ ಬೇಕಾದ ನೀರು ( 6-8 ಗ್ಲಾಸ್) ಕುಡಿಯಿರಿ.\nಜಂಕ್ ಫುಡ್ ಮತ್ತು ಪ್ಯಾಕ್ ಮಾಡಿದ ಆಹಾರಗಳನ್ನು ದೂರವಿರಿಸಿ.'
        },
        {
          'icon': '🏃‍♀',
          'title': '2. ನಿಯಮಿತ ವ್ಯಾಯಾಮ',
          'content': 'ದಿನಕ್ಕೆ ಕನಿಷ್ಠ 30 ನಿಮಿಷಗಳ ವ್ಯಾಯಾಮಗಳನ್ನು ಮಾಡಿ (ಹೆಜ್ಜೆ ನಡೆಯುವುದು, ಜಾಗಿಂಗ್, ಯೋಗ ).\nವಾರದಲ್ಲಿ 2–3 ಬಾರಿ ಬಲವರ್ಧಕ ವ್ಯಾಯಾಮಗಳನ್ನು ಮಾಡುವುದು'
        },
        {
          'icon': '😴',
          'title': '3. ಉತ್ತಮ ನಿದ್ರೆ ಪದ್ಧತಿ',
          'content': 'ಪ್ರತಿದಿನವೂ ನಿಗದಿತ ಸಮಯಕ್ಕೆ ತಕ್ಕಂತೆ ನಿದ್ರೆ ಮಾಡಿ, 7 ರಿಂದ–9 ಗಂಟೆ ನಿದ್ರೆ ಮಾಡಿ.\nಮಲಗುವ ಒಂದು ಗಂಟೆ ಮೊದಲು ಮೊಬೈಲ್/ಟಿವಿ ಬಳಸುವುದನ್ನು ನಿಲ್ಲಿಸಿ.\nನಿದ್ರೆಗೋಸ್ಕರ ಶಾಂತ, ಪರಿಸರ ರೂಪಿಸಿ.'
        },
        {
          'icon': '🧘‍♂',
          'title': '4. ಮಾನಸಿಕ ಒತ್ತಡ ನಿಯಂತ್ರಣ',
          'content': 'ಧ್ಯಾನ ಮಾಡಿ\nಕೆಲಸ/ಅಭ್ಯಾಸದ ನಡುವೆ ವಿರಾಮ ತೆಗೆದುಕೊಳ್ಳಿ.\nನಿಮಗೆ ಇಷ್ಟವಾದ ಹವ್ಯಾಸಗಳಲ್ಲಿ ತೊಡಗಿಸಿ.'
        },
        {
          'icon': '🚭',
          'title': '5. ಕೆಟ್ಟ ಅಭ್ಯಾಸಗಳನ್ನು ದೂರವಿಡಿ',
          'content': 'ಧೂಮಪಾನ, ಗುಟ್ಕಾ, ತಂಬಾಕು ಸೇವನೆ ನಿಲ್ಲಿಸಿ.ಇವುಗಳು ಆರೋಗ್ಯವನ್ನು ಹಾಳುಮಾಡುತ್ತವೆ.\nಮದ್ಯಪಾನವನ್ನು ದೂರವಿಡಿ ಅಥವಾ ಕಡಿಮೆಗೊಳಿಸಿ.\nಮಾದಕ ದ್ರವ್ಯಗಳ ಬಳಕೆ ತಪ್ಪಿಸಿ.'
        },
        {
          'icon': '💧',
          'title': '6. ವೈಯಕ್ತಿಕ ಸ್ವಚ್ಚತೆ ಪಾಲನೆ',
          'content': 'ಪ್ರತಿದಿನ ಸ್ನಾನ ಮಾಡಿ ಮತ್ತು ಸ್ವಚ್ಚ ಬಟ್ಟೆ ಧರಿಸಿ.\nದಿನಕ್ಕೆ ಎರಡು ಬಾರಿ ಹಲ್ಲು ಸ್ವಚ್ಚಗೊಳಿಸಿಕೊಳ್ಳಿ.\nಊಟಕ್ಕೂ ಮೊದಲು ಮತ್ತು ಶೌಚಾಲಯದ ನಂತರ ಕೈ ತೊಳೆಯಿರಿ.'
        },
        {
          'icon': '💉',
          'title': '7. ವೈದ್ಯಕೀಯ ತಪಾಸಣೆ',
          'content': 'ವರ್ಷಕ್ಕೊಮ್ಮೆ ಆರೋಗ್ಯ ತಪಾಸಣೆ ಮಾಡಿಸಿಕೊಳ್ಳಿ.\nರಕ್ತದೊತ್ತಡ, ಸಕ್ಕರೆ ಮಟ್ಟ, ಕೊಲೆಸ್ಟ್ರಾಲ್ ನಿಯಮಿತವಾಗಿ ಪರೀಕ್ಷಿಸಿ.'
        },
        {
          'icon': '🧠',
          'title': '8. ಮಾನಸಿಕ ಆರೋಗ್ಯ ಕಾಪಾಡಿಕೊಳ್ಳಿ',
          'content': 'ನಿಮ್ಮ ಭಾವನೆಗಳನ್ನು ಗೆಳೆಯರು ಅಥವಾ ಕುಟುಂಬದವರೊಂದಿಗೆ ಹಂಚಿಕೊಳ್ಳಿ.\nಅಗತ್ಯವಿದ್ದರೆ ತಜ್ಞರಿಂದ ಸಹಾಯ ಪಡೆಯಿರಿ.\nಧನ್ಯತೆ ಸೂಚಿಸಿ, ಸಕಾರಾತ್ಮಕ ಚಿಂತನೆಯನ್ನು ಬೆಳೆಸಿಕೊಳ್ಳಿ.'
        },
        {
          'icon': '👥',
          'title': '9. ಉತ್ತಮ ಸಾಮಾಜಿಕ ಸಂಬಂಧಗಳು',
          'content': 'ಕುಟುಂಬ ಮತ್ತು ಸ್ನೇಹಿತರ ಜೊತೆ ಸಮಯ ಕಳೆಯಿರಿ.\nಧಾರ್ಮಿಕ ಅಥವಾ ಸಾಮಾಜಿಕ ಚಟುವಟಿಕೆಗಳಲ್ಲಿ ಪಾಲ್ಗೊಳ್ಳಿ.\nಕೆಟ್ಟ ಸಂಬಂಧಗಳಿಂದ ದೂರವಿರಿ'
        },
        {
          'icon': '📱',
          'title': '10. ಡಿಜಿಟಲ್ ಆರೋಗ್ಯ',
          'content': 'ಮಿತವಾಗಿ ಮೊಬೈಲ್ ಬಳಸಿ.'
        },
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Language Toggle
        Container(
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
        ),

        // Motivational Quotes Section
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.psychology,
                    color: theme.primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _motivationalQuotesTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
                                     // Quotes List
                       ..._motivationalQuotes.map((quote) => Container(
                         margin: const EdgeInsets.only(bottom: 8),
                         child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.green.withOpacity(0.1),
                          Colors.blue.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.format_quote,
                          color: theme.primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            quote,
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),

        // Lifestyle Tips Section
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.health_and_safety,
                    color: theme.primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _lifestyleTipsTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Lifestyle Tips List
              ..._lifestyleTips.map((tip) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.withOpacity(0.1),
                          Colors.green.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              tip['icon']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tip['title']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...tip['content']!.split('\n').map((point) => point.trim()).where((point) => point.isNotEmpty).map((point) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6, right: 12),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  point,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
} 