import 'package:flutter/material.dart';

enum NodeShape { rectangle, circle, cloud, diamond }

class MindMapNodeData {
  final String id;
  String text;
  Color color;
  NodeShape shape;
  String? imagePath;

  MindMapNodeData({
    required this.id,
    required this.text,
    this.color = Colors.blue,
    this.shape = NodeShape.rectangle,
    this.imagePath,
  });

  MindMapNodeData copyWith({
    String? id,
    String? text,
    Color? color,
    NodeShape? shape,
    String? imagePath,
  }) {
    return MindMapNodeData(
      id: id ?? this.id,
      text: text ?? this.text,
      color: color ?? this.color,
      shape: shape ?? this.shape,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'color': color.value,
      'shape': shape.name,
      'imagePath': imagePath,
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
      imagePath: json['imagePath'],
    );
  }
}