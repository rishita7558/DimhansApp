import 'package:flutter/material.dart';
// TODO: Import Firebase core and initialize Firebase
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'home_screen.dart';
import 'learn_screen.dart';
import 'help_screen.dart';
import 'craving_skills_screen.dart';
import 'community_screen.dart';
import 'assessment_screen.dart';
import 'about_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Initialize Firebase here
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const DimhansApp());
}

class DimhansApp extends StatelessWidget {
  const DimhansApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DIMHANS Alcohol Support',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue[800],
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: Colors.blue[800]!,
          secondary: Colors.green[600]!,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue[800],
          elevation: 1,
          titleTextStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          iconTheme: IconThemeData(color: Colors.blue[800]),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue[800],
            side: BorderSide(color: Colors.blue[800]!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[100]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[800]!),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(fontSize: 16),
          titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFE0E0E0),
          thickness: 1,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Replace with your app logo
            Icon(Icons.local_hospital, size: 100, color: Colors.blue[800]),
            const SizedBox(height: 24),
            const Text(
              'Your Support Against Alcohol Addiction',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(
        onStartAssessment: () => _showAssessment(context),
        onLearn: () => setState(() => _selectedIndex = 1),
      ),
      LearnScreen(),
      HelpScreen(),
      CravingSkillsScreen(),
      CommunityScreen(),
      AboutScreen(), // Added AboutScreen
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          [
            'Home',
            'Learn',
            'Help',
            'Craving Management Skills',
            'Community',
            'About', // Added About
          ][_selectedIndex],
        ),
        centerTitle: true,
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Help'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Craving Skills'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'About'), // Added About
        ],
      ),
    );
  }
}
