import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  void _callNumber(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _sendEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _sendSms(String number) async {
    final uri = Uri.parse('sms:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final psychiatrists = [
      {'name': 'Dr. A. Kumar', 'location': 'City Hospital', 'phone': '9876543210'},
      {'name': 'Dr. S. Mehta', 'location': 'Wellness Clinic', 'phone': '9123456780'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Helpful content section (moved to top)
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Need Help?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.blue)),
                        SizedBox(height: 8),
                        Text('• Call the TeleManas helpline (14416) for immediate support. This is a free, confidential helpline for mental health and addiction support.'),
                        Text('• When you call, you can expect to speak with a trained counselor who will listen and guide you without judgment.'),
                        Text('• If you feel overwhelmed, try to share your feelings honestly. It’s okay to ask for help even if you’re not sure what to say.'),
                        Text('• You can also reach out to a psychiatrist or mental health professional for personalized care.'),
                        Text('• If you are in crisis or feel unsafe, tell someone you trust or call emergency services.'),
                        SizedBox(height: 12),
                        Text('Other National Resources:', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('• Kiran Mental Health Helpline: 1800-599-0019'),
                        Text('• NIMHANS Centre for Well Being: 080-46110007'),
                        SizedBox(height: 12),
                        Text('Tips for Talking to Professionals:', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('• Be honest about your feelings and experiences.'),
                        Text('• It’s okay to feel nervous—professionals are there to help, not judge.'),
                        Text('• Ask questions if you don’t understand something.'),
                        SizedBox(height: 12),
                        Text('“Asking for help is a sign of strength, not weakness.”', style: TextStyle(fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(thickness: 2),
          // TeleManas Helpline Card (no trailing button)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.phone, color: Colors.blue),
                      SizedBox(width: 12),
                      Text('Call TeleManas Helpline', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('14416'),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.phone),
                    label: const Text('Call Now'),
                    onPressed: () => _callNumber('14416'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Nearby Psychiatrists', style: Theme.of(context).textTheme.titleLarge),
          ...psychiatrists.map((doc) => Card(
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.green),
              title: Text(doc['name']!),
              subtitle: Text('${doc['location']}\n${doc['phone']}'),
              trailing: IconButton(
                icon: const Icon(Icons.phone, color: Colors.blue),
                onPressed: () => _callNumber(doc['phone']!),
              ),
            ),
          )),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.group, color: Colors.deepPurple),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('AA Group (Dummy)', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Contact: 90000 12345\nEmail: aa_dummy@email.com'),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.sms, color: Colors.blue),
                        onPressed: () => _sendSms('9000012345'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.email, color: Colors.green),
                        onPressed: () => _sendEmail('aa_dummy@email.com'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Support Team Card (no trailing button)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.support_agent, color: Colors.orange),
                      SizedBox(width: 12),
                      Text('Support Team', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Phone: 80000 11111'),
                  const Text('Email: support@dimhans.org'),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: Icon(Icons.email, color: Colors.white),
                    label: Text('Email Support'),
                    onPressed: () => _sendEmail('support@dimhans.org'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 