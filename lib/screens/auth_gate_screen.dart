import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redstone_notes_app/providers/auth_provider.dart';
import 'package:redstone_notes_app/screens/home_screen.dart';
import 'package:redstone_notes_app/screens/login_screen.dart';
import 'package:redstone_notes_app/screens/register_screen.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    switch (authProvider.status) {
      case AuthStatus.unknown:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthStatus.authenticated:
        return const HomeScreen();
      case AuthStatus.unauthenticated:
        return const LoginOrRegisterScreen();
    }
  }
}


class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
  bool _showLoginPage = true;

  void toggleScreens() {
    setState(() {
      _showLoginPage = !_showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLoginPage) {
      return LoginScreen(onTapRegister: toggleScreens);
    } else {
      return RegisterScreen(onTapLogin: toggleScreens);
    }
  }
}