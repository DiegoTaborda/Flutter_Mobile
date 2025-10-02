// lib/screens/menu_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redstone_notes_app/theme_provider.dart';
import 'package:redstone_notes_app/screens/profile_screen.dart';
import 'package:redstone_notes_app/screens/settings_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos o 'Provider.of' para acessar o nosso ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: ListView(
        children: [
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
          // SwitchListTile é um widget perfeito para opções de ligar/desligar
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Tema Escuro'),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              // Pede ao provider para trocar o tema, sem precisar de setState aqui
              themeProvider.toggleTheme(value);
            },
          ),
        ],
      ),
    );
  }
}