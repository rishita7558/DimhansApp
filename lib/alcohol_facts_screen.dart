import 'package:flutter/material.dart';

class AlcoholFactsScreen extends StatelessWidget {
  const AlcoholFactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final facts = [
      'Alcohol is a depressant that affects the central nervous system.',
      'Drinking too much alcohol can damage the liver, heart, and brain.',
      'Alcohol use is linked to over 200 diseases and injury conditions.',
      'Binge drinking is defined as consuming 5 or more drinks (men), or 4 or more drinks (women) in about 2 hours.',
      'Alcohol can impair judgment, coordination, and reaction time.',
      'Underage drinking can interfere with brain development.',
      'Alcohol is a leading risk factor for death and disability worldwide.',
      'Mixing alcohol with medications can be dangerous.',
      'There is no safe level of alcohol use during pregnancy.',
      'Support and treatment are available for those struggling with alcohol use.',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Alcohol Facts Handout')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: facts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) => Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              facts[i],
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
} 