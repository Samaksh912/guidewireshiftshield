import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/onboarding_screens.dart';

void main() {
  runApp(const ShiftShieldApp());
}

class ShiftShieldApp extends StatelessWidget {
  const ShiftShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShiftShield',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}