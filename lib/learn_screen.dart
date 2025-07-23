import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Learn About Alcohol Addiction'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'For Public'),
              Tab(text: 'For Students'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LearnTabContent(audience: 'Public'),
            LearnTabContent(audience: 'Students'),
          ],
        ),
      ),
    );
  }
}

class LearnTabContent extends StatelessWidget {
  final String audience;
  const LearnTabContent({required this.audience, super.key});

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = audience == 'Public'
        ? 'Alcohol can impact your physical and mental health, relationships, and work. Excessive drinking increases the risk of liver disease, heart problems, cancer, and mental health issues. It can also lead to accidents, violence, and family or work difficulties. Remember, even moderate drinking can have risks, and support is available for those who want to cut down or quit.'
        : 'Alcohol use among students can negatively affect academics, friendships, and future goals. It impairs memory, concentration, and decision-making, leading to poor grades and risky behaviors. Underage drinking can disrupt brain development and increase the risk of addiction later in life. Choosing to stay alcohol-free helps you stay focused, healthy, and in control of your future.';
    final misconceptions = audience == 'Public'
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
            'Myth: It’s safe to drink if your friends are doing it.\nFact: Peer pressure can lead to dangerous situations.',
            'Myth: Underage drinking is not a big deal.\nFact: It’s illegal and can have serious consequences.',
          ];
    final symptoms = audience == 'Public'
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
          ];
    final treatments = audience == 'Public'
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
          ];
    final video = audience == 'Public'
        ? {'title': 'Alcohol & Health (YouTube)', 'url': 'https://youtu.be/9IizjqPQyK8?si=ciRJqwFSLmiyuWpP'}
        : {'title': "Alcohol's effect on Teenage Brain", 'url': 'https://youtu.be/EY37BFmVxwQ?si=pevzou4keD9SYtK9'};
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Info', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(
          color: Colors.blue[50],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(info, style: const TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(height: 24),
        Text('Misconceptions & Facts', style: Theme.of(context).textTheme.titleLarge),
        ...misconceptions.map((m) => Card(
          child: ListTile(leading: const Icon(Icons.info_outline, color: Colors.blue), title: Text(m))),
        ),
        const SizedBox(height: 24),
        Text('Addiction Symptoms', style: Theme.of(context).textTheme.titleLarge),
        ...symptoms.map((s) => Card(
          child: ListTile(leading: const Icon(Icons.warning_amber, color: Colors.orange), title: Text(s))),
        ),
        const SizedBox(height: 24),
        Text('Treatment Options', style: Theme.of(context).textTheme.titleLarge),
        ...treatments.map((t) => Card(
          child: ListTile(leading: const Icon(Icons.healing, color: Colors.green), title: Text(t))),
        ),
        const SizedBox(height: 24),
        Text('Expert Video', style: Theme.of(context).textTheme.titleLarge),
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