import 'package:flutter/material.dart';
import '../models/culto.dart';

class AddCultoScreen extends StatefulWidget {
  const AddCultoScreen({super.key});

  @override
  State<AddCultoScreen> createState() => _AddCultoScreenState();
}

class _AddCultoScreenState extends State<AddCultoScreen> {
  final TextEditingController _nomeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );

    if (data != null) {
      setState(() {
        _selectedDate = data;
      });
    }
  }

  Future<void> _selecionarHora() async {
    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (hora != null) {
      setState(() {
        _selectedTime = hora;
      });
    }
  }

  void _salvarCulto() {
    if (_nomeController.text.trim().isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos.'),
        ),
      );
      return;
    }

    final String dataFormatada =
        '${_selectedDate!.day.toString().padLeft(2, '0')}/'
        '${_selectedDate!.month.toString().padLeft(2, '0')}/'
        '${_selectedDate!.year}';

    final String horaFormatada =
        '${_selectedTime!.hour.toString().padLeft(2, '0')}:'
        '${_selectedTime!.minute.toString().padLeft(2, '0')}';

    final culto = Culto(
      nome: _nomeController.text.trim(),
      data: dataFormatada,
      hora: horaFormatada,
    );

    Navigator.pop(context, culto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Culto'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome do Culto',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.church),
              ),
            ),
            const SizedBox(height: 20),

            // Seleção de Data
            InkWell(
              onTap: _selecionarData,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 12),
                    Text(
                      _selectedDate == null
                          ? 'Selecionar Data'
                          : '${_selectedDate!.day.toString().padLeft(2, '0')}/'
                            '${_selectedDate!.month.toString().padLeft(2, '0')}/'
                            '${_selectedDate!.year}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Seleção de Hora
            InkWell(
              onTap: _selecionarHora,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 12),
                    Text(
                      _selectedTime == null
                          ? 'Selecionar Hora'
                          : _selectedTime!.format(context),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _salvarCulto,
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}