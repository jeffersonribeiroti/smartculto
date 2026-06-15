import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _carregando = false;
  bool _novaSenhaVisivel = false;
  bool _confirmarSenhaVisivel = false;

  @override
  void dispose() {
    _emailController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _redefinirSenha() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    final sucesso = await StorageService.updatePassword(
      _emailController.text.trim(),
      _novaSenhaController.text,
    );

    setState(() => _carregando = false);

    if (!mounted) return;

    if (!sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail não encontrado no sistema.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Senha redefinida com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Redefinir Senha'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0D47A1),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lock_reset,
                    size: 60,
                    color: Color(0xFF0D47A1),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Redefinir Senha',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Informe seu e-mail cadastrado e escolha uma nova senha.',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 32),

                  // E-mail
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail cadastrado',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o e-mail';
                      }
                      if (!value.contains('@')) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Nova Senha
                  TextFormField(
                    controller: _novaSenhaController,
                    obscureText: !_novaSenhaVisivel,
                    decoration: InputDecoration(
                      labelText: 'Nova Senha',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _novaSenhaVisivel
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(
                              () => _novaSenhaVisivel = !_novaSenhaVisivel);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a nova senha';
                      }
                      if (value.length < 6) {
                        return 'A senha deve ter pelo menos 6 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Confirmar Senha
                  TextFormField(
                    controller: _confirmarSenhaController,
                    obscureText: !_confirmarSenhaVisivel,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Nova Senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _confirmarSenhaVisivel
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() =>
                              _confirmarSenhaVisivel = !_confirmarSenhaVisivel);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirme a nova senha';
                      }
                      if (value != _novaSenhaController.text) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // Botão Redefinir
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _carregando ? null : _redefinirSenha,
                      child: _carregando
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Redefinir Senha'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
