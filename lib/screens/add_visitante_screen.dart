import 'package:flutter/material.dart';
import '../models/visitante.dart';

class AddVisitanteScreen extends StatefulWidget {
  const AddVisitanteScreen({super.key});

  @override
  State<AddVisitanteScreen> createState() => _AddVisitanteScreenState();
}

class _AddVisitanteScreenState extends State<AddVisitanteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _congregacaoController = TextEditingController();
  final _denominacaoController = TextEditingController();
  final _observacoesController = TextEditingController();
  bool _evangelico = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _congregacaoController.dispose();
    _denominacaoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final visitante = Visitante(
      nome: _nomeController.text.trim(),
      evangelico: _evangelico,
      congregacao: _evangelico ? _congregacaoController.text.trim() : '',
      denominacao: _evangelico ? _denominacaoController.text.trim() : '',
      observacoes: _observacoesController.text.trim(),
    );

    Navigator.pop(context, visitante);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Visitante'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Nome
                TextFormField(
                  controller: _nomeController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Visitante',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o nome do visitante';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Toggle Evangélico
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
                    title: const Text(
                      'É evangélico?',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      _evangelico ? 'Sim — preencha os dados abaixo' : 'Não evangélico',
                      style: TextStyle(
                        color: _evangelico
                            ? const Color(0xFF0D47A1)
                            : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    value: _evangelico,
                    activeColor: const Color(0xFF0D47A1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _evangelico = value;
                        if (!value) {
                          _congregacaoController.clear();
                          _denominacaoController.clear();
                        }
                      });
                    },
                  ),
                ),

                // Campos condicionais de evangélico
                if (_evangelico) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _congregacaoController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Congregação',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    validator: (value) {
                      if (_evangelico &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Informe a congregação';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _denominacaoController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Denominação',
                      prefixIcon: Icon(Icons.account_balance),
                    ),
                    validator: (value) {
                      if (_evangelico &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Informe a denominação';
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 16),

                // Observações
                TextFormField(
                  controller: _observacoesController,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Observações (opcional)',
                    prefixIcon: Icon(Icons.notes),
                    alignLabelWithHint: true,
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _salvar,
                    icon: const Icon(Icons.person_add),
                    label: const Text('Adicionar Visitante'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
