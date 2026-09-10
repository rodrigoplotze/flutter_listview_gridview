class Task {
  final int id;
  final String titulo;
  final String descricao;
  final bool concluida;
  final DateTime criadaEm;

  const Task({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.concluida,
    required this.criadaEm,
  });

  Task copyWith({
    int? id,
    String? titulo,
    String? descricao,
    bool? concluida,
    DateTime? criadaEm,
  }) {
    return Task(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      concluida: concluida ?? this.concluida,
      criadaEm: criadaEm ?? this.criadaEm,
    );
  }
}