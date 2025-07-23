import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CravingSkillsScreen extends StatelessWidget {
  const CravingSkillsScreen({super.key});

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tips = [
      'Urge Surfing: Notice the craving, ride it like a wave, and let it pass.',
      'Breathing Exercise: Inhale deeply for 4 seconds, hold for 4, exhale for 4.',
      'Delay Technique: Wait 10 minutes before acting on a craving.',
      'Distraction: Go for a walk, call a friend, or listen to music.',
      'Remind Yourself: Cravings are temporary and will pass.'
    ];
    final quotes = [
      '"You are stronger than your strongest excuse."',
      '"Every craving conquered is a victory."',
      '"Take it one day at a time."',
      '"Your future is created by what you do today."',
      '"Progress, not perfection."'
    ];
    final videos = [
      {'title': 'Urge Surfing', 'url': 'https://www.youtube.com/watch?v=5h3CtiG99yE&t=2s'},
      {'title': 'Breathing Exercise for Craving Control', 'url': 'https://www.youtube.com/watch?v=FJJazKtH_9I'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Craving Management Skills')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Tips for Managing Cravings', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...tips.map((tip) => Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text(tip),
            ),
          )),
          const SizedBox(height: 24),
          Text('Daily Motivational Quote', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Card(
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                quotes[DateTime.now().day % quotes.length],
                style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Watch & Learn', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...videos.map((v) => Card(
            color: Colors.blue[50],
            child: ListTile(
              leading: const Icon(Icons.play_circle_fill, color: Colors.blue),
              title: Text(v['title']!),
              subtitle: Text(v['url']!, style: const TextStyle(color: Colors.blue)),
              onTap: () => _openUrl(v['url']!),
            ),
          )),
        ],
      ),
    );
  }
} 