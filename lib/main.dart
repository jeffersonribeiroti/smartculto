import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
void main() {
  runApp(const SmartCultoApp());
}
class SmartCultoApp extends StatelessWidget {
  const SmartCultoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartCulto',
      theme: ThemeData(
        fontFamily: 'Inter',
        primaryColor: const Color(0xFF0D47A1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
          primary: const Color(0xFF0D47A1),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
