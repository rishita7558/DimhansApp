import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserMigration {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Migrate existing Firebase Auth users to Firestore
  static Future<void> migrateExistingUsers() async {
    try {
      print('Starting user migration...');

      // Get all users from Firebase Auth (this requires admin SDK in production)
      // For now, we'll create a simple migration for current user
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await migrateUser(currentUser);
      }

      print('User migration completed');
    } catch (e) {
      print('Error during user migration: $e');
    }
  }

  // Migrate a single user to Firestore (now public)
  static Future<void> migrateUser(User user) async {
    try {
      // Check if user already exists in Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // Create user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email ?? '',
          'displayName': user.displayName ?? 'User',
          'isAdmin': false,
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
        print('Migrated user: ${user.email}');
      } else {
        print('User already exists in Firestore: ${user.email}');
      }
    } catch (e) {
      print('Error migrating user ${user.email}: $e');
    }
  }

  // Create a test user for demonstration
  static Future<void> createTestUsers() async {
    try {
      // Create some test users for demonstration
      final testUsers = [
        {
          'email': 'user1@test.com',
          'displayName': 'Test User 1',
          'isAdmin': false,
        },
        {
          'email': 'user2@test.com',
          'displayName': 'Test User 2',
          'isAdmin': false,
        },
        {
          'email': 'user3@test.com',
          'displayName': 'Test User 3',
          'isAdmin': false,
        },
      ];

      for (final userData in testUsers) {
        await _firestore.collection('users').add({
          'email': userData['email'],
          'displayName': userData['displayName'],
          'isAdmin': userData['isAdmin'],
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
        print('Created test user: ${userData['email']}');
      }
    } catch (e) {
      print('Error creating test users: $e');
    }
  }
}
