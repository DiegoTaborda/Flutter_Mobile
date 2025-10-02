import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
      ),
      body: const Center(
        child: Text(
          'Tela do Perfil.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}