import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

      // Localizações
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],

      locale: const Locale('pt', 'BR'),

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),

      home: const LoginScreen(),
    );
  }
}