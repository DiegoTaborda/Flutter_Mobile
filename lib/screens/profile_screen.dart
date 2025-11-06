import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redstone_notes_app/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Pega o usuário logado (sem 'listen' pois não esperamos que mude aqui)
    final user = context.read<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
      ),
      body: user == null
          ? const Center(child: Text('Usuário não encontrado.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Nome'),
                    subtitle: Text(user.nome),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(user.email),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.cake),
                    title: const Text('Idade'),
                    subtitle: Text(user.idade.toString()),
                  ),
                ],
              ),
            ),
    );
  }
}