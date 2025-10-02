// lib/models/mind_map_node_data.dart

import 'package:flutter/material.dart';

enum NodeShape { rectangle, circle, cloud, diamond }

class MindMapNodeData {
  // ADICIONADO: Um ID único e final para cada nó de dados.
  final String id;
  String text;
  Color color;
  NodeShape shape;

  MindMapNodeData({
    required this.id, // O ID agora é obrigatório
    required this.text,
    this.color = Colors.blue,
    this.shape = NodeShape.rectangle,
  });

  // NOVO: Método para converter o objeto em um Map (para JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'color': color.value, // Salvamos o valor inteiro da cor
      'shape': shape.name, // Salvamos o nome do enum como String
    };
  }

  // NOVO: Método para criar um objeto a partir de um Map (vindo do JSON)
  factory MindMapNodeData.fromJson(Map<String, dynamic> json) {
    return MindMapNodeData(
      id: json['id'],
      text: json['text'],
      color: Color(json['color']),
      shape: NodeShape.values.firstWhere(
        (e) => e.name == json['shape'],
        orElse: () => NodeShape.rectangle,
      ),
    );
  }
}