class Culto {
  final String nome;
  final String data;
  final String hora;

  Culto({
    required this.nome,
    required this.data,
    required this.hora,
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'data': data,
        'hora': hora,
      };

  factory Culto.fromJson(Map<String, dynamic> json) {
    return Culto(
      nome: json['nome'],
      data: json['data'],
      hora: json['hora'],
    );
  }
}