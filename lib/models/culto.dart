import 'visitante.dart';

class Culto {
  final String id;
  final String tipo;
  final String data;
  final String hora;
  List<Visitante> visitantes;

  Culto({
    required this.id,
    required this.tipo,
    required this.data,
    required this.hora,
    List<Visitante>? visitantes,
  }) : visitantes = visitantes ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'tipo': tipo,
        'data': data,
        'hora': hora,
        'visitantes': visitantes.map((v) => v.toJson()).toList(),
      };

  factory Culto.fromJson(Map<String, dynamic> json) {
    return Culto(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      tipo: json['tipo'] ?? json['nome'] ?? '',
      data: json['data'] ?? '',
      hora: json['hora'] ?? '',
      visitantes: (json['visitantes'] as List<dynamic>?)
              ?.map((v) => Visitante.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Mantido para compatibilidade com código legado que usa culto.nome
  String get nome => tipo;
}