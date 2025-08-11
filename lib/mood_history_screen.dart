import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodHistoryScreen extends StatefulWidget {
  const MoodHistoryScreen({super.key});

  @override
  State<MoodHistoryScreen> createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  bool _isEnglish = true;
  bool _isLoading = true;
  List<Map<String, dynamic>> _moodEntries = [];
  String _selectedPeriod = '7 days';

  final List<String> _periods = ['7 days', '30 days', '90 days', 'All time'];

  @override
  void initState() {
    super.initState();
    _loadMoodEntries();
  }

  Future<void> _loadMoodEntries() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Try to load from Firestore first
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('mood_entries')
            .orderBy('timestamp', descending: true)
            .get();

        if (snapshot.docs.isNotEmpty) {
          _moodEntries = snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'mood_level': data['mood_level'] ?? 3,
              'mood_description': data['mood_description'] ?? '',
              'triggers': List<String>.from(data['triggers'] ?? []),
              'coping_strategies': List<String>.from(data['coping_strategies'] ?? []),
              'timestamp': (data['timestamp'] as Timestamp).toDate(),
            };
          }).toList();
        } else {
          // Fallback to local storage
          await _loadFromLocalStorage();
        }
      } else {
        await _loadFromLocalStorage();
      }
    } catch (e) {
      // Fallback to local storage on error
      await _loadFromLocalStorage();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final moodEntriesData = prefs.getStringList('mood_entries') ?? [];
      
      _moodEntries = moodEntriesData.map((entryString) {
        // Parse the stored string back to map
        final entry = Map<String, dynamic>.from(
          Map.fromEntries(
            entryString
                .replaceAll('{', '')
                .replaceAll('}', '')
                .split(',')
                .map((pair) {
              final keyValue = pair.split(':');
              if (keyValue.length == 2) {
                return MapEntry(
                  keyValue[0].trim(),
                  keyValue[1].trim(),
                );
              }
              return MapEntry('', '');
            }),
          ),
        );
        
        return {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'mood_level': int.tryParse(entry['mood_level'] ?? '3') ?? 3,
          'mood_description': entry['mood_description'] ?? '',
          'triggers': (entry['triggers'] ?? '').split(',').where((s) => s.isNotEmpty).toList(),
          'coping_strategies': (entry['coping_strategies'] ?? '').split(',').where((s) => s.isNotEmpty).toList(),
          'timestamp': DateTime.tryParse(entry['timestamp'] ?? '') ?? DateTime.now(),
        };
      }).toList();
    } catch (e) {
      _moodEntries = [];
    }
  }

  List<Map<String, dynamic>> get _filteredEntries {
    if (_selectedPeriod == 'All time') return _moodEntries;
    
    final now = DateTime.now();
    final days = int.parse(_selectedPeriod.split(' ')[0]);
    final cutoff = now.subtract(Duration(days: days));
    
    return _moodEntries.where((entry) {
      return entry['timestamp'].isAfter(cutoff);
    }).toList();
  }

  double get _averageMood {
    if (_filteredEntries.isEmpty) return 0;
    final total = _filteredEntries.fold(0.0, (sum, entry) => sum + entry['mood_level']);
    return total / _filteredEntries.length;
  }

  Map<String, int> get _triggerFrequency {
    final Map<String, int> frequency = {};
    for (final entry in _filteredEntries) {
      for (final trigger in entry['triggers']) {
        frequency[trigger] = (frequency[trigger] ?? 0) + 1;
      }
    }
    return frequency;
  }

  Map<String, int> get _copingStrategyFrequency {
    final Map<String, int> frequency = {};
    for (final entry in _filteredEntries) {
      for (final strategy in entry['coping_strategies']) {
        frequency[strategy] = (frequency[strategy] ?? 0) + 1;
      }
    }
    return frequency;
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
      ),
      body: Column(
        children: [
          // Language Toggle and Period Selector
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Language Toggle
                Expanded(
                  child: _buildLanguageToggle(theme),
                ),
                const SizedBox(width: 16),
                // Period Selector
                Expanded(
                  child: _buildPeriodSelector(theme),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredEntries.isEmpty
                    ? _buildEmptyState(theme)
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Summary Cards
                            _buildSummaryCards(theme),
                            const SizedBox(height: 24),
                            
                            // Mood Trend Chart
                            _buildMoodTrendChart(theme),
                            const SizedBox(height: 24),
                            
                            // Triggers Analysis
                            _buildTriggersAnalysis(theme),
                            const SizedBox(height: 24),
                            
                            // Coping Strategies Analysis
                            _buildCopingStrategiesAnalysis(theme),
                            const SizedBox(height: 24),
                            
                            // Recent Entries
                            _buildRecentEntries(theme),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageToggle(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'EN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _isEnglish ? theme.primaryColor : Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: _isEnglish,
              onChanged: (value) {
                setState(() {
                  _isEnglish = value;
                });
              },
              activeColor: theme.primaryColor,
              activeTrackColor: theme.primaryColor.withOpacity(0.3),
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'ಕ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: !_isEnglish ? theme.primaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButton<String>(
        value: _selectedPeriod,
        isExpanded: true,
        underline: const SizedBox(),
        items: _periods.map((period) {
          return DropdownMenuItem(
            value: period,
            child: Text(period),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedPeriod = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mood,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            _isEnglish 
              ? 'No mood entries yet'
              : 'ಇನ್ನೂ ಯಾವುದೇ ಮನಸ್ಥಿತಿ ನಮೂದುಗಳಿಲ್ಲ',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _isEnglish
              ? 'Complete an assessment and start tracking your mood to see insights here'
              : 'ಒಂದು ಮೌಲ್ಯಮಾಪನವನ್ನು ಪೂರ್ಣಗೊಳಿಸಿ ಮತ್ತು ಇಲ್ಲಿ ಒಳನೋಟಗಳನ್ನು ನೋಡಲು ನಿಮ್ಮ ಮನಸ್ಥಿತಿಯನ್ನು ಟ್ರ್ಯಾಕ್ ಮಾಡಲು ಪ್ರಾರಂಭಿಸಿ',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            theme,
            title: _isEnglish ? 'Entries' : 'ನಮೂದುಗಳು',
            value: _filteredEntries.length.toString(),
            icon: Icons.assessment,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            theme,
            title: _isEnglish ? 'Avg Mood' : 'ಸರಾಸರಿ ಮನಸ್ಥಿತಿ',
            value: _averageMood.toStringAsFixed(1),
            icon: Icons.mood,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(ThemeData theme, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodTrendChart(theme) {
    if (_filteredEntries.length < 2) return const SizedBox.shrink();
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? 'Mood Trend' : 'ಮನಸ್ಥಿತಿ ಪ್ರವೃತ್ತಿ',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CustomPaint(
                size: const Size(double.infinity, 200),
                painter: MoodChartPainter(
                  moodEntries: _filteredEntries.reversed.toList(),
                  theme: theme,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTriggersAnalysis(theme) {
    if (_triggerFrequency.isEmpty) return const SizedBox.shrink();
    
    final sortedTriggers = _triggerFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? 'Common Triggers' : 'ಸಾಮಾನ್ಯ ಕಾರಣಗಳು',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ...sortedTriggers.take(5).map((trigger) {
              final percentage = (trigger.value / _filteredEntries.length * 100).round();
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(trigger.key)),
                        Text('$percentage%'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: trigger.value / _filteredEntries.length,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCopingStrategiesAnalysis(theme) {
    if (_copingStrategyFrequency.isEmpty) return const SizedBox.shrink();
    
    final sortedStrategies = _copingStrategyFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? 'Effective Coping Strategies' : 'ಪರಿಣಾಮಕಾರಿ ನಿರ್ವಹಣಾ ತಂತ್ರಗಳು',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ...sortedStrategies.take(5).map((strategy) {
              final percentage = (strategy.value / _filteredEntries.length * 100).round();
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(strategy.key)),
                        Text('$percentage%'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: strategy.value / _filteredEntries.length,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentEntries(theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? 'Recent Entries' : 'ಇತ್ತೀಚಿನ ನಮೂದುಗಳು',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ..._filteredEntries.take(5).map((entry) {
              final date = entry['timestamp'] as DateTime;
              final moodLevel = entry['mood_level'] as int;
              final moodEmojis = ['😢', '😔', '😐', '🙂', '😊'];
              
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  child: Text(
                    moodEmojis[moodLevel - 1],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                title: Text(
                  'Mood Level $moodLevel',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${date.day}/${date.month}/${date.year}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    if (entry['mood_description'].isNotEmpty)
                      Text(
                        entry['mood_description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
                onTap: () {
                  _showEntryDetails(entry);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showEntryDetails(Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isEnglish ? 'Mood Entry Details' : 'ಮನಸ್ಥಿತಿ ನಮೂದಿನ ವಿವರಗಳು'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Date: ${_formatDate(entry['timestamp'])}'),
              const SizedBox(height: 8),
              Text('Mood Level: ${entry['mood_level']}/5'),
              if (entry['mood_description'].isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Notes: ${entry['mood_description']}'),
              ],
              if (entry['triggers'].isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Triggers: ${entry['triggers'].join(', ')}'),
              ],
              if (entry['coping_strategies'].isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Coping Strategies: ${entry['coping_strategies'].join(', ')}'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(_isEnglish ? 'Close' : 'ಮುಚ್ಚಿ'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Custom painter for mood chart
class MoodChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> moodEntries;
  final ThemeData theme;

  MoodChartPainter({required this.moodEntries, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    if (moodEntries.length < 2) return;

    final paint = Paint()
      ..color = theme.primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = theme.primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final width = size.width;
    final height = size.height;
    final padding = 20.0;
    final chartWidth = width - 2 * padding;
    final chartHeight = height - 2 * padding;

    for (int i = 0; i < moodEntries.length; i++) {
      final entry = moodEntries[i];
      final moodLevel = entry['mood_level'] as int;
      
      // Convert mood level (1-5) to y-coordinate (inverted)
      final y = padding + (5 - moodLevel) * (chartHeight / 4);
      final x = padding + i * (chartWidth / (moodEntries.length - 1));

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // Draw data points
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = theme.primaryColor);
    }

    // Complete the fill path
    fillPath.lineTo(width - padding, height - padding);
    fillPath.lineTo(padding, height - padding);
    fillPath.close();

    // Draw filled area
    canvas.drawPath(fillPath, fillPaint);
    
    // Draw line
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 