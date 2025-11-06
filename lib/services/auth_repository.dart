// lib/services/auth_repository.dart (NOVO ARQUIVO)

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:redstone_notes_app/database/database_helper.dart';
import 'package:redstone_notes_app/models/user_model.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

// NOVO: Uma classe de exceção customizada para erros de auth
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthRepository {
  // O Repositório depende do DatabaseHelper, mas não é um ChangeNotifier
  final DatabaseHelper _db;
  AuthRepository(this._db);

  // Lógica de hash movida do AuthProvider para cá
  String _hashPassword(String password) {
    final bytes = utf8.encode(password); //
    final digest = sha256.convert(bytes); //
    return digest.toString(); //
  }

  // Lógica de login movida do AuthProvider para cá
  Future<AppUser> login(String email, String password) async {
    final userData = await _db.getUserForLogin(email); //
    
    if (userData == null) {
      throw AuthException("Usuário não encontrado."); //
    }

    final savedHash = userData['password_hash'] as String; //
    final inputHash = _hashPassword(password); //

    if (savedHash == inputHash) {
      return AppUser.fromMap(userData); //
    } else {
      throw AuthException("Senha incorreta."); //
    }
  }

  // Lógica de registro movida do AuthProvider para cá
  Future<AppUser> register({
    required String nome,
    required String email,
    required int idade,
    required String password,
  }) async {
    try {
      final id = uuid.v4(); //
      final hash = _hashPassword(password); //
      
      final newUser = await _db.createUser(id, nome, email, idade, hash); //
      return newUser;
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) { //
        throw AuthException("Este email já está em uso."); //
      }
      throw AuthException("Ocorreu um erro ao registrar."); //
    }
  }

  // NOVO: Método para buscar um usuário pelo ID (para a sessão)
  Future<AppUser?> getUserById(String id) async {
    return _db.getUserById(id);
  }
}