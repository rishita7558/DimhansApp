import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MigrateExistingUsers {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Migrate current logged-in user to Firestore
  static Future<void> migrateCurrentUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        print('Migrating current user: ${currentUser.email}');
        await _migrateUserToFirestore(currentUser);
      }
    } catch (e) {
      print('Error migrating current user: $e');
    }
  }

  // Migrate a user to Firestore
  static Future<void> _migrateUserToFirestore(User user) async {
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
        print('Successfully migrated user: ${user.email}');
      } else {
        print('User already exists in Firestore: ${user.email}');
        // Update last login time
        await _firestore.collection('users').doc(user.uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error migrating user ${user.email}: $e');
    }
  }

  // Force migrate all users (for testing)
  static Future<void> forceMigrateAllUsers() async {
    try {
      print('Starting force migration of all users...');

      // Get all users from Firebase Auth
      // Note: This requires admin SDK in production
      // For now, we'll migrate the current user
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _migrateUserToFirestore(currentUser);
      }

      print('Force migration completed');
    } catch (e) {
      print('Error during force migration: $e');
    }
  }
}
