import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: const Center(
        child: Text(
          'Versão 1.0.1',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
