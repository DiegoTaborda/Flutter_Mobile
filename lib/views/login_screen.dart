import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redstone_notes_app/controllers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onTapRegister;
  const LoginScreen({super.key, required this.onTapRegister});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;
  
  bool _keepLoggedIn = true;

  Future<void> _login() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final error = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _keepLoggedIn,
    );

    if (mounted) {
      setState(() { _isLoading = false; });
      if (error != null) {
        setState(() { _errorMessage = error; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder()),
                obscureText: true,
              ),
              const SizedBox(height: 8),

              CheckboxListTile(
                title: const Text('Continuar logado'),
                value: _keepLoggedIn,
                onChanged: (bool? newValue) {
                  setState(() {
                    _keepLoggedIn = newValue ?? true;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 24),
              
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Entrar'),
                ),
              const SizedBox(height: 16),
              
              TextButton(
                onPressed: widget.onTapRegister,
                child: const Text('Não tem uma conta? Registre-se'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
