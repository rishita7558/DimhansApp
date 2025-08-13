import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dimhans_app/image_viewer_screen.dart';
import 'package:dimhans_app/alcohol_facts_screen.dart';

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
    final theme = Theme.of(context);
    
    final posters = [
      {
        'title': 'Stay Strong Poster',
        'url': 'https://static.printler.com/media/photo/194376_400x400.jpg',
        'type': 'online'
      },
      {
        'title': 'Alcohol Facts Handout',
        'type': 'screen'
      },
      {
        'title': 'Facts About Alcohol',
        'asset': 'assets/Facts about Alcohol.png',
        'type': 'asset'
      },
    ];
    
    final websites = [
      {'name': 'WHO Alcohol Info', 'url': 'https://www.who.int/health-topics/alcohol'},
      {'name': 'AA India', 'url': 'https://aagsoindia.org/'},
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community & Resources'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: theme.primaryColor,
      ),
      backgroundColor: const Color(0xFFF3EFFF),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Posters & Handouts Section
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.insert_drive_file,
                      color: theme.primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Posters & Handouts',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...posters.map((poster) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
              onTap: () {
                        if (poster['type'] == 'screen') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AlcoholFactsScreen(),
                    ),
                  );
                        } else if (poster['type'] == 'asset' && poster['asset'] != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ImageViewerScreen(
                                title: poster['title']!,
                                imageUrl: poster['asset']!,
                                isAsset: true,
                              ),
                            ),
                          );
                        } else if (poster['type'] == 'online' && poster['url'] != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ImageViewerScreen(
                                title: poster['title']!,
                                imageUrl: poster['url']!,
                      ),
                    ),
                  );
                }
              },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                poster['type'] == 'asset' 
                                  ? Icons.image 
                                  : poster['type'] == 'screen'
                                    ? Icons.fact_check
                                    : Icons.insert_drive_file,
                                color: theme.primaryColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                poster['title']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey[400],
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
          
          // Important Websites Section
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.link,
                      color: theme.primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Important Websites',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...websites.map((website) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _openUrl(website['url']!),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.link,
                                color: Colors.green,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    website['name']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    website['url']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.open_in_new,
                              color: Colors.grey[400],
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
          
          // AA Groups & Experts Section
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.group,
                      color: theme.primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'AA Groups & Experts',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.group,
                            color: Colors.deepPurple,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AA Group (Dummy)',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Contact: 90000 12345\nEmail: aa_dummy@email.com',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
          Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.orange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expert: Dr. S. Mehta',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Psychiatrist, Wellness Clinic',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 