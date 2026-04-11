import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Replace with your actual backend URL (e.g., http://10.0.2.2:5000 for Android emulator)
  static const String baseUrl = 'https://dimhans-app.vercel.app/api';

  // Store token in memory for session (better to use SharedPreferences for persistence)
  static String? _token;

  static Future<Map<String, String>> getHeaders() async {
    // If token is null, try to load from SharedPreferences (omitted for brevity, assuming login sets it)
    if (_token == null) {
      // Ideally load from prefs here
    }

    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  // Auth: Login
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        return data['user']; // Returns user object including isAdmin
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  // Auth: Register
  static Future<Map<String, dynamic>> register(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'displayName': displayName,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        return data['user'];
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
  }

  // User Sync
  static Future<void> syncUser() async {
    try {
      final headers = await getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/users/sync'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to sync user: ${response.body}');
      }
    } catch (e) {
      print('Error syncing user: $e');
      rethrow;
    }
  }

  // Mood Entries
  static Future<void> addMoodEntry(Map<String, dynamic> data) async {
    try {
      final headers = await getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/moods'),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to add mood entry: ${response.body}');
      }
    } catch (e) {
      print('Error adding mood entry: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> getMoodHistory() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/moods'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get mood history: ${response.body}');
      }
    } catch (e) {
      print('Error getting mood history: $e');
      return [];
    }
  }

  // Assessments
  static Future<void> addAssessment(Map<String, dynamic> data) async {
    try {
      final headers = await getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/assessments'),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to add assessment: ${response.body}');
      }
    } catch (e) {
      print('Error adding assessment: $e');
      rethrow;
    }
  }

  // Admin
  static Future<List<dynamic>> getAllUsers() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/admin/users'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get users: ${response.body}');
      }
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> getStats() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/admin/stats'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get stats: ${response.body}');
      }
    } catch (e) {
      print('Error getting stats: $e');
      return {};
    }
  }

  static Future<Map<String, dynamic>> getCurrentUserDetails() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get current user details: ${response.body}');
      }
    } catch (e) {
      print('Error getting current user details: $e');
      return {};
    }
  }

  // Admin: Get specific user details
  static Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/admin/users/$userId'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to get user details: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting user details: $e');
      return null;
    }
  }

  // Admin: Update user status
  static Future<bool> updateUserStatus(String userId, bool isActive) async {
    try {
      final headers = await getHeaders();
      final response = await http.patch(
        Uri.parse('$baseUrl/admin/users/$userId/status'),
        headers: headers,
        body: jsonEncode({'isActive': isActive}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating user status: $e');
      return false;
    }
  }

  // Admin: Delete user
  static Future<bool> deleteUser(String userId) async {
    try {
      final headers = await getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/admin/users/$userId'),
        headers: headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  // Admin: Get recent mood entries (global)
  static Future<List<dynamic>> getRecentMoodEntries() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/admin/moods?limit=10'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get recent mood entries: ${response.body}');
      }
    } catch (e) {
      print('Error getting recent mood entries: $e');
      return [];
    }
  }

  // Admin: Get all admin accounts
  static Future<List<Map<String, dynamic>>> getAllAdminAccounts() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/admin/admins'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get admin accounts: ${response.body}');
      }
    } catch (e) {
      print('Error getting admin accounts: $e');
      return [];
    }
  }

  // Admin: Add admin account
  static Future<bool> addAdminAccount(Map<String, String> data) async {
    try {
      final headers = await getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/admin/admins'),
        headers: headers,
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error adding admin account: $e');
      return false;
    }
  }

  // Admin: Remove admin account
  static Future<bool> removeAdminAccount(String adminId) async {
    try {
      final headers = await getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/admin/admins/$adminId'),
        headers: headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error removing admin account: $e');
      return false;
    }
  }

  // Admin: Sync Data
  static Future<void> syncData() async {
    try {
      final headers = await getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/admin/sync'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to sync data: ${response.body}');
      }
    } catch (e) {
      print('Error syncing data: $e');
      rethrow;
    }
  }
}
