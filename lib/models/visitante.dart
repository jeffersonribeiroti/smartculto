class Visitante {
  final String nome;
  final bool evangelico;
  final String congregacao;
  final String denominacao;
  final String observacoes;

  Visitante({
    required this.nome,
    required this.evangelico,
    this.congregacao = '',
    this.denominacao = '',
    this.observacoes = '',
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'evangelico': evangelico,
        'congregacao': congregacao,
        'denominacao': denominacao,
        'observacoes': observacoes,
      };

  factory Visitante.fromJson(Map<String, dynamic> json) {
    return Visitante(
      nome: json['nome'] ?? '',
      evangelico: json['evangelico'] ?? false,
      congregacao: json['congregacao'] ?? '',
      denominacao: json['denominacao'] ?? '',
      observacoes: json['observacoes'] ?? '',
    );
  }
}