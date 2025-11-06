// lib/main.dart (ATUALIZADO)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redstone_notes_app/database/database_helper.dart'; // NOVO IMPORT
import 'package:redstone_notes_app/providers/auth_provider.dart'; 
import 'package:redstone_notes_app/screens/auth_gate_screen.dart'; // IMPORTAR O NOVO GATE
import 'package:redstone_notes_app/theme_provider.dart';
// NOVO: Importa o repositório
// Certifique-se que o caminho do import está correto
import 'package:redstone_notes_app/services/auth_repository.dart'; 

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()), //
        
        // ATUALIZADO: Agora injetamos o AuthRepository no AuthProvider
        // 1. Criamos uma instância do repositório, que usa o DB.
        // 2. Criamos o AuthProvider e passamos o repositório para ele.
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            AuthRepository(DatabaseHelper.instance),
          ),
        ), 
      ],
      child: const MyApp(), //
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); //

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>( //
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Redstone Notes', //
          debugShowCheckedModeBanner: false, //
          themeMode: themeProvider.themeMode, //
          theme: ThemeData( //
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          darkTheme: ThemeData( //
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          // ATUALIZADO: A tela inicial agora é o AuthGate
          home: const AuthGateScreen(), //
        );
      },
    );
  }
}