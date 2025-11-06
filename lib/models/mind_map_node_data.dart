import 'package:flutter/material.dart';

enum NodeShape { rectangle, circle, cloud, diamond }

class MindMapNodeData {
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'color': color.value, // Salvamos o valor inteiro da cor
      'shape': shape.name, // Salvamos o nome do enum como String
    };
  }

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