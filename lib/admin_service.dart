import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check if current user is admin by checking Firestore
  static Future<bool> get isAdmin async {
    final user = _auth.currentUser;
    if (user?.email == null) return false;

    try {
      // Check if user is admin in Firestore
      final userDoc = await _firestore.collection('users').doc(user!.uid).get();

      if (userDoc.exists) {
        return userDoc.data()?['isAdmin'] == true;
      }

      // Also check admins collection for additional admin accounts
      final adminQuery = await _firestore
          .collection('admins')
          .where('email', isEqualTo: user.email!.toLowerCase())
          .where('isActive', isEqualTo: true)
          .get();

      return adminQuery.docs.isNotEmpty;
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }

  // Get current admin user
  static User? get currentAdmin => _auth.currentUser;

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
        // Check if user is admin using the new async method
        final isAdminUser = await isAdmin;

        if (isAdminUser) {
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

      final allDocs = querySnapshot.docs;
      print('Debug: Total documents in users collection: ${allDocs.length}');

      for (var doc in allDocs) {
        final data = doc.data();
        final isAdmin = data['isAdmin'] == true;
        final email = data['email'] ?? 'No email';
        print('Debug: Document ${doc.id}: email=$email, isAdmin=$isAdmin');
      }

      final filteredDocs = allDocs.where((doc) {
        final data = doc.data();
        final isAdmin = data['isAdmin'] == true;

        // Filter out admin accounts (only by isAdmin flag)
        return !isAdmin;
      }).toList();

      print(
        'Debug: After filtering out admins: ${filteredDocs.length} regular users',
      );

      return filteredDocs.map((doc) {
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
          .collection('mood_entries')
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
          .collectionGroup('mood_entries')
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

  // Debug function to check assessments for a user
  static Future<void> debugUserAssessments(String userId) async {
    try {
      print('Debug: Checking assessments for user: $userId');

      // Check assessments collection
      final assessmentQuery = await _firestore
          .collection('users')
          .doc(userId)
          .collection('assessments')
          .get();

      print(
        'Debug: Found ${assessmentQuery.docs.length} assessments in assessments collection',
      );

      for (var doc in assessmentQuery.docs) {
        final data = doc.data();
        print(
          'Debug: Assessment ${doc.id}: score=${data['score']}, timestamp=${data['timestamp']}',
        );
      }

      // Check mood entries for assessment data
      final moodQuery = await _firestore
          .collection('users')
          .doc(userId)
          .collection('mood_entries')
          .get();

      int moodAssessments = 0;
      for (var doc in moodQuery.docs) {
        final data = doc.data();
        if (data['assessment_data'] != null) {
          moodAssessments++;
          print(
            'Debug: Mood entry ${doc.id} has assessment data: ${data['assessment_data']}',
          );
        }
      }

      print('Debug: Found $moodAssessments mood entries with assessment data');
    } catch (e) {
      print('Debug: Error checking assessments: $e');
    }
  }

  // Clear all user data from the database AND Firebase Auth
  static Future<bool> clearAllUserData() async {
    try {
      print('Debug: Starting to clear all user data...');

      // Get all users from Firestore
      final usersQuery = await _firestore.collection('users').get();
      print(
        'Debug: Found ${usersQuery.docs.length} users in Firestore to clear',
      );

      int totalDeleted = 0;

      for (var userDoc in usersQuery.docs) {
        final userId = userDoc.id;
        print('Debug: Clearing data for user: $userId');

        // Delete all subcollections for this user
        final subcollections = [
          'assessments',
          'mood_entries',
          'quick_mood_entries',
          'cravingSkills',
        ];

        for (String subcollection in subcollections) {
          final subQuery = await _firestore
              .collection('users')
              .doc(userId)
              .collection(subcollection)
              .get();

          print(
            'Debug: Found ${subQuery.docs.length} documents in $subcollection',
          );

          // Delete all documents in subcollection
          for (var doc in subQuery.docs) {
            await doc.reference.delete();
            totalDeleted++;
          }
        }

        // Delete the user document itself
        await userDoc.reference.delete();
        totalDeleted++;

        print('Debug: Cleared Firestore data for user: $userId');
      }

      // Clear Firebase Authentication users
      print('Debug: Clearing Firebase Authentication users...');
      try {
        // Note: Firebase Admin SDK is needed to delete users from Auth
        // For now, we'll just clear the Firestore data
        // The user will need to manually delete auth users from Firebase Console
        print(
          'Debug: Firestore data cleared. Please manually delete Firebase Auth users from Firebase Console.',
        );
      } catch (e) {
        print('Debug: Error clearing Firebase Auth users: $e');
      }

      print(
        'Debug: Successfully cleared all Firestore data. Total documents deleted: $totalDeleted',
      );
      return true;
    } catch (e) {
      print('Debug: Error clearing user data: $e');
      return false;
    }
  }

  // Clear Firebase Authentication users (requires Admin SDK)
  static Future<bool> clearAllAuthUsers() async {
    try {
      print(
        'Debug: This function requires Firebase Admin SDK to delete auth users.',
      );
      print(
        'Debug: Please use Firebase Console to delete authentication users manually.',
      );
      print(
        'Debug: Go to Firebase Console > Authentication > Users > Select All > Delete',
      );
      return false;
    } catch (e) {
      print('Debug: Error clearing auth users: $e');
      return false;
    }
  }

  // Clear data for a specific user
  static Future<bool> clearUserData(String userId) async {
    try {
      print('Debug: Starting to clear data for user: $userId');

      // Delete all subcollections for this user
      final subcollections = [
        'assessments',
        'mood_entries',
        'quick_mood_entries',
        'cravingSkills',
      ];

      int totalDeleted = 0;

      for (String subcollection in subcollections) {
        final subQuery = await _firestore
            .collection('users')
            .doc(userId)
            .collection(subcollection)
            .get();

        print(
          'Debug: Found ${subQuery.docs.length} documents in $subcollection',
        );

        // Delete all documents in subcollection
        for (var doc in subQuery.docs) {
          await doc.reference.delete();
          totalDeleted++;
        }
      }

      // Delete the user document itself
      await _firestore.collection('users').doc(userId).delete();
      totalDeleted++;

      print(
        'Debug: Successfully cleared data for user: $userId. Total documents deleted: $totalDeleted',
      );
      return true;
    } catch (e) {
      print('Debug: Error clearing user data for $userId: $e');
      return false;
    }
  }

  // Add admin account to admins collection
  static Future<bool> addAdminAccount({
    required String email,
    required String displayName,
    required String role,
  }) async {
    try {
      await _firestore.collection('admins').add({
        'email': email.toLowerCase().trim(),
        'displayName': displayName.trim(),
        'role': role.trim(),
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': _auth.currentUser?.uid ?? 'system',
      });
      return true;
    } catch (e) {
      print('Error adding admin account: $e');
      return false;
    }
  }

  // Remove admin account from admins collection
  static Future<bool> removeAdminAccount(String adminId) async {
    try {
      await _firestore.collection('admins').doc(adminId).update({
        'isActive': false,
        'deactivatedAt': FieldValue.serverTimestamp(),
        'deactivatedBy': _auth.currentUser?.uid ?? 'system',
      });
      return true;
    } catch (e) {
      print('Error removing admin account: $e');
      return false;
    }
  }

  // Get all admin accounts
  static Future<List<Map<String, dynamic>>> getAllAdminAccounts() async {
    try {
      final querySnapshot = await _firestore
          .collection('admins')
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'email': data['email'] ?? '',
          'displayName': data['displayName'] ?? '',
          'role': data['role'] ?? '',
          'createdAt': data['createdAt']?.toDate(),
        };
      }).toList();
    } catch (e) {
      print('Error getting admin accounts: $e');
      return [];
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
