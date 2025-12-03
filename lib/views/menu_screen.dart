import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redstone_notes_app/controllers/auth_provider.dart';
import 'package:redstone_notes_app/controllers/theme_provider.dart';
import 'package:redstone_notes_app/views/profile_screen.dart';
import 'package:redstone_notes_app/views/settings_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: ListView(
        children: [
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
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Sair', style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.of(context).pop(); 
              context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
    );
  }
}
