import 'package:flutter/material.dart';

class VisitantesScreen extends StatelessWidget {
  const VisitantesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visitantes')),
      body: const Center(
        child: Text('Não há visitantes cadastrados para este culto.'),
      ),
    );
  }
}