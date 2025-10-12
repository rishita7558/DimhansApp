import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool _isEnglish = true;

  String get _directorMessageTitle =>
      _isEnglish ? 'Director\'s Message' : 'ನಿರ್ದೇಶಕರ ಸಂದೇಶ';

  String get _directorMessageContent => _isEnglish
      ? '🌟 Important Information About Alcohol Addiction Awareness\n\n"Alcohol – one sip… a lifelong trip!"\n\nThis small line tells a big truth. One casual drink today can silently take away your health, your family\'s happiness, and even your future.\n\nFriends, statistics are alarming:\nIn India, about 16% of people regularly consume alcohol. Among them, 4–5% suffer from severe dependence disorder. Every year, more than 3 lakh deaths occur due to alcohol-related accidents, liver diseases, and violence.\n\nLet\'s look at an example:\nA man starts by drinking only on weekends. Gradually, it becomes a daily necessity. Financial problems begin. Family quarrels become common. Work performance declines. And one incident of drunk driving… can snatch away life in an instant.\n\n"Alcohol addiction is not a party habit – it is a disease that slowly grows."\n\n✅ How to come out of it?\n\n1. Accept it: "Yes, I have a problem." Without acceptance, change is impossible.\n2. Seek medical help: De-addiction centers, counseling, and medications can help.\n3. Avoid triggers: In the initial stage, stay away from old drinking friends, bars, and night parties.\n4. Develop healthy habits: Yoga, sports, music, and spending time with family.\n5. Join support groups: Alcoholics Anonymous (AA) emphasizes the powerful line—"One day at a time."\n\n✅ Inspirational Quotes:\n\n"There is no future in the bottle… the future is in your hands."\n\n"Alcohol gives you momentary happiness, but it steals the peace of your life. Choose health, choose life."\n\n"Healthy mind → Healthy family → Happy society – possible only with an alcohol-free life."\n\nDear friends, quit alcohol today… start life from tomorrow. Your family, your health, and your dreams are waiting for you.\n\n\nDr. Arunkumar C,\nDirector, DIMHANS, Dharwad.'
      : '🌟 ಮದ್ಯ ವ್ಯಸನ ಕುರಿತು ಸಂದೇಶ\n\n"ಮದ್ಯ ಒಂದು ಸಿಪ್… ಬದುಕಿನ ಉದ್ದ ಪ್ರಯಾಣ!"\n\nಈ ಸಣ್ಣ ವಾಕ್ಯ ದೊಡ್ಡ ಸತ್ಯ ಹೇಳುತ್ತದೆ. ಇಂದು ಒಂದು ಸಣ್ಣ ಪೆಗ್ ಕುಡಿಯುವುದು… ನಿಶ್ಬದ್ಧವಾಗಿ ನಿಮ್ಮ ಆರೋಗ್ಯ, ನಿಮ್ಮ ಕುಟುಂಬದ ಸಂತೋಷ ಮತ್ತು ನಿಮ್ಮ ಭವಿಷ್ಯವನ್ನು ಕಸಿದುಕೊಳ್ಳುತ್ತದೆ.\n\nಮಿತ್ರರೇ, ಅಂಕಿಅಂಶಗಳು ಎಚ್ಚರಿಕೆ ನೀಡುತ್ತಿವೆ:\nಭಾರತದಲ್ಲಿ ಸುಮಾರು 16% ಜನರು ನಿಯಮಿತವಾಗಿ ಮದ್ಯ ಸೇವಿಸುತ್ತಾರೆ. ಅವರಲ್ಲಿ 4–5% ಜನರಿಗೆ ತೀವ್ರ ವ್ಯಸನ (dependence disorder) ಇದೆ. ಪ್ರತಿ ವರ್ಷ 3 ಲಕ್ಷಕ್ಕೂ ಹೆಚ್ಚು ಸಾವುಗಳು ಮದ್ಯ ಸಂಬಂಧಿತ ಅಪಘಾತಗಳು, ಯಕೃತ್‌ ರೋಗಗಳು ಮತ್ತು ಹಿಂಸಾಚಾರದಿಂದಾಗುತ್ತವೆ.\n\nಒಂದು ಉದಾಹರಣೆ ನೋಡೋಣ:\nಒಬ್ಬ ವ್ಯಕ್ತಿ – ಆರಂಭದಲ್ಲಿ ಕೇವಲ ವಾರಾಂತ್ಯಗಳಲ್ಲಿ ಮಾತ್ರ ಕುಡಿಯುತ್ತಾನೆ. ನಿಧಾನವಾಗಿ ಅದು ಪ್ರತಿದಿನದ ಅಗತ್ಯವಾಗುತ್ತದೆ. ಹಣಕಾಸಿನ ಸಮಸ್ಯೆಗಳು ಶುರುವಾಗುತ್ತವೆ. ಕುಟುಂಬದಲ್ಲಿ ಜಗಳಗಳು ಸಾಮಾನ್ಯವಾಗುತ್ತವೆ. ಕೆಲಸದ ಸಾಧನೆ ಕುಸಿಯುತ್ತದೆ. ಮತ್ತು ಒಂದು ಕುಡಿದು ವಾಹನ ಓಡಿಸುವ ಘಟನೆ… ಕ್ಷಣಾರ್ಧದಲ್ಲಿ ಪ್ರಾಣವನ್ನು ಕಸಿದುಕೊಳ್ಳಬಹುದು.\n\n"ಮದ್ಯ ವ್ಯಸನ ಪಾರ್ಟಿಯ ಅಭ್ಯಾಸವಲ್ಲ – ಅದು ನಿಧಾನವಾಗಿ ಬೆಳೆಯುವ ರೋಗ."\n\n✅ ಹೇಗೆ ಹೊರಬರಬೇಕು?\n\n1. ಸ್ವೀಕರಿಸಿ: "ಹೌದು, ನನಗೆ ಸಮಸ್ಯೆ ಇದೆ." ಸ್ವೀಕಾರವಿಲ್ಲದೆ ಬದಲಾವಣೆ ಸಾಧ್ಯವಿಲ್ಲ.\n2. ವೈದ್ಯಕೀಯ ಸಹಾಯ ಪಡೆಯಿರಿ: ಡೀ-ಅಡಿಕ್ಷನ್ ಕೇಂದ್ರಗಳು, ಸಮಾಲೋಚನೆ, ಔಷಧಿಗಳು ಸಹಾಯ ಮಾಡುತ್ತವೆ.\n3. ಕಾರಣಗಳನ್ನು ತಪ್ಪಿಸಿ: ಹಳೆಯ ಸ್ನೇಹ ಬಳಗ, ಬಾರ್‌ಗಳು, ರಾತ್ರಿ ಪಾರ್ಟಿಗಳನ್ನು ಪ್ರಾರಂಭಿಕ ಹಂತದಲ್ಲಿ ದೂರವಿಡಿ.\n4. ಆರೋಗ್ಯಕರ ಅಭ್ಯಾಸಗಳನ್ನು ಬೆಳೆಸಿರಿ: ಯೋಗ, ಕ್ರೀಡೆ, ಸಂಗೀತ, ಕುಟುಂಬದ ಜೊತೆ ಸಮಯ.\n5. ಬೆಂಬಲ ಗುಂಪುಗಳಿಗೆ ಸೇರಿ: ಅಲ್ಕೊಹಾಲಿಕ್ಸ್ ಅನಾನಿಮಸ್ (AA) ಹೇಳುವ ಶಕ್ತಿಶಾಲಿ ವಾಕ್ಯ—"ಒಂದು ದಿನ ಒಂದು ಹಂತ."\n\n✅ ಪ್ರೇರಣಾದಾಯಕ ವಾಕ್ಯಗಳು:\n\n"ಬಾಟಲ್‌ನಲ್ಲಿ ಭವಿಷ್ಯ ಇಲ್ಲ… ಭವಿಷ್ಯ ನಿಮ್ಮ ಕೈಯಲ್ಲಿದೆ."\n\n"ಮದ್ಯ ನಿಮಗೆ ಕ್ಷಣಿಕ ಖುಷಿ ನೀಡುತ್ತದೆ, ಆದರೆ ಬದುಕಿನ ಶಾಂತಿಯನ್ನು ಕಸಿದುಕೊಳ್ಳುತ್ತದೆ. ಆರೋಗ್ಯ ಆರಿಸಿ, ಬದುಕನ್ನು ಆರಿಸಿ."\n\n"ಆರೋಗ್ಯಕರ ಮನಸ್ಸು → ಆರೋಗ್ಯಕರ ಕುಟುಂಬ → ಸಂತೋಷಕರ ಸಮಾಜ – ಇದು ಮದ್ಯರಹಿತ ಜೀವನದಿಂದ ಮಾತ್ರ ಸಾಧ್ಯ."\n\nಪ್ರಿಯ ಮಿತ್ರರೇ, ಇಂದು ಮದ್ಯವನ್ನು ನಿಲ್ಲಿಸಿ… ನಾಳೆಯಿಂದ ಬದುಕನ್ನು ಪ್ರಾರಂಭಿಸಿ. ನಿಮ್ಮ ಕುಟುಂಬ, ಆರೋಗ್ಯ ಮತ್ತು ಕನಸುಗಳು ನಿಮ್ಮನ್ನು ಕಾಯುತ್ತಿವೆ.\n\n\nಡಾ. ಅರುಣಕುಮಾರ್ ಸಿ,\nನಿರ್ದೇಶಕ, ಡಿಮ್ಹಾನ್ಸ್, ಧಾರವಾಡ.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('About This App'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: theme.primaryColor,
      ),
      backgroundColor: const Color(0xFFF3EFFF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.verified,
                    size: 72,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'About this Application or App',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _section(
              icon: Icons.health_and_safety,
              title: 'A Global Health Concern',
              content:
                  'Alcohol misuse continues to be a major public health concern across the world, affecting individuals, families, and communities in profound ways. In response to the growing need for accessible, practical, and impactful solutions, we are proud to introduce an innovative mobile application dedicated to the prevention of alcohol use and abuse. This app is thoughtfully designed to serve a wide range of users, including the general public, individuals struggling with alcohol dependency, and students who are especially vulnerable to peer pressure and early exposure.',
            ),
            const SizedBox(height: 24),
            _section(
              icon: Icons.lightbulb,
              title: 'Our Mission',
              content:
                  'The primary aim of this application is to educate, inform, and empower users through a range of interactive and evidence-based resources that promote healthy lifestyles and informed choices.',
            ),
            const SizedBox(height: 24),
            _section(
              icon: Icons.menu_book,
              title: 'What We Offer',
              content:
                  'At its core, the app combines health education, awareness-building tools, and personal development resources in a user-friendly digital platform. One of its main features is a curated library of educational content, covering topics such as the health effects of alcohol consumption, the psychological and social risks of addiction, and the benefits of sobriety. This content is developed in collaboration with public health professionals, addiction counselors, and medical experts to ensure accuracy and relevance. The app also includes real-life case studies, testimonials, and myth-busting facts that challenge common misconceptions about alcohol use.',
            ),
            const SizedBox(height: 24),
            _section(
              icon: Icons.ondemand_video,
              title: 'Engaging Multimedia',
              content:
                  'To further enhance user engagement and understanding, the app provides a wide range of high-quality health education videos. These videos include expert interviews, animated explainers, recovery stories, and interactive lessons that help users visualize the long-term impact of alcohol on the body and mind. For students and younger users, the app features age-appropriate content, peer-to-peer messages, and awareness campaigns aimed at preventing early experimentation and fostering responsible decision-making.',
            ),
            const SizedBox(height: 24),
            _section(
              icon: Icons.assessment,
              title: 'Self-Assessment & Motivation',
              content:
                  "In addition to educational material, the app offers self-assessment tools that help users understand their drinking patterns, risk levels, and potential need for professional support. Based on the results, users are guided toward practical steps they can take, whether it's cutting down on alcohol, seeking counseling, or joining a support group. The app may also include features like goal-setting trackers, daily motivation quotes, and a calendar for sober milestones, reinforcing positive behavior and accountability.",
            ),
            const SizedBox(height: 24),
            _section(
              icon: Icons.support,
              title: 'Community & Support',
              content:
                  'Community support and professional guidance are also emphasized within the app. A dedicated section connects users to helplines, local rehab centers, and mental health professionals. For family members and caregivers, the app provides guidance on how to support loved ones and manage the emotional stress associated with addiction.',
            ),
            const SizedBox(height: 24),
            _communityMembersSection(theme),
            const SizedBox(height: 24),
            _directorMessageSection(theme),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.favorite,
                    color: theme.colorScheme.secondary,
                    size: 36,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'In summary, this alcohol prevention app is more than just a digital tool—it is a comprehensive, compassionate, and educational resource created to promote healthier choices, prevent alcohol-related harm, and support recovery journeys. Whether you\'re a concerned parent, a student navigating peer influences, or someone seeking to change your drinking habits, this app stands ready to guide, support, and inspire you toward a healthier society.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Made with ❤️ for a healthier tomorrow',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _communityMembersSection(ThemeData theme) {
    final members = [
      {
        'name': 'Dr. Arunkumar C',
        'role': 'Director',
        'department': 'DIMHANS Dharwad & Chairman NAIN 2.0',
        'imagePath': 'assets/Director, Dimhans.jpg',
      },
      {
        'name': 'Mr. Shivaganesh B Gunjal',
        'role': 'Team Leader',
        'department': 'DIMHANS',
        'imagePath': 'assets/MrShivaganesh B Gunjal.jpg',
      },
      {
        'name': 'Mr. Ramappa Timmapur',
        'role': 'Team Mentor',
        'department': 'DIMHANS',
        'imagePath': 'assets/MrRamappa Timmapur.jpg',
      },
      {
        'name': 'Dr. Srinivas Kosagi',
        'role': 'Team Member',
        'department': 'DIMHANS',
        'imagePath': 'assets/Srinivas Kosagi.jpg',
      },
      {
        'name': 'Mr. Ashok S. Kori',
        'role': 'Team Member',
        'department': 'DIMHANS',
        'imagePath': 'assets/AshokSKori.jpg',
      },
      {
        'name': 'Dr. Shivarudrappa Bhairppanavar',
        'role': 'Team Member',
        'department': 'DIMHANS',
        'imagePath': 'assets/DrShivarudrappa Bhairppanavar.jpg',
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            theme.colorScheme.secondary.withOpacity(0.05),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.secondary.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.secondary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.secondary,
                  theme.colorScheme.secondary.withOpacity(0.8),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(Icons.people, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Our Community Members',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${members.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Members Grid
          Container(
            padding: const EdgeInsets.all(16),
            child: members.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.secondary.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 48,
                          color: theme.colorScheme.secondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Community Members',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your team members here with their photos and details',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.secondary.withOpacity(0.1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.secondary.withOpacity(
                                0.1,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Full-size background image
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: member['imagePath'] != null
                                    ? Image.asset(
                                        member['imagePath']!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  color: theme
                                                      .colorScheme
                                                      .secondary
                                                      .withOpacity(0.1),
                                                  child: Icon(
                                                    Icons.person,
                                                    color: theme
                                                        .colorScheme
                                                        .secondary,
                                                    size: 40,
                                                  ),
                                                ),
                                      )
                                    : Container(
                                        color: theme.colorScheme.secondary
                                            .withOpacity(0.1),
                                        child: Icon(
                                          Icons.person,
                                          color: theme.colorScheme.secondary,
                                          size: 40,
                                        ),
                                      ),
                              ),
                            ),
                            // Gradient overlay for text readability
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                    stops: const [0.0, 0.4, 1.0],
                                  ),
                                ),
                              ),
                            ),
                            // Text overlay at bottom
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      member['name'] ?? 'Name',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 2,
                                            color: Colors.black54,
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      member['role'] ?? 'Role',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w600,
                                        shadows: const [
                                          Shadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 2,
                                            color: Colors.black54,
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _directorMessageSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            theme.primaryColor.withOpacity(0.05),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header with gradient background
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withOpacity(0.8),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/Director, Dimhans.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _directorMessageTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.star, color: Colors.white, size: 16),
                ),
              ],
            ),
          ),
          // Content section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Language Toggle with enhanced styling
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
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
                      Icon(Icons.language, size: 16, color: theme.primaryColor),
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
                            activeTrackColor: theme.primaryColor.withOpacity(
                              0.3,
                            ),
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
                const SizedBox(height: 20),
                // Message content with enhanced styling
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.primaryColor.withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    _directorMessageContent,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.7,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Footer with signature
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.primaryColor.withOpacity(0.1),
                            theme.primaryColor.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.primaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            size: 16,
                            color: theme.primaryColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isEnglish
                                ? 'Dr. Arunkumar C'
                                : 'ಡಾ. ಅರುಣಕುಮಾರ್ ಸಿ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _section({
  required IconData icon,
  required String title,
  required String content,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: Colors.blueAccent, size: 32),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
