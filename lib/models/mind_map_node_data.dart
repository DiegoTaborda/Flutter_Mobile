import 'package:flutter/material.dart';

enum NodeShape { rectangle, circle, cloud, diamond }

class MindMapNodeData {
  final String id;
  String text;
  Color color;
  NodeShape shape;
  IconData? icon;

  MindMapNodeData({
    required this.id,
    required this.text,
    this.color = Colors.blue,
    this.shape = NodeShape.rectangle,
    this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'color': color.value,
      'shape': shape.name,
      'icon': icon != null ? {
        'codePoint': icon!.codePoint,
        'fontFamily': icon!.fontFamily,
        'fontPackage': icon!.fontPackage,
      } : null,
    };
  }

  factory MindMapNodeData.fromJson(Map<String, dynamic> json) {
    IconData? icon;
    if (json['icon'] != null) {
      final iconData = json['icon'] as Map<String, dynamic>;
      icon = IconData(
        iconData['codePoint'] as int,
        fontFamily: iconData['fontFamily'] as String?,
        fontPackage: iconData['fontPackage'] as String?,
      );
    }

    return MindMapNodeData(
      id: json['id'],
      text: json['text'],
      color: Color(json['color']),
      shape: NodeShape.values.firstWhere(
        (e) => e.name == json['shape'],
        orElse: () => NodeShape.rectangle,
      ),
      icon: icon,
    );
  }
}
