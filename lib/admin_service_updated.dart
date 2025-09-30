import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Admin email list - in production, this should be stored in Firestore
  static const List<String> _adminEmails = [
    'admin@dimhans.com',
    'admin@example.com',
    'test@admin.com', // Added for testing
    'your-email@example.com', // Replace with your actual email
  ];

  // Check if current user is admin
  static bool get isAdmin {
    final user = _auth.currentUser;
    if (user?.email == null) return false;
    return _adminEmails.contains(user!.email!.toLowerCase());
  }

  // Get current admin user
  static User? get currentAdmin => isAdmin ? _auth.currentUser : null;

  // Create admin account
  static Future<UserCredential?> createAdminAccount({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Create user account
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        // Update display name
        await userCredential.user!.updateDisplayName(displayName.trim());

        // Save user data to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email.trim(),
          'displayName': displayName.trim(),
          'isAdmin': true,
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
        });

        // Save admin session
        await _saveAdminSession(email);

        return userCredential;
      }
      return null;
    } catch (e) {
      print('Admin registration error: $e');
      rethrow;
    }
  }

  // Admin login validation
  static Future<bool> validateAdminLogin(String email, String password) async {
    try {
      // Try to sign in with Firebase Auth
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Check if user is admin in Firestore
        final userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists && userDoc.data()?['isAdmin'] == true) {
          // Save admin session
          await _saveAdminSession(email);
          return true;
        }
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

  // Get all users from Firestore
  static Future<List<UserData>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return UserData(
          uid: doc.id,
          email: data['email'] ?? '',
          displayName: data['displayName'] ?? '',
          createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
          lastLoginAt: data['lastLoginAt']?.toDate(),
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
      // Get user basic info
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return null;

      final userData = userDoc.data()!;

      // Get mood tracking data
      final moodQuery = await _firestore
          .collection('users')
          .doc(userId)
          .collection('moodEntries')
          .orderBy('timestamp', descending: true)
          .limit(30)
          .get();

      final moodEntries = moodQuery.docs.map((doc) {
        final data = doc.data();
        return MoodEntry(
          id: doc.id,
          mood: data['mood'] ?? 0,
          note: data['note'] ?? '',
          timestamp: data['timestamp']?.toDate() ?? DateTime.now(),
        );
      }).toList();

      // Get assessment data
      final assessmentQuery = await _firestore
          .collection('users')
          .doc(userId)
          .collection('assessments')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();

      final assessments = assessmentQuery.docs.map((doc) {
        final data = doc.data();
        return AssessmentData(
          id: doc.id,
          score: data['score'] ?? 0,
          answers: Map<String, dynamic>.from(data['answers'] ?? {}),
          timestamp: data['timestamp']?.toDate() ?? DateTime.now(),
        );
      }).toList();

      // Get craving skills usage
      final cravingQuery = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cravingSkills')
          .orderBy('timestamp', descending: true)
          .limit(20)
          .get();

      final cravingSkills = cravingQuery.docs.map((doc) {
        final data = doc.data();
        return CravingSkillUsage(
          id: doc.id,
          skillName: data['skillName'] ?? '',
          effectiveness: data['effectiveness'] ?? 0,
          timestamp: data['timestamp']?.toDate() ?? DateTime.now(),
        );
      }).toList();

      return UserDetails(
        uid: userId,
        email: userData['email'] ?? '',
        displayName: userData['displayName'] ?? '',
        createdAt: userData['createdAt']?.toDate() ?? DateTime.now(),
        lastLoginAt: userData['lastLoginAt']?.toDate(),
        isActive: userData['isActive'] ?? true,
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
    try {
      await _firestore.collection('users').doc(userId).update({
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error updating user status: $e');
      return false;
    }
  }

  // Get user statistics
  static Future<Map<String, dynamic>> getUserStats() async {
    try {
      final users = await getAllUsers();
      final activeUsers = users.where((user) => user.isActive).length;
      final totalMoodEntries = await _getTotalMoodEntries();
      final totalAssessments = await _getTotalAssessments();

      return {
        'totalUsers': users.length,
        'activeUsers': activeUsers,
        'inactiveUsers': users.length - activeUsers,
        'totalMoodEntries': totalMoodEntries,
        'totalAssessments': totalAssessments,
      };
    } catch (e) {
      print('Error getting user stats: $e');
      return {};
    }
  }

  static Future<int> _getTotalMoodEntries() async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup('moodEntries')
          .get();
      return querySnapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  static Future<int> _getTotalAssessments() async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup('assessments')
          .get();
      return querySnapshot.docs.length;
    } catch (e) {
      return 0;
    }
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
    required super.id,
    required super.mail,
    required super.isplayName,
    required super.atedAt,
    super.LoginAt,
    required super..isActive,
    required this.moodEntries,
    required this.assessments,
    required this.cravingSkills,
  })DateTime timestamp;

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
