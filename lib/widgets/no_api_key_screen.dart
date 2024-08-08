import 'package:flutter/material.dart';

class NoApiKeyFoundScreen extends StatelessWidget {
  const NoApiKeyFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text(
            'No API Key found, please follow readme.md file instructions to setup correctly.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
