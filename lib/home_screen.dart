import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onStartAssessment;
  final VoidCallback onLearn;
  const HomeScreen({super.key, required this.onStartAssessment, required this.onLearn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(60),
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              print('DEBUG: Start Self-Assessment button tapped');
              onStartAssessment();
            },
            child: const Text('Start Self-Assessment'),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(60),
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              backgroundColor: Colors.green,
            ),
            onPressed: onLearn,
            child: const Text('Learn About Alcohol Addiction'),
          ),
        ],
      ),
    );
  }
} 