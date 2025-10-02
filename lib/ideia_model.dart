// lib/ideia_model.dart

import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class Ideia {
  final String id;
  String titulo;
  String texto;
  final DateTime dataCriacao;
  final DateTime? dataAtividade;
  bool isCompleta;
  // NOVO: Campo para guardar o JSON do mapa mental
  String? mindMapJson;

  Ideia({
    required this.titulo,
    required this.texto,
    this.dataAtividade,
    this.isCompleta = false,
    this.mindMapJson, // Adicionado ao construtor
  })  : id = uuid.v4(),
        dataCriacao = DateTime.now();

  Ideia.from({
    required this.id,
    required this.dataCriacao,
    required this.titulo,
    required this.texto,
    this.dataAtividade,
    required this.isCompleta,
    this.mindMapJson, // Adicionado ao construtor
  });

  Ideia copyWith({
    String? titulo,
    String? texto,
    DateTime? dataAtividade,
    bool? isCompleta,
    String? mindMapJson, // Adicionado ao copyWith
  }) {
    return Ideia.from(
      id: this.id,
      dataCriacao: this.dataCriacao,
      titulo: titulo ?? this.titulo,
      texto: texto ?? this.texto,
      dataAtividade: dataAtividade ?? this.dataAtividade,
      isCompleta: isCompleta ?? this.isCompleta,
      mindMapJson: mindMapJson ?? this.mindMapJson, // Adicionado ao copyWith
    );
  }
}