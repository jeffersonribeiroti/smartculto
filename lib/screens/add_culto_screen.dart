import 'package:flutter/material.dart';
import '../models/culto.dart';

class AddCultoScreen extends StatefulWidget {
  const AddCultoScreen({super.key});

  @override
  State<AddCultoScreen> createState() => _AddCultoScreenState();
}

class _AddCultoScreenState extends State<AddCultoScreen> {
  static const List<String> _tiposCulto = [
    'Culto de Celebração',
    'Culto de Jovens',
    'Culto da Família',
    'Culto de Oração',
    'Culto de Evangelismo',
    'Culto de Crianças',
    'Culto de Doutrina',
    'Outro',
  ];

  String? _tipoSelecionado;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selecionarData() async {
    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );
    if (data != null) {
      setState(() => _selectedDate = data);
    }
  }

  Future<void> _selecionarHora() async {
    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null) {
      setState(() => _selectedTime = hora);
    }
  }

  void _salvarCulto() {
    if (_tipoSelecionado == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos.'),
          backgroundColor: Colors.red,
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
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tipo: _tipoSelecionado!,
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
            // Dropdown Tipo de Culto
            DropdownButtonFormField<String>(
              value: _tipoSelecionado,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Tipo de Culto',
                prefixIcon: const Icon(Icons.church),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              hint: const Text('Selecione o tipo'),
              items: _tiposCulto.map((tipo) {
                return DropdownMenuItem<String>(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _tipoSelecionado = value);
              },
            ),

            const SizedBox(height: 20),

            // Seleção de Data
            InkWell(
              onTap: _selecionarData,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Color(0xFF0D47A1)),
                    const SizedBox(width: 12),
                    Text(
                      _selectedDate == null
                          ? 'Selecionar Data'
                          : '${_selectedDate!.day.toString().padLeft(2, '0')}/'
                              '${_selectedDate!.month.toString().padLeft(2, '0')}/'
                              '${_selectedDate!.year}',
                      style: TextStyle(
                        color: _selectedDate == null
                            ? Colors.grey[600]
                            : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Seleção de Hora
            InkWell(
              onTap: _selecionarHora,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Color(0xFF0D47A1)),
                    const SizedBox(width: 12),
                    Text(
                      _selectedTime == null
                          ? 'Selecionar Hora'
                          : _selectedTime!.format(context),
                      style: TextStyle(
                        color: _selectedTime == null
                            ? Colors.grey[600]
                            : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _salvarCulto,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Culto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
