import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redstone_notes_app/database/database_helper.dart';
import 'package:redstone_notes_app/controllers/auth_provider.dart'; 
import 'package:redstone_notes_app/views/auth_gate_screen.dart';
import 'package:redstone_notes_app/controllers/theme_provider.dart';
import 'package:redstone_notes_app/services/auth_repository.dart'; 

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()), //
        
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            AuthRepository(DatabaseHelper.instance),
          ),
        ), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>( //
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Redstone Notes',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
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
          home: const AuthGateScreen(),
        );
      },
    );
  }
}
