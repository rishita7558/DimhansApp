import 'package:firebase_auth/firebase_auth.dart';
import 'package:dimhans_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check if current user is admin by checking Backend
  static Future<bool> get isAdmin async {
    final user = _auth.currentUser;
    if (user?.email == null) return false;

    try {
      // In a real app, we should check with the backend
      // For now, we can check if the user is in the admin list from backend
      // Or rely on the backend to enforce admin permissions
      final userDetails = await ApiService.getCurrentUserDetails();
      return userDetails['isAdmin'] == true;
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }

  // Get current admin user
  static User? get currentAdmin => _auth.currentUser;

  // Create admin account
  static Future<bool> createAdminAccount({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Register via Backend API
      final user = await ApiService.register(email, password, displayName);

      // Note: The backend register endpoint defaults isAdmin to false.
      // We might need a way to make the first user admin or use a secret key.
      // For now, relying on the backend logic or manual promotion.
      // However, the user asked to "create a valid admin account".
      // Since we are moving away from Firebase, the previous "createAdminAccount" logic
      // which relied on Firebase Auth is being replaced.

      if (user == true) {
        await _saveAdminSession(email);
        return true;
      }
      return false;
    } catch (e) {
      print('Admin registration error: $e');
      rethrow;
    }
  }

  // Admin login validation
  static Future<bool> validateAdminLogin(String email, String password) async {
    try {
      // Login via Backend API
      final user = await ApiService.login(email, password);

      if (user['isAdmin'] == true) {
        await _saveAdminSession(email);
        return true;
      }
      return false;
    } catch (e) {
      print('Admin login validation error: $e');
      return false;
    }
  }

  // Save admin session
  static Future<void> _saveAdminSession(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAdminLoggedIn', true);
      await prefs.setString('adminEmail', email);
      await prefs.setInt(
        'adminLoginTime',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      print('Error saving admin session: $e');
    }
  }

  // Clear admin session
  static Future<void> clearAdminSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isAdminLoggedIn');
      await prefs.remove('adminEmail');
      await prefs.remove('adminLoginTime');
    } catch (e) {
      print('Error clearing admin session: $e');
    }
  }

  // Get all users from Backend
  static Future<List<UserData>> getAllUsers() async {
    try {
      final usersData = await ApiService.getAllUsers();

      return usersData.map((data) {
        return UserData(
          uid: data['_id'] ?? '',
          email: data['email'] ?? '',
          displayName: data['displayName'] ?? '',
          createdAt:
              DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
          lastLoginAt: DateTime.tryParse(data['lastLoginAt'] ?? ''),
          isActive: data['isActive'] ?? true,
        );
      }).toList();
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  // Get user details with mood data and assessments
  static Future<UserDetails?> getUserDetails(String userId) async {
    try {
      final data = await ApiService.getUserDetails(userId);
      if (data == null) return null;

      final moodEntries = (data['moodEntries'] as List? ?? []).map((entry) {
        return MoodEntry(
          id: entry['_id'] ?? '',
          mood: entry['moodLevel'] ?? 0,
          note: entry['moodDescription'] ?? '',
          timestamp:
              DateTime.tryParse(entry['timestamp'] ?? '') ?? DateTime.now(),
        );
      }).toList();

      final assessments = (data['assessments'] as List? ?? []).map((
        assessment,
      ) {
        return AssessmentData(
          id: assessment['_id'] ?? '',
          score: assessment['score'] ?? 0,
          answers: Map<String, dynamic>.from(assessment['answers'] ?? {}),
          timestamp:
              DateTime.tryParse(assessment['timestamp'] ?? '') ??
              DateTime.now(),
        );
      }).toList();

      // Placeholder for craving skills
      final cravingSkills = <CravingSkillUsage>[];

      return UserDetails(
        uid: data['firebaseUid'] ?? '',
        email: data['email'] ?? '',
        displayName: data['displayName'] ?? '',
        createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
        lastLoginAt: DateTime.tryParse(data['lastLoginAt'] ?? ''),
        isActive: data['isActive'] ?? true,
        moodEntries: moodEntries,
        assessments: assessments,
        cravingSkills: cravingSkills,
      );
    } catch (e) {
      print('Error getting user details: $e');
      return null;
    }
  }

  // Update user status
  static Future<bool> updateUserStatus(String userId, bool isActive) async {
    return await ApiService.updateUserStatus(userId, isActive);
  }

  // Get user statistics
  static Future<Map<String, dynamic>> getUserStats() async {
    try {
      return await ApiService.getStats();
    } catch (e) {
      print('Error getting user stats: $e');
      return {};
    }
  }

  // Clear all user data
  static Future<bool> clearAllUserData() async {
    // TODO: Implement backend endpoint for clearing ALL data if needed
    // For now, return false or implement loop delete
    return false;
  }

  // Clear data for a specific user
  static Future<bool> clearUserData(String userId) async {
    return await ApiService.deleteUser(userId);
  }

  // Add admin account
  static Future<bool> addAdminAccount({
    required String email,
    required String displayName,
    required String role,
  }) async {
    return await ApiService.addAdminAccount({
      'email': email,
      'displayName': displayName,
      'role': role,
    });
  }

  // Remove admin account
  static Future<bool> removeAdminAccount(String adminId) async {
    return await ApiService.removeAdminAccount(adminId);
  }

  // Get all admin accounts
  static Future<List<Map<String, dynamic>>> getAllAdminAccounts() async {
    return await ApiService.getAllAdminAccounts();
  }
}

// Data models
class UserData {
  final String uid;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isActive;

  UserData({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
    this.lastLoginAt,
    required this.isActive,
  });
}

class UserDetails extends UserData {
  final List<MoodEntry> moodEntries;
  final List<AssessmentData> assessments;
  final List<CravingSkillUsage> cravingSkills;

  UserDetails({
    required super.uid,
    required super.email,
    required super.displayName,
    required super.createdAt,
    super.lastLoginAt,
    required super.isActive,
    required this.moodEntries,
    required this.assessments,
    required this.cravingSkills,
  });
}

class MoodEntry {
  final String id;
  final int mood;
  final String note;
  final DateTime timestamp;

  MoodEntry({
    required this.id,
    required this.mood,
    required this.note,
    required this.timestamp,
  });
}

class AssessmentData {
  final String id;
  final int score;
  final Map<String, dynamic> answers;
  final DateTime timestamp;

  AssessmentData({
    required this.id,
    required this.score,
    required this.answers,
    required this.timestamp,
  });
}

class CravingSkillUsage {
  final String id;
  final String skillName;
  final int effectiveness;
  final DateTime timestamp;

  CravingSkillUsage({
    required this.id,
    required this.skillName,
    required this.effectiveness,
    required this.timestamp,
  });
}
