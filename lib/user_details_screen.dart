import 'package:flutter/material.dart';
import 'admin_service.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userId;

  const UserDetailsScreen({super.key, required this.userId});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen>
    with SingleTickerProviderStateMixin {
  UserDetails? _userDetails;
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userDetails = await AdminService.getUserDetails(widget.userId);
      setState(() {
        _userDetails = userDetails;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading user details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      appBar: AppBar(
        title: Text(_userDetails?.displayName ?? 'User Details'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.info)),
            Tab(text: 'Mood History', icon: Icon(Icons.mood)),
            Tab(text: 'Assessments', icon: Icon(Icons.quiz)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userDetails == null
          ? const Center(
              child: Text('User not found', style: TextStyle(fontSize: 18)),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildMoodHistoryTab(),
                _buildAssessmentsTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: _userDetails!.isActive
                            ? Colors.green
                            : Colors.grey,
                        child: Text(
                          _userDetails!.displayName.isNotEmpty
                              ? _userDetails!.displayName[0].toUpperCase()
                              : _userDetails!.email[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userDetails!.displayName.isNotEmpty
                                  ? _userDetails!.displayName
                                  : 'No Name',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _userDetails!.email,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  _userDetails!.isActive
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: _userDetails!.isActive
                                      ? Colors.green
                                      : Colors.red,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _userDetails!.isActive
                                      ? 'Active'
                                      : 'Inactive',
                                  style: TextStyle(
                                    color: _userDetails!.isActive
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildInfoRow('User ID', _userDetails!.uid),
                  _buildInfoRow('Joined', _formatDate(_userDetails!.createdAt)),
                  if (_userDetails!.lastLoginAt != null)
                    _buildInfoRow(
                      'Last Login',
                      _formatDate(_userDetails!.lastLoginAt!),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Statistics Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Mood Entries',
                  '${_userDetails!.moodEntries.length}',
                  Icons.mood,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Assessments',
                  '${_userDetails!.assessments.length}',
                  Icons.quiz,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Craving Skills',
                  '${_userDetails!.cravingSkills.length}',
                  Icons.self_improvement,
                  Colors.purple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Avg Mood',
                  _calculateAverageMood(),
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodHistoryTab() {
    if (_userDetails!.moodEntries.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mood_bad, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No mood entries found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _userDetails!.moodEntries.length,
      itemBuilder: (context, index) {
        final entry = _userDetails!.moodEntries[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getMoodColor(entry.mood),
              child: Text(
                '${entry.mood}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(_getMoodDescription(entry.mood)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (entry.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(entry.note),
                ],
                const SizedBox(height: 4),
                Text(
                  _formatDateTime(entry.timestamp),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAssessmentsTab() {
    if (_userDetails!.assessments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No assessments found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _userDetails!.assessments.length,
      itemBuilder: (context, index) {
        final assessment = _userDetails!.assessments[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getScoreColor(assessment.score),
              child: Text(
                '${assessment.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text('Assessment Score: ${assessment.score}'),
            subtitle: Text(
              _formatDateTime(assessment.timestamp),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () => _showAssessmentDetails(assessment),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getMoodColor(int mood) {
    if (mood >= 8) return Colors.green;
    if (mood >= 6) return Colors.lightGreen;
    if (mood >= 4) return Colors.orange;
    if (mood >= 2) return Colors.deepOrange;
    return Colors.red;
  }

  String _getMoodDescription(int mood) {
    if (mood >= 8) return 'Excellent';
    if (mood >= 6) return 'Good';
    if (mood >= 4) return 'Okay';
    if (mood >= 2) return 'Poor';
    return 'Very Poor';
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.lightGreen;
    if (score >= 40) return Colors.orange;
    if (score >= 20) return Colors.deepOrange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _calculateAverageMood() {
    if (_userDetails!.moodEntries.isEmpty) return 'N/A';
    final sum = _userDetails!.moodEntries.fold(
      0,
      (sum, entry) => sum + entry.mood,
    );
    final average = sum / _userDetails!.moodEntries.length;
    return average.toStringAsFixed(1);
  }

  void _showAssessmentDetails(AssessmentData assessment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Assessment Details - ${_formatDateTime(assessment.timestamp)}',
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Score: ${assessment.score}'),
              const SizedBox(height: 16),
              const Text(
                'Answers:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...assessment.answers.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('${entry.key}: ${entry.value}'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
