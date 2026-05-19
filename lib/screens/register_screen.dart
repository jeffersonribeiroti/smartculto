import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Nome')),
            TextField(
              decoration: const InputDecoration(labelText: 'Igreja'),
            ),
            TextField(decoration: const InputDecoration(labelText: 'E-mail')),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            TextField(
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Confirmar Senha'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}