// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redstone_notes_app/theme_provider.dart';
import 'package:redstone_notes_app/screens/home_screen.dart';

void main() {
  runApp(
    // O ChangeNotifierProvider disponibiliza o ThemeProvider para todo o app
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer escuta as mudanças no ThemeProvider e reconstrói a MaterialApp
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Redstone Notes',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode, // Usa o modo de tema do provider
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}