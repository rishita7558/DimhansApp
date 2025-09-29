import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_service.dart';
import 'user_details_screen.dart';
import 'migrate_users.dart';
import 'auth_service.dart';

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

                // Search Bar
                _buildSearchBar(),

                // Users List
                Expanded(child: _buildUsersList()),
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
