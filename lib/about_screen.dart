import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                  Icon(Icons.verified, size: 72, color: theme.colorScheme.secondary),
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
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.favorite, color: theme.colorScheme.secondary, size: 36),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'In summary, this alcohol prevention app is more than just a digital tool—it is a comprehensive, compassionate, and educational resource created to promote healthier choices, prevent alcohol-related harm, and support recovery journeys. Whether you\'re a concerned parent, a student navigating peer influences, or someone seeking to change your drinking habits, this app stands ready to guide, support, and inspire you toward a healthier society.',
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
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
}

Widget _section({required IconData icon, required String title, required String content}) {
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
              style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            ),
          ],
        ),
      ),
    ],
  );
} 