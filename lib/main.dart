import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'home_screen.dart';
import 'learn_screen.dart';
import 'help_screen.dart';
import 'craving_skills_screen.dart';
import 'community_screen.dart';
import 'assessment_screen.dart';
import 'about_screen.dart';
import 'auth_wrapper.dart';
import 'mood_history_screen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Add error handling for Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      print('Flutter Error: ${details.exception}');
      print('Stack trace: ${details.stack}');
    };
    
    print('Starting Firebase initialization...');
    
    // Temporarily disabled Firebase for testing
    // try {
    //   // Initialize Firebase with configuration from firebase_options.dart
    //   await Firebase.initializeApp(
    //     options: DefaultFirebaseOptions.currentPlatform,
    //   );
    //   print('Firebase initialized successfully');
    // } catch (e) {
    //   print('Firebase initialization failed: $e');
    //   print('This might be due to missing configuration or network issues');
    //   
    //   // Try to initialize without options (will use default config if available)
    //   try {
    //     await Firebase.initializeApp();
    //     print('Firebase initialized with default configuration');
    //   } catch (e2) {
    //     print('Firebase initialization with default config also failed: $e2');
    //     print('App will continue without Firebase - authentication will not work');
    //   }
    // }
    print('Firebase temporarily disabled for testing');
    
    print('Starting app...');
    runApp(const DimhansApp());
  } catch (e, stackTrace) {
    print('Critical error in main: $e');
    print('Stack trace: $stackTrace');
    
    // Try to run a minimal app if the main one fails
    try {
      runApp(MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.red[100],
          appBar: AppBar(
            title: const Text('Critical Error'),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 100,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Critical Error Occurred',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: $e',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Please check your Firebase configuration and try again.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ));
    } catch (e2) {
      print('Even the error screen failed: $e2');
    }
  }
}

class DimhansApp extends StatelessWidget {
  const DimhansApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('DimhansApp build called');
    try {
      return MaterialApp(
        title: 'DIMHANS Alcohol Support',
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue[800],
          scaffoldBackgroundColor: const Color(0xFFF3EFFF),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        home: const AuthWrapper(),
      );
    } catch (e, stackTrace) {
      print('Error in DimhansApp build: $e');
      print('Stack trace: $stackTrace');
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.red[200],
          appBar: AppBar(
            title: const Text('App Build Error'),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 100,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                const Text(
                  'App Build Error',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: $e',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _showAssessment(BuildContext context) async {
    print('DEBUG: _showAssessment called, navigating to AssessmentScreen');
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AssessmentScreen()),
    );
    setState(() {
      _selectedIndex = 0; // Return to Home after assessment
    });
  }

  Future<void> _logout() async {
    try {
      // Try Firebase logout if available
      try {
        await FirebaseAuth.instance.signOut();
        print('Firebase logout successful');
      } catch (e) {
        print('Firebase logout failed (not available): $e');
      }
      
      // Clear stored preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
        );
      }
    } catch (e) {
      // Handle logout error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error logging out'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int learnTabIndex = 0;
    final screens = <Widget>[
      HomeScreen(
        onStartAssessment: () => _showAssessment(context),
        onLearnPublic: () => setState(() { _selectedIndex = 1; learnTabIndex = 0; }),
        onLearnStudents: () => setState(() { _selectedIndex = 1; learnTabIndex = 1; }),
      ),
      LearnScreen(initialTabIndex: learnTabIndex),
      const HelpScreen(),
      const CravingSkillsScreen(),
      const MoodHistoryScreen(),
      CommunityScreen(),
      AboutScreen(),
    ];
    return Scaffold(
      appBar: _selectedIndex == 0 ? null : AppBar(
        title: Text(
          [
            'Home',
            'Learn',
            'Help',
            'Craving Management Skills',
            'Mood History',
            'Community',
            'About',
          ][_selectedIndex],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.blue[800]),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() { _selectedIndex = index; }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Help'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Craving Skills'),
          BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Mood History'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'About'),
        ],
      ),
    );
  }
}
