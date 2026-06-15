import 'package:flutter/material.dart';
import '../models/visitante.dart';

class VisitantesScreen extends StatelessWidget {
  final List<Visitante> visitantes;
  final String cultoNome;

  const VisitantesScreen({
    super.key,
    required this.visitantes,
    required this.cultoNome,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitantes'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Cabeçalho com nome do culto e total
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF0D47A1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cultoNome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${visitantes.length} visitante${visitantes.length != 1 ? 's' : ''} registrado${visitantes.length != 1 ? 's' : ''}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // Lista de visitantes
          Expanded(
            child: visitantes.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum visitante cadastrado\npara este culto.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: visitantes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final v = visitantes[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar com ícone diferenciado
                              CircleAvatar(
                                backgroundColor: v.evangelico
                                    ? const Color(0xFF0D47A1)
                                    : Colors.orange,
                                child: Icon(
                                  v.evangelico
                                      ? Icons.church
                                      : Icons.person_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      v.nome,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Badge Evangélico / Não Evangélico
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: v.evangelico
                                            ? const Color(0xFFE3F2FD)
                                            : const Color(0xFFFFF3E0),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        v.evangelico
                                            ? 'Evangélico'
                                            : 'Não evangélico',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: v.evangelico
                                              ? const Color(0xFF0D47A1)
                                              : Colors.orange[800],
                                        ),
                                      ),
                                    ),
                                    // Congregação e Denominação (se evangélico)
                                    if (v.evangelico &&
                                        v.congregacao.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_city,
                                              size: 14, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              v.congregacao,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black87),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (v.evangelico &&
                                        v.denominacao.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          const Icon(Icons.account_balance,
                                              size: 14, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              v.denominacao,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black87),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    // Observações
                                    if (v.observacoes.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        v.observacoes,
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              // Número do visitante
                              Text(
                                '#${index + 1}',
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}