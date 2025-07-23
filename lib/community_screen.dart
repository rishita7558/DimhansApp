import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dimhans_app/image_viewer_screen.dart'; // Added import for ImageViewerScreen
import 'package:dimhans_app/alcohol_facts_screen.dart'; // Added import for AlcoholFactsScreen

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final posters = [
      {'title': 'Stay Strong Poster', 'url': 'https://static.printler.com/media/photo/194376_400x400.jpg'},
      {'title': 'Alcohol Facts Handout'},
    ];
    final websites = [
      {'name': 'WHO Alcohol Info', 'url': 'https://www.who.int/health-topics/alcohol'},
      {'name': 'AA India', 'url': 'https://aagsoindia.org/'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Community & Resources')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Posters & Handouts', style: Theme.of(context).textTheme.titleLarge),
          ...posters.map((p) => Card(
            child: ListTile(
              leading: const Icon(Icons.insert_drive_file, color: Colors.blue),
              title: Text(p['title']!),
              subtitle: p['url'] != null ? Text(p['url']!, style: const TextStyle(color: Colors.blue)) : null,
              onTap: () {
                if (p['title'] == 'Alcohol Facts Handout') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AlcoholFactsScreen(),
                    ),
                  );
                } else if (p['url'] != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ImageViewerScreen(
                        title: p['title']!,
                        imageUrl: p['url']!,
                      ),
                    ),
                  );
                }
              },
            ),
          )),
          const SizedBox(height: 24),
          Text('Important Websites', style: Theme.of(context).textTheme.titleLarge),
          ...websites.map((w) => Card(
            child: ListTile(
              leading: const Icon(Icons.link, color: Colors.green),
              title: Text(w['name']!),
              subtitle: Text(w['url']!, style: const TextStyle(color: Colors.blue)),
              onTap: () => _openUrl(w['url']!),
            ),
          )),
          const SizedBox(height: 24),
          Text('AA Groups & Experts', style: Theme.of(context).textTheme.titleLarge),
          Card(
            child: ListTile(
              leading: const Icon(Icons.group, color: Colors.deepPurple),
              title: const Text('AA Group (Dummy)'),
              subtitle: const Text('Contact: 90000 12345\nEmail: aa_dummy@email.com'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.orange),
              title: const Text('Expert: Dr. S. Mehta'),
              subtitle: const Text('Psychiatrist, Wellness Clinic'),
            ),
          ),
        ],
      ),
    );
  }
} 