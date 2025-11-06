import 'package:flutter/material.dart';
import 'package:redstone_notes_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redstone_notes_app/services/auth_repository.dart'; 

enum AuthStatus { unknown, authenticated, unauthenticated } //

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AppUser? _currentUser; //
  AuthStatus _status = AuthStatus.unknown; //

  AppUser? get currentUser => _currentUser;
  AuthStatus get status => _status;

  static const String _sessionKey = 'authUserId';

  AuthProvider(this._authRepository) {
    _tryAutoLogin();
  }

  Future<void> _tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_sessionKey);

    if (userId == null) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }

    try {
      final user = await _authRepository.getUserById(userId);
      if (user != null) {
        _currentUser = user;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
        await prefs.remove(_sessionKey);
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<String?> login(String email, String password, bool keepLoggedIn) async {
    try {
      final user = await _authRepository.login(email, password);
      
      _currentUser = user;
      _status = AuthStatus.authenticated;
      notifyListeners();


      if (keepLoggedIn) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_sessionKey, user.id);
      }
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Ocorreu um erro inesperado.";
    }
  }

  Future<String?> register({
    required String nome,
    required String email,
    required int idade,
    required String password,
  }) async {
    try {
      final user = await _authRepository.register(
        nome: nome,
        email: email,
        idade: idade,
        password: password,
      );
      
      _currentUser = user;
      _status = AuthStatus.authenticated;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionKey, user.id);

      return null; // Sucesso
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Ocorreu um erro inesperado.";
    }
  }

  void logout() async {
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    
    notifyListeners(); //
  }
}