import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:redstone_notes_app/controllers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onTapLogin;
  const RegisterScreen({super.key, required this.onTapLogin});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _idadeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final error = await authProvider.register(
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      idade: int.tryParse(_idadeController.text) ?? 0,
      password: _passwordController.text,
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Registrar', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 32),
                
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome do Usuário', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Nome é obrigatório' : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val!.isEmpty ? 'Email é obrigatório' : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _idadeController,
                  decoration: const InputDecoration(labelText: 'Idade', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (val) => val!.isEmpty ? 'Idade é obrigatória' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder()),
                  obscureText: true,
                  validator: (val) => val!.length < 6 ? 'Senha deve ter no mínimo 6 caracteres' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(labelText: 'Confirmar Senha', border: OutlineInputBorder()),
                  obscureText: true,
                  validator: (val) {
                    if (val != _passwordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 32),
                
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _register,
                    child: const Text('Registrar'),
                  ),
                const SizedBox(height: 16),
                
                TextButton(
                  onPressed: widget.onTapLogin,
                  child: const Text('Já tem uma conta? Faça login'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
