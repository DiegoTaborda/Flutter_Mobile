// lib/screens/menu_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redstone_notes_app/providers/auth_provider.dart'; // IMPORTAR
import 'package:redstone_notes_app/theme_provider.dart';
import 'package:redstone_notes_app/screens/profile_screen.dart';
import 'package:redstone_notes_app/screens/settings_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    // ATUALIZADO: Pega o usuário logado
    // Usamos 'watch' aqui para que, se o usuário mudar, a UI atualize
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: ListView(
        children: [
          // ATUALIZADO: Mostra dados do usuário
          if (user != null)
            UserAccountsDrawerHeader(
              accountName: Text(user.nome),
              accountEmail: Text(user.email),
              currentAccountPicture: CircleAvatar(
                child: Text(user.nome.isNotEmpty ? user.nome[0].toUpperCase() : '?'),
              ),
            )
          else
            const ListTile(title: Text('Carregando usuário...')),

          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Tema Escuro'),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
          const Divider(),
          // NOVO: Botão de Sair também no Menu
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Sair', style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              // Fecha a tela de Menu antes de deslogar
              Navigator.of(context).pop(); 
              // Chama o logout
              context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
    );
  }
}