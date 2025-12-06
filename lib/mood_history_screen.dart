import 'package:flutter/material.dart';
import 'package:dimhans_app/services/api_service.dart';
import 'package:dimhans_app/auth_service.dart';
import 'package:intl/intl.dart';

class MoodHistoryScreen extends StatefulWidget {
  const MoodHistoryScreen({super.key});

  @override
  State<MoodHistoryScreen> createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  bool _isEnglish = true;
  List<Map<String, dynamic>> _moodEntries = [];
  bool _isLoading = true;
  String _selectedPeriod = 'week'; // week, month, year
  Map<String, dynamic> _moodStats = {};

  @override
  void initState() {
    super.initState();
    _loadMoodHistory();
  }

  Future<void> _loadMoodHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (AuthService.isLoggedIn) {
        // Get date range based on selected period
        final DateTime endDate = DateTime.now();
        final DateTime startDate = _getStartDate(endDate, _selectedPeriod);

        // Fetch mood history from backend
        // Note: Backend might need to support date filtering params,
        // or we filter client-side for now if the dataset is small.
        // Assuming ApiService.getMoodHistory() returns all entries for now.
        final moodData = await ApiService.getMoodHistory();

        final allEntries = moodData.map((data) {
          return {
            'id': data['_id'] ?? '',
            'mood_level': data['moodLevel'] ?? 3,
            'mood_description': data['moodDescription'] ?? '',
            'timestamp':
                DateTime.tryParse(data['timestamp'] ?? '') ?? DateTime.now(),
          };
        }).toList();

        // Filter by date range
        setState(() {
          _moodEntries = allEntries.where((entry) {
            final timestamp = entry['timestamp'] as DateTime;
            return timestamp.isAfter(startDate) &&
                timestamp.isBefore(
                  endDate.add(const Duration(days: 1)),
                ); // Add 1 day to include end date fully
          }).toList();

          // Sort by timestamp descending
          _moodEntries.sort(
            (a, b) => (b['timestamp'] as DateTime).compareTo(
              a['timestamp'] as DateTime,
            ),
          );
        });

        _calculateMoodStats();
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  DateTime _getStartDate(DateTime endDate, String period) {
    switch (period) {
      case 'week':
        return endDate.subtract(const Duration(days: 7));
      case 'month':
        return DateTime(endDate.year, endDate.month - 1, endDate.day);
      case 'year':
        return DateTime(endDate.year - 1, endDate.month, endDate.day);
      default:
        return endDate.subtract(const Duration(days: 7));
    }
  }

  void _calculateMoodStats() {
    if (_moodEntries.isEmpty) return;

    final totalEntries = _moodEntries.length;
    final averageMood =
        _moodEntries.fold(
          0.0,
          (sum, entry) => sum + (entry['mood_level'] as int),
        ) /
        totalEntries;

    final moodCounts = <int, int>{};
    for (final entry in _moodEntries) {
      final moodLevel = entry['mood_level'] as int;
      moodCounts[moodLevel] = (moodCounts[moodLevel] ?? 0) + 1;
    }

    final mostFrequentMood = moodCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    setState(() {
      _moodStats = {
        'total_entries': totalEntries,
        'average_mood': averageMood,
        'most_frequent_mood': mostFrequentMood,
        'mood_counts': moodCounts,
      };
    });
  }

  void _onPeriodChanged(String? period) {
    if (period != null) {
      setState(() {
        _selectedPeriod = period;
      });
      _loadMoodHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      appBar: AppBar(
        title: Text(_isEnglish ? 'Mood History' : 'ಮನಸ್ಥಿತಿ ಇತಿಹಾಸ'),
        backgroundColor: Colors.white,
        foregroundColor: theme.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEnglish ? Icons.language : Icons.language),
            onPressed: () {
              setState(() {
                _isEnglish = !_isEnglish;
              });
            },
            tooltip: _isEnglish ? 'ಕನ್ನಡಕ್ಕೆ ಬದಲಾಯಿಸಿ' : 'Switch to English',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Period Selector
                  _buildPeriodSelector(theme),
                  const SizedBox(height: 24),

                  // Mood Statistics
                  if (_moodStats.isNotEmpty) _buildMoodStats(theme),
                  const SizedBox(height: 24),

                  // Mood Entries List
                  _buildMoodEntriesList(theme),
                ],
              ),
            ),
    );
  }

  Widget _buildPeriodSelector(ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? 'Select Time Period' : 'ಸಮಯದ ಅವಧಿಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPeriod,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              items: [
                DropdownMenuItem(
                  value: 'week',
                  child: Text(_isEnglish ? 'Last 7 Days' : 'ಕಳೆದ 7 ದಿನಗಳು'),
                ),
                DropdownMenuItem(
                  value: 'month',
                  child: Text(_isEnglish ? 'Last Month' : 'ಕಳೆದ ತಿಂಗಳು'),
                ),
                DropdownMenuItem(
                  value: 'year',
                  child: Text(_isEnglish ? 'Last Year' : 'ಕಳೆದ ವರ್ಷ'),
                ),
              ],
              onChanged: _onPeriodChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodStats(ThemeData theme) {
    final moodLabels = ['Very Low', 'Low', 'Neutral', 'Good', 'Excellent'];
    final moodColors = [
      Colors.red[400]!,
      Colors.orange[400]!,
      Colors.yellow[600]!,
      Colors.lightGreen[400]!,
      Colors.green[400]!,
    ];

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? 'Mood Statistics' : 'ಮನಸ್ಥಿತಿ ಅಂಕಿಅಂಶಗಳು',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            // Summary Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    _isEnglish ? 'Total Entries' : 'ಒಟ್ಟು ನಮೂದುಗಳು',
                    '${_moodStats['total_entries']}',
                    Icons.assessment,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    _isEnglish ? 'Average Mood' : 'ಸರಾಸರಿ ಮನಸ್ಥಿತಿ',
                    '${_moodStats['average_mood'].toStringAsFixed(1)}',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Mood Distribution
            Text(
              _isEnglish ? 'Mood Distribution' : 'ಮನಸ್ಥಿತಿ ವಿತರಣೆ',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),

            Column(
              children: List.generate(5, (index) {
                final moodLevel = index + 1;
                final count = _moodStats['mood_counts'][moodLevel] ?? 0;
                final percentage = _moodStats['total_entries'] > 0
                    ? (count / _moodStats['total_entries'] * 100)
                          .toStringAsFixed(1)
                    : '0.0';

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          moodLabels[index],
                          style: TextStyle(
                            fontSize: 12,
                            color: moodColors[index],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: _moodStats['total_entries'] > 0
                              ? count / _moodStats['total_entries']
                              : 0.0,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            moodColors[index],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 60,
                        child: Text(
                          '$count ($percentage%)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
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
    );
  }

  Widget _buildMoodEntriesList(ThemeData theme) {
    if (_moodEntries.isEmpty) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(Icons.mood_bad, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                _isEnglish
                    ? 'No mood entries found for this period'
                    : 'ಈ ಅವಧಿಗೆ ಯಾವುದೇ ಮನಸ್ಥಿತಿ ನಮೂದುಗಳು ಕಂಡುಬಂದಿಲ್ಲ',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? 'Mood Entries' : 'ಮನಸ್ಥಿತಿ ನಮೂದುಗಳು',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _moodEntries.length,
              itemBuilder: (context, index) {
                final entry = _moodEntries[index];
                final moodLevel = entry['mood_level'] as int;
                final moodLabels = [
                  'Very Low',
                  'Low',
                  'Neutral',
                  'Good',
                  'Excellent',
                ];
                final moodEmojis = ['😢', '😔', '😐', '🙂', '😊'];
                final moodColors = [
                  Colors.red[400]!,
                  Colors.orange[400]!,
                  Colors.yellow[600]!,
                  Colors.lightGreen[400]!,
                  Colors.green[400]!,
                ];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: moodColors[moodLevel - 1].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: moodColors[moodLevel - 1].withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: moodColors[moodLevel - 1],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            moodEmojis[moodLevel - 1],
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              moodLabels[moodLevel - 1],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: moodColors[moodLevel - 1],
                                fontSize: 16,
                              ),
                            ),
                            if (entry['mood_description'].isNotEmpty)
                              Text(
                                entry['mood_description'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat('MMM dd').format(entry['timestamp']),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            DateFormat('HH:mm').format(entry['timestamp']),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
