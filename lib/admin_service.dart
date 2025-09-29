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

  // Get all users from Firestore (excluding admin accounts)
  static Future<List<UserData>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();

      return querySnapshot.docs
          .where((doc) {
            final data = doc.data();
            final isAdmin = data['isAdmin'] == true;
            final email = data['email'] ?? '';

            // Also check if this is a known admin email (for existing accounts)
            final knownAdminEmails = [
              'poddaturimithil1@gmail.com',
              'poddaturimit1@gmail.com',
              'poddaturimit@gmail.com',
            ];
            final isKnownAdmin = knownAdminEmails.contains(email);

            // Filter out admin accounts (either by isAdmin flag OR known admin emails)
            return !isAdmin && !isKnownAdmin;
          })
          .map((doc) {
            final data = doc.data();
            return UserData(
              uid: doc.id,
              email: data['email'] ?? '',
              displayName: data['displayName'] ?? '',
              createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
              lastLoginAt: data['lastLoginAt']?.toDate(),
              isActive: data['isActive'] ?? true,
            );
          })
          .toList();
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

      if (!userDoc.exists) {
        // Try to get user from Firebase Auth as fallback
        try {
          final authUser = _auth.currentUser;
          if (authUser != null && authUser.uid == userId) {
            print('Found user in Firebase Auth, creating Firestore document');
            // Create user document in Firestore
            await _firestore.collection('users').doc(userId).set({
              'email': authUser.email ?? '',
              'displayName': authUser.displayName ?? 'User',
              'isAdmin': false,
              'isActive': true,
              'createdAt': FieldValue.serverTimestamp(),
              'lastLoginAt': FieldValue.serverTimestamp(),
            });
            // Retry getting the document
            final retryDoc = await _firestore
                .collection('users')
                .doc(userId)
                .get();
            if (retryDoc.exists) {
              final userData = retryDoc.data()!;
              print('Created user document: $userData');
            } else {
              return null;
            }
          } else {
            return null;
          }
        } catch (e) {
          print('Error creating user document: $e');
          return null;
        }
      }

      final userData = userDoc.data()!;

      // Get mood tracking data from quick_mood_entries collection
      final moodQuery = await _firestore
          .collection('users')
          .doc(userId)
          .collection('quick_mood_entries')
          .get();

      final moodEntries = moodQuery.docs.map((doc) {
        final data = doc.data();
        return MoodEntry(
          id: doc.id,
          mood: data['mood_level'] ?? 0, // Changed from 'mood' to 'mood_level'
          note:
              data['mood_description'] ??
              '', // Changed from 'note' to 'mood_description'
          timestamp: data['timestamp']?.toDate() ?? DateTime.now(),
        );
      }).toList();

      // Sort by timestamp descending (most recent first)
      moodEntries.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Get assessment data from both assessments collection and mood entries
      final assessmentQuery = await _firestore
          .collection('users')
          .doc(userId)
          .collection('assessments')
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

      // Sort by timestamp descending (most recent first)
      assessments.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Also get assessment data from mood entries
      final moodAssessmentQuery = await _firestore
          .collection('users')
          .doc(userId)
          .collection('mood_entries')
          .get();

      final moodAssessments = moodAssessmentQuery.docs
          .where((doc) {
            final data = doc.data();
            return data['assessment_data'] != null;
          })
          .map((doc) {
            final data = doc.data();
            final assessmentData =
                data['assessment_data'] as Map<String, dynamic>? ?? {};
            return AssessmentData(
              id: '${doc.id}_assessment',
              score: _calculateAssessmentScore(assessmentData),
              answers: assessmentData,
              timestamp: data['timestamp']?.toDate() ?? DateTime.now(),
            );
          })
          .toList();

      // Combine both assessment sources
      assessments.addAll(moodAssessments);
      assessments.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Get craving skills usage
      final cravingQuery = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cravingSkills')
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

      // Sort by timestamp descending (most recent first)
      cravingSkills.sort((a, b) => b.timestamp.compareTo(a.timestamp));

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

  // Create a test user for immediate testing

  static Future<int> _getTotalMoodEntries() async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup('quick_mood_entries')
          .get();
      return querySnapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  static Future<int> _getTotalAssessments() async {
    try {
      // Count assessments from both collections
      final assessmentQuery = await _firestore
          .collectionGroup('assessments')
          .get();

      final moodAssessmentQuery = await _firestore
          .collectionGroup('mood_entries')
          .where('assessment_data', isNull: false)
          .get();

      return assessmentQuery.docs.length + moodAssessmentQuery.docs.length;
    } catch (e) {
      return 0;
    }
  }

  // Calculate assessment score based on answers
  static int _calculateAssessmentScore(Map<String, dynamic> answers) {
    int score = 0;

    // Question 1: Do you consume alcohol? (Yes = 1, No = 0)
    if (answers['q1'] == 'Yes') score += 1;

    // Question 2: How often? (More frequent = higher score)
    switch (answers['q2']) {
      case 'Daily':
        score += 4;
        break;
      case 'Weekly':
        score += 3;
        break;
      case 'Monthly':
        score += 2;
        break;
      case 'Rarely':
        score += 1;
        break;
    }

    // Question 4: Reasons (more reasons = higher risk)
    if (answers['q4'] is List) {
      score += (answers['q4'] as List).length;
    }

    // Question 5: Want to learn skills? (No = higher risk)
    if (answers['q5'] == 'No') score += 2;

    return score;
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
    required String uid,
    required String email,
    required String displayName,
    required DateTime createdAt,
    DateTime? lastLoginAt,
    required bool isActive,
    required this.moodEntries,
    required this.assessments,
    required this.cravingSkills,
  }) : super(
         uid: uid,
         email: email,
         displayName: displayName,
         createdAt: createdAt,
         lastLoginAt: lastLoginAt,
         isActive: isActive,
       );
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
