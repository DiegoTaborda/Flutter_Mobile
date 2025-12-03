import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import '../models/ideia_model.dart';
import '../models/mind_map_node_data.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mind_map_notes_v2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createDB(db, newVersion);
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('DROP TABLE IF EXISTS mind_map_edges');
    await db.execute('DROP TABLE IF EXISTS mind_map_nodes');
    await db.execute('DROP TABLE IF EXISTS ideias');
    await db.execute('DROP TABLE IF EXISTS users');

    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        idade INTEGER NOT NULL,
        password_hash TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ideias (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL, 
        titulo TEXT NOT NULL,
        texto TEXT NOT NULL,
        dataCriacao TEXT NOT NULL,
        dataAtividade TEXT,
        isCompleta INTEGER NOT NULL,
        mindMapJson TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

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

  Future<AppUser> createUser(String id, String nome, String email, int idade, String passwordHash) async {
    final db = await database;
    await db.insert('users', {
      'id': id,
      'nome': nome,
      'email': email,
      'idade': idade,
      'password_hash': passwordHash,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    
    return AppUser(id: id, nome: nome, email: email, idade: idade);
  }

  Future<Map<String, dynamic>?> getUserForLogin(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<AppUser?> getUserById(String id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return AppUser.fromMap(maps.first);
    }
    return null;
  }

  Future<String> insertIdeia(Ideia ideia, String userId) async {
    final db = await database;
    await db.insert('ideias', {
      'id': ideia.id,
      'user_id': userId,
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

  Future<List<Ideia>> getAllIdeias(String userId) async {
    final db = await database;
    final result = await db.query(
      'ideias',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'dataCriacao DESC',
    );

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

  Future<int> updateIdeia(Ideia ideia, String userId) async {
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
      where: 'id = ? AND user_id = ?',
      whereArgs: [ideia.id, userId],
    );
  }

  Future<int> deleteIdeia(String ideiaId, String userId) async {
    final db = await database;
    return await db.delete(
      'ideias',
      where: 'id = ? AND user_id = ?',
      whereArgs: [ideiaId, userId],
    );
  }

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

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
