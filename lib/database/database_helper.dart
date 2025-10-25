import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import '../ideia_model.dart';
import '../models/mind_map_node_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mind_map_notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Tabela para as ideias (notas principais)
    await db.execute('''
      CREATE TABLE ideias (
        id TEXT PRIMARY KEY,
        titulo TEXT NOT NULL,
        texto TEXT NOT NULL,
        dataCriacao TEXT NOT NULL,
        dataAtividade TEXT,
        isCompleta INTEGER NOT NULL,
        mindMapJson TEXT
      )
    ''');

    // Tabela para os nós do mapa mental
    await db.execute('''
      CREATE TABLE mind_map_nodes (
        id TEXT PRIMARY KEY,
        ideia_id TEXT NOT NULL,
        text TEXT NOT NULL,
        color INTEGER NOT NULL,
        shape TEXT NOT NULL,
        FOREIGN KEY (ideia_id) REFERENCES ideias (id) ON DELETE CASCADE
      )
    ''');

    // Tabela para as conexões entre nós
    await db.execute('''
      CREATE TABLE mind_map_edges (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ideia_id TEXT NOT NULL,
        source_node_id TEXT NOT NULL,
        target_node_id TEXT NOT NULL,
        FOREIGN KEY (ideia_id) REFERENCES ideias (id) ON DELETE CASCADE,
        FOREIGN KEY (source_node_id) REFERENCES mind_map_nodes (id) ON DELETE CASCADE,
        FOREIGN KEY (target_node_id) REFERENCES mind_map_nodes (id) ON DELETE CASCADE
      )
    ''');
  }

  // Métodos para Ideias
  Future<String> insertIdeia(Ideia ideia) async {
    final db = await database;
    await db.insert('ideias', {
      'id': ideia.id,
      'titulo': ideia.titulo,
      'texto': ideia.texto,
      'dataCriacao': ideia.dataCriacao.toIso8601String(),
      'dataAtividade': ideia.dataAtividade?.toIso8601String(),
      'isCompleta': ideia.isCompleta ? 1 : 0,
      'mindMapJson': ideia.mindMapJson,
    });
    return ideia.id;
  }

  Future<Ideia> getIdeia(String id) async {
    final db = await database;
    final maps = await db.query(
      'ideias',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Ideia.from(
        id: maps[0]['id'] as String,
        titulo: maps[0]['titulo'] as String,
        texto: maps[0]['texto'] as String,
        dataCriacao: DateTime.parse(maps[0]['dataCriacao'] as String),
        dataAtividade: maps[0]['dataAtividade'] == null
            ? null
            : DateTime.parse(maps[0]['dataAtividade'] as String),
        isCompleta: (maps[0]['isCompleta'] as int) == 1,
        mindMapJson: maps[0]['mindMapJson'] as String?,
      );
    }

    throw Exception('ID $id not found');
  }

  Future<List<Ideia>> getAllIdeias() async {
    final db = await database;
    final result = await db.query('ideias', orderBy: 'dataCriacao DESC');

    return result.map((json) => Ideia.from(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      texto: json['texto'] as String,
      dataCriacao: DateTime.parse(json['dataCriacao'] as String),
      dataAtividade: json['dataAtividade'] == null
          ? null
          : DateTime.parse(json['dataAtividade'] as String),
      isCompleta: (json['isCompleta'] as int) == 1,
      mindMapJson: json['mindMapJson'] as String?,
    )).toList();
  }

  Future<int> updateIdeia(Ideia ideia) async {
    final db = await database;
    return db.update(
      'ideias',
      {
        'titulo': ideia.titulo,
        'texto': ideia.texto,
        'dataAtividade': ideia.dataAtividade?.toIso8601String(),
        'isCompleta': ideia.isCompleta ? 1 : 0,
        'mindMapJson': ideia.mindMapJson,
      },
      where: 'id = ?',
      whereArgs: [ideia.id],
    );
  }

  Future<int> deleteIdeia(String id) async {
    final db = await database;
    return await db.delete(
      'ideias',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para nós do mapa mental
  Future<void> insertMindMapNode(String ideiaId, MindMapNodeData node) async {
    final db = await database;
    await db.insert('mind_map_nodes', {
      'id': node.id,
      'ideia_id': ideiaId,
      'text': node.text,
      'color': node.color.value,
      'shape': node.shape.name,
    });
  }

  Future<List<MindMapNodeData>> getMindMapNodes(String ideiaId) async {
    final db = await database;
    final result = await db.query(
      'mind_map_nodes',
      where: 'ideia_id = ?',
      whereArgs: [ideiaId],
    );

    return result.map((json) => MindMapNodeData(
      id: json['id'] as String,
      text: json['text'] as String,
      color: Color(json['color'] as int),
      shape: NodeShape.values.firstWhere(
        (e) => e.name == json['shape'],
        orElse: () => NodeShape.rectangle,
      ),
    )).toList();
  }

  // Métodos para conexões do mapa mental
  Future<void> insertMindMapEdge(
    String ideiaId,
    String sourceNodeId,
    String targetNodeId,
  ) async {
    final db = await database;
    await db.insert('mind_map_edges', {
      'ideia_id': ideiaId,
      'source_node_id': sourceNodeId,
      'target_node_id': targetNodeId,
    });
  }

  Future<List<Map<String, String>>> getMindMapEdges(String ideiaId) async {
    final db = await database;
    final result = await db.query(
      'mind_map_edges',
      where: 'ideia_id = ?',
      whereArgs: [ideiaId],
    );

    return result.map((json) => {
      'source': json['source_node_id'] as String,
      'target': json['target_node_id'] as String,
    }).toList();
  }

  // Método para fechar o banco de dados
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}