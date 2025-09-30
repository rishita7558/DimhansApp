import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_service.dart';
import 'user_details_screen.dart';
import 'admin_management_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserData> _users = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _recentMoodEntries = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentMoodEntries() async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup('mood_entries')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();

      _recentMoodEntries = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'mood_level': data['mood_level'] ?? 0,
          'mood_description': data['mood_description'] ?? '',
          'triggers': data['triggers'] ?? [],
          'coping_strategies': data['coping_strategies'] ?? [],
          'timestamp': data['timestamp']?.toDate() ?? DateTime.now(),
          'user_email': data['user_email'] ?? 'Unknown',
        };
      }).toList();
    } catch (e) {
      print('Error loading recent mood entries: $e');
      _recentMoodEntries = [];
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('Loading users from Firestore...');

      // Debug: Check what's actually in Firestore
      final querySnapshot = await _firestore.collection('users').get();
      print(
        'Raw Firestore query result: ${querySnapshot.docs.length} documents',
      );
      for (var doc in querySnapshot.docs) {
        print('Document ID: ${doc.id}, Data: ${doc.data()}');
      }

      final users = await AdminService.getAllUsers();
      print('Loaded ${users.length} users from AdminService');
      final stats = await AdminService.getUserStats();
      print('Loaded stats: $stats');

      await _loadRecentMoodEntries();

      setState(() {
        _users = users;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<UserData> get _filteredUsers {
    if (_searchQuery.isEmpty) return _users;
    return _users.where((user) {
      return user.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.displayName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Future<void> _logout() async {
    try {
      await AdminService.clearAdminSession();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleUserStatus(UserData user) async {
    try {
      final success = await AdminService.updateUserStatus(
        user.uid,
        !user.isActive,
      );
      if (success) {
        setState(() {
          user = UserData(
            uid: user.uid,
            email: user.email,
            displayName: user.displayName,
            createdAt: user.createdAt,
            lastLoginAt: user.lastLoginAt,
            isActive: !user.isActive,
          );
          _users[_users.indexWhere((u) => u.uid == user.uid)] = user;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              user.isActive ? 'User activated' : 'User deactivated',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating user: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AdminManagementScreen(),
                ),
              );
            },
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'Manage Admins',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Stats Cards
                _buildStatsCards(),

                // Recent Mood Entries
                _buildRecentMoodEntries(),

                // Search Bar
                _buildSearchBar(),

                // Users List
                Expanded(child: _buildUsersList()),
              ],
            ),
    );
  }

  Widget _buildRecentMoodEntries() {
    if (_recentMoodEntries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.mood, color: Colors.orange[600], size: 24),
              const SizedBox(width: 8),
              Text(
                'Recent Mood Entries',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...(_recentMoodEntries
              .take(5)
              .map((entry) => _buildMoodEntryCard(entry))),
        ],
      ),
    );
  }

  Widget _buildMoodEntryCard(Map<String, dynamic> entry) {
    final moodLabels = ['Very Low', 'Low', 'Neutral', 'Good', 'Excellent'];
    final moodColors = [
      Colors.red[400]!,
      Colors.orange[400]!,
      Colors.yellow[600]!,
      Colors.lightGreen[400]!,
      Colors.green[400]!,
    ];

    final moodLevel = entry['mood_level'] as int;
    final moodLabel = moodLevel > 0 && moodLevel <= 5
        ? moodLabels[moodLevel - 1]
        : 'Unknown';
    final moodColor = moodLevel > 0 && moodLevel <= 5
        ? moodColors[moodLevel - 1]
        : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: moodColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: moodColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: moodColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                moodLevel.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry['user_email'] ?? 'Unknown User',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  moodLabel,
                  style: TextStyle(
                    color: moodColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                if (entry['mood_description']?.isNotEmpty == true)
                  Text(
                    entry['mood_description'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Text(
            _formatDate(entry['timestamp']),
            style: TextStyle(color: Colors.grey[500], fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Users',
              '${_stats['totalUsers'] ?? 0}',
              Icons.people,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Active Users',
              '${_stats['activeUsers'] ?? 0}',
              Icons.person,
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Mood Entries',
              '${_stats['totalMoodEntries'] ?? 0}',
              Icons.mood,
              Colors.orange,
            ),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
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

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search users by email or name...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red[700]!, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildUsersList() {
    final filteredUsers = _filteredUsers;

    if (filteredUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? 'No users found'
                  : 'No users match your search',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Users will appear here when they register and log in to the app',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                const SizedBox(height: 8),
              ],
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return _buildUserCard(user);
      },
    );
  }

  Widget _buildUserCard(UserData user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: user.isActive ? Colors.green : Colors.grey,
          child: Text(
            user.displayName.isNotEmpty
                ? user.displayName[0].toUpperCase()
                : user.email[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.displayName.isNotEmpty ? user.displayName : 'No Name',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            const SizedBox(height: 4),
            Text(
              'Joined: ${_formatDate(user.createdAt)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            if (user.lastLoginAt != null)
              Text(
                'Last login: ${_formatDate(user.lastLoginAt!)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: user.isActive,
              onChanged: (_) => _toggleUserStatus(user),
              activeColor: Colors.green,
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => UserDetailsScreen(userId: user.uid),
                  ),
                );
              },
              tooltip: 'View Details',
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
