import 'package:flutter/material.dart';
import '../models/culto.dart';
import '../models/visitante.dart';
import '../services/storage_service.dart';
import 'add_visitante_screen.dart';
import 'visitantes_screen.dart';

class CultoDetailsScreen extends StatefulWidget {
  final Culto culto;
  final String userRole;
  final List<Culto> todosCultos;

  const CultoDetailsScreen({
    super.key,
    required this.culto,
    required this.userRole,
    required this.todosCultos,
  });

  @override
  State<CultoDetailsScreen> createState() => _CultoDetailsScreenState();
}

class _CultoDetailsScreenState extends State<CultoDetailsScreen> {
  late Culto _culto;

  @override
  void initState() {
    super.initState();
    _culto = widget.culto;
  }

  Future<void> _adicionarVisitante() async {
    final Visitante? novoVisitante = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddVisitanteScreen(),
      ),
    );

    if (novoVisitante != null) {
      setState(() {
        _culto.visitantes.add(novoVisitante);
      });

      // Persiste a lista atualizada
      final index = widget.todosCultos.indexWhere((c) => c.id == _culto.id);
      if (index != -1) {
        widget.todosCultos[index] = _culto;
      }
      await StorageService.saveCultos(widget.todosCultos);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${novoVisitante.nome} adicionado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.userRole == 'admin';
    final totalVisitantes = _culto.visitantes.length;
    final totalEvangelicos =
        _culto.visitantes.where((v) => v.evangelico).length;
    final totalNaoEvangelicos = totalVisitantes - totalEvangelicos;

    return Scaffold(
      appBar: AppBar(
        title: Text(_culto.tipo),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card principal do culto
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.church,
                      size: 48,
                      color: Color(0xFF0D47A1),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _culto.tipo,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(_culto.data,
                            style: const TextStyle(fontSize: 15)),
                        const SizedBox(width: 16),
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(_culto.hora,
                            style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Resumo de visitantes
            Row(
              children: [
                _buildStatCard(
                  label: 'Total',
                  value: totalVisitantes.toString(),
                  icon: Icons.people,
                  color: const Color(0xFF0D47A1),
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  label: 'Evangélicos',
                  value: totalEvangelicos.toString(),
                  icon: Icons.church,
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  label: 'Não evang.',
                  value: totalNaoEvangelicos.toString(),
                  icon: Icons.person_outline,
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Botão Ver Visitantes
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.people),
                label: const Text('Ver Visitantes'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VisitantesScreen(
                        visitantes: _culto.visitantes,
                        cultoNome: _culto.tipo,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Botão Adicionar Visitante — apenas para Recepcionista (RF 8)
            if (!isAdmin)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.person_add),
                  label: const Text('Adicionar Visitante'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0D47A1),
                    side: const BorderSide(color: Color(0xFF0D47A1)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _adicionarVisitante,
                ),
              ),

            // Mensagem para admin
            if (isAdmin) ...[
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Perfil ADM — somente visualização',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
