import 'package:flutter/material.dart';
import 'admin_service.dart';

class AdminManagementScreen extends StatefulWidget {
  const AdminManagementScreen({super.key});

  @override
  State<AdminManagementScreen> createState() => _AdminManagementScreenState();
}

class _AdminManagementScreenState extends State<AdminManagementScreen> {
  List<Map<String, dynamic>> _adminAccounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdminAccounts();
  }

  Future<void> _loadAdminAccounts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final accounts = await AdminService.getAllAdminAccounts();
      setState(() {
        _adminAccounts = accounts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading admin accounts: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addAdminAccount() async {
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final roleController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Admin Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'admin@example.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                hintText: 'Admin Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(
                labelText: 'Role',
                hintText: 'Super Admin, Admin, etc.',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result == true) {
      if (emailController.text.trim().isEmpty ||
          nameController.text.trim().isEmpty ||
          roleController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final success = await AdminService.addAdminAccount(
        email: emailController.text.trim(),
        displayName: nameController.text.trim(),
        role: roleController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Admin account added successfully!'
                  : 'Failed to add admin account',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );

        if (success) {
          _loadAdminAccounts();
        }
      }
    }
  }

  Future<void> _removeAdminAccount(String adminId, String email) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Admin Account'),
        content: Text(
          'Are you sure you want to remove admin access for $email?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await AdminService.removeAdminAccount(adminId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Admin account removed successfully!'
                  : 'Failed to remove admin account',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );

        if (success) {
          _loadAdminAccounts();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      appBar: AppBar(
        title: const Text('Admin Management'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadAdminAccounts,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Admin Accounts',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2154),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manage admin access to the dashboard',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Admin accounts list
                Expanded(
                  child: _adminAccounts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.admin_panel_settings_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No admin accounts found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add admin accounts to grant dashboard access',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _adminAccounts.length,
                          itemBuilder: (context, index) {
                            final admin = _adminAccounts[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.red[700],
                                  child: Text(
                                    admin['displayName'][0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  admin['displayName'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(admin['email']),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Role: ${admin['role']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    if (admin['createdAt'] != null)
                                      Text(
                                        'Added: ${_formatDate(admin['createdAt'])}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _removeAdminAccount(
                                    admin['id'],
                                    admin['email'],
                                  ),
                                  tooltip: 'Remove Admin',
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAdminAccount,
        backgroundColor: Colors.red[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
