import 'package:flutter/material.dart';

class AddVisitanteScreen extends StatefulWidget {
  AddVisitanteScreen({super.key});

  @override
  State<AddVisitanteScreen> createState() => _AddVisitanteScreenState();
}

class _AddVisitanteScreenState extends State<AddVisitanteScreen> {
  bool cristao = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Visitante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nome do Visitante',
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('É cristão?'),
              value: cristao,
              onChanged: (value) {
                setState(() {
                  cristao = value;
                });
              },
            ),
            if (cristao) ...[
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Congregação',
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Denominação',
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Setor',
                ),
              ),
            ],
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Observações',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
