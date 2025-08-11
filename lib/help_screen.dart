import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  bool _isEnglish = true;

  void _callNumber(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Language Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.language, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'English',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _isEnglish ? Colors.blue : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _isEnglish,
                      onChanged: (value) {
                        setState(() {
                          _isEnglish = value;
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ಕನ್ನಡ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: !_isEnglish ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Title
              Text(
                _isEnglish ? 'Help & Support' : 'ಸಹಾಯ ಮತ್ತು ಬೆಂಬಲ',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Emergency Section
                      _buildEmergencySection(),
                      const SizedBox(height: 16),
                      
                      // Crisis Helplines Section
                      _buildCrisisHelplinesSection(),
                      const SizedBox(height: 16),
                      
                      // National Mental Health Helplines
                      _buildNationalHelplinesSection(),
                      const SizedBox(height: 16),
                      
                      // Alcohol Addiction Support
                      _buildAlcoholSupportSection(),
                      const SizedBox(height: 16),
                      
                      // Professional Help
                      _buildProfessionalHelpSection(),
                      const SizedBox(height: 16),
                      
                      // Self-Help Resources
                      _buildSelfHelpSection(),
                      const SizedBox(height: 16),
                      
                      // Family & Caregiver Support
                      _buildFamilySupportSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencySection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emergency, color: Colors.red, size: 24),
                const SizedBox(width: 12),
                Text(
                  _isEnglish ? 'Emergency Support' : 'ತುರ್ತು ಬೆಂಬಲ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _isEnglish 
                ? 'If you are in immediate danger, call emergency services.'
                : 'ನೀವು ತತ್ಕ್ಷಣದ ಅಪಾಯದಲ್ಲಿದ್ದರೆ, ತುರ್ತು ಸೇವೆಗಳಿಗೆ ಕರೆ ಮಾಡಿ.',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _callNumber('112'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(_isEnglish ? 'Call 112' : '112 ಕರೆ ಮಾಡಿ'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCrisisHelplinesSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.phone_in_talk, color: Colors.blue, size: 24),
                const SizedBox(width: 12),
                Text(
                  _isEnglish ? 'Crisis Helplines' : 'ತುರ್ತು ಸಹಾಯ ಲೈನ್‌ಗಳು',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // TeleManas
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.psychology, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _isEnglish ? 'TeleManas Helpline' : 'ಟೆಲಿಮಾನಸ್ ಸಹಾಯ ಲೈನ್',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isEnglish 
                      ? 'TeleMental Health Assistance and Networking Across States (TeleMANAS) is a government initiative providing 24/7 free mental health support across India.'
                      : 'ಟೆಲಿಮೆಂಟಲ್ ಹೆಲ್ತ್ ಅಸಿಸ್ಟೆನ್ಸ್ ಅಂಡ್ ನೆಟ್‌ವರ್ಕಿಂಗ್ ಅಕ್ರಾಸ್ ಸ್ಟೇಟ್ಸ್ (ಟೆಲಿಮಾನಸ್) ಭಾರತದಾದ್ಯಂತ 24/7 ಉಚಿತ ಮಾನಸಿಕ ಆರೋಗ್ಯ ಬೆಂಬಲ ನೀಡುವ ಸರ್ಕಾರಿ ಯೋಜನೆಯಾಗಿದೆ.',
                    style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEnglish ? 'Services Offered:' : 'ನೀಡಲಾದ ಸೇವೆಗಳು:',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildServiceItem(_isEnglish ? '• Crisis intervention and counseling' : '• ತುರ್ತು ಹಸ್ತಕ್ಷೇಪ ಮತ್ತು ಸಲಹೆ'),
                        _buildServiceItem(_isEnglish ? '• Depression and anxiety support' : '• ಖಿನ್ನತೆ ಮತ್ತು ಆತಂಕ ಬೆಂಬಲ'),
                        _buildServiceItem(_isEnglish ? '• Addiction counseling' : '• ವ್ಯಸನ ಸಲಹೆ'),
                        _buildServiceItem(_isEnglish ? '• Family and relationship issues' : '• ಕುಟುಂಬ ಮತ್ತು ಸಂಬಂಧಗಳ ಸಮಸ್ಯೆಗಳು'),
                        _buildServiceItem(_isEnglish ? '• Referral to local mental health services' : '• ಸ್ಥಳೀಯ ಮಾನಸಿಕ ಆರೋಗ್ಯ ಸೇವೆಗಳಿಗೆ ಉಲ್ಲೇಖ'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.blue, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        _isEnglish ? 'Available 24/7' : '24/7 ಲಭ್ಯವಿದೆ',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.money_off, color: Colors.green, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        _isEnglish ? 'Completely Free' : 'ಸಂಪೂರ್ಣವಾಗಿ ಉಚಿತ',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _callNumber('14416'),
                      icon: const Icon(Icons.phone, size: 18),
                      label: Text(
                        _isEnglish ? 'Call 14416 Now' : 'ಈಗ 14416 ಕರೆ ಮಾಡಿ',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Kiran
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish ? 'Kiran Mental Health Helpline' : 'ಕಿರಣ್ ಮಾನಸಿಕ ಆರೋಗ್ಯ ಸಹಾಯ ಲೈನ್',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isEnglish 
                      ? 'Government mental health support'
                      : 'ಸರ್ಕಾರಿ ಮಾನಸಿಕ ಆರೋಗ್ಯ ಬೆಂಬಲ',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _callNumber('1800-599-0019'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text('1800-599-0019'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNationalHelplinesSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.health_and_safety, color: Colors.purple, size: 24),
                const SizedBox(width: 12),
                Text(
                  _isEnglish ? 'National Mental Health Helplines' : 'ರಾಷ್ಟ್ರೀಯ ಮಾನಸಿಕ ಆರೋಗ್ಯ ಸಹಾಯ ಲೈನ್‌ಗಳು',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildHelplineItem(
              'NIMHANS Crisis Helpline',
              'ಕ್ರೈಸಿಸ್ ಸಹಾಯ ಲೈನ್',
              '080-46110007',
              Colors.purple,
              _isEnglish ? '24/7 crisis intervention' : '24/7 ತುರ್ತು ಹಸ್ತಕ್ಷೇಪ',
            ),
            const SizedBox(height: 12),
            _buildHelplineItem(
              'Vandrevala Foundation',
              'ವಂದ್ರೆವಾಲಾ ಫೌಂಡೇಶನ್',
              '1860-266-2345',
              Colors.indigo,
              _isEnglish ? 'Mental health support' : 'ಮಾನಸಿಕ ಆರೋಗ್ಯ ಬೆಂಬಲ',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlcoholSupportSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.support_agent, color: Colors.orange, size: 24),
                const SizedBox(width: 12),
                Text(
                  _isEnglish ? 'Alcohol Addiction Support' : 'ಮದ್ಯ ವ್ಯಸನ ಬೆಂಬಲ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildHelplineItem(
              'AA India',
              'ಎಎ ಇಂಡಿಯಾ',
              '1800-425-0066',
              Colors.orange,
              _isEnglish ? 'Alcoholics Anonymous support' : 'ಅಲ್ಕೊಹಾಲಿಕ್ಸ್ ಅನಾನಿಮಸ್ ಬೆಂಬಲ',
            ),
            const SizedBox(height: 12),
            _buildHelplineItem(
              'SMART Recovery India',
              'ಸ್ಮಾರ್ಟ್ ರಿಕವರಿ ಇಂಡಿಯಾ',
              'Website',
              Colors.teal,
              _isEnglish ? 'Science-based recovery program' : 'ವಿಜ್ಞಾನ ಆಧಾರಿತ ಚೇತರಿಕೆ ಕಾರ್ಯಕ್ರಮ',
              isWebsite: true,
              url: 'https://www.smartrecovery.org',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalHelpSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medical_services, color: Colors.green, size: 24),
                const SizedBox(width: 12),
                Text(
                  _isEnglish ? 'Professional Help' : 'ವೃತ್ತಿಪರ ಸಹಾಯ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildHelplineItem(
              'DIMHANS, Dharwad',
              'ಡಿಮ್ಹಾನ್ಸ್, ಧಾರವಾಡ',
              '0836-2444444',
              Colors.green,
              _isEnglish ? 'De-addiction center' : 'ವ್ಯಸನ ನಿವಾರಣ ಕೇಂದ್ರ',
            ),
            const SizedBox(height: 12),
            _buildHelplineItem(
              'NIMHANS, Bangalore',
              'ನಿಮ್ಹಾನ್ಸ್, ಬೆಂಗಳೂರು',
              '080-26995000',
              Colors.green,
              _isEnglish ? 'National mental health institute' : 'ರಾಷ್ಟ್ರೀಯ ಮಾನಸಿಕ ಆರೋಗ್ಯ ಸಂಸ್ಥೆ',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelfHelpSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.self_improvement, color: Colors.pink, size: 24),
                const SizedBox(width: 12),
                Text(
                  _isEnglish ? 'Self-Help Resources' : 'ಸ್ವಯಂ ಸಹಾಯ ಸಂಪನ್ಮೂಲಗಳು',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildResourceItem(
              'Mindful.org',
              'ಮೈಂಡ್ಫುಲ್.ಆರ್ಗ್',
              _isEnglish ? 'Meditation and mindfulness resources' : 'ಧ್ಯಾನ ಮತ್ತು ಮೈಂಡ್ಫುಲ್ನೆಸ್ ಸಂಪನ್ಮೂಲಗಳು',
              Colors.pink,
              'https://www.mindful.org',
            ),
            const SizedBox(height: 12),
            _buildResourceItem(
              'Recovery.org',
              'ರಿಕವರಿ.ಆರ್ಗ್',
              _isEnglish ? 'Recovery community and resources' : 'ಚೇತರಿಕೆ ಸಮುದಾಯ ಮತ್ತು ಸಂಪನ್ಮೂಲಗಳು',
              Colors.pink,
              'https://www.recovery.org',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilySupportSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.family_restroom, color: Colors.brown, size: 24),
                const SizedBox(width: 12),
                Text(
                  _isEnglish ? 'Family & Caregiver Support' : 'ಕುಟುಂಬ ಮತ್ತು ಆರೈಕೆದಾರರ ಬೆಂಬಲ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildHelplineItem(
              'Al-Anon India',
              'ಅಲ್-ಅನಾನ್ ಇಂಡಿಯಾ',
              'Website',
              Colors.brown,
              _isEnglish ? 'Support for families of alcoholics' : 'ಮದ್ಯಪಾನಿಗಳ ಕುಟುಂಬಗಳಿಗೆ ಬೆಂಬಲ',
              isWebsite: true,
              url: 'https://www.al-anon.org',
            ),
            const SizedBox(height: 12),
            _buildHelplineItem(
              'Nar-Anon',
              'ನಾರ್-ಅನಾನ್',
              'Website',
              Colors.brown,
              _isEnglish ? 'Support for families of addicts' : 'ವ್ಯಸನಿಗಳ ಕುಟುಂಬಗಳಿಗೆ ಬೆಂಬಲ',
              isWebsite: true,
              url: 'https://www.nar-anon.org',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelplineItem(String titleEn, String titleKn, String number, Color color, String description, {bool isWebsite = false, String? url}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEnglish ? titleEn : titleKn,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isWebsite ? () => _openUrl(url!) : () => _callNumber(number),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(isWebsite ? (_isEnglish ? 'Visit Website' : 'ವೆಬ್‌ಸೈಟ್ ಭೇಟಿ') : number),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black87,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _buildResourceItem(String titleEn, String titleKn, String description, Color color, String url) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEnglish ? titleEn : titleKn,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _openUrl(url),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(_isEnglish ? 'Visit Website' : 'ವೆಬ್‌ಸೈಟ್ ಭೇಟಿ'),
            ),
          ),
        ],
      ),
    );
  }
} 