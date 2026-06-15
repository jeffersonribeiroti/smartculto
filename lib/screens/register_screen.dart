import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _igrejaController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  String _roleSelecionado = 'recepcionista';
  bool _senhaVisivel = false;
  bool _carregando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _igrejaController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    final novoUsuario = UserModel(
      name: _nomeController.text.trim(),
      church: _igrejaController.text.trim(),
      email: _emailController.text.trim(),
      password: _senhaController.text,
      role: _roleSelecionado,
    );

    final sucesso = await StorageService.registerUser(novoUsuario);

    setState(() => _carregando = false);

    if (!mounted) return;

    if (!sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este e-mail já está cadastrado.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Conta criada com sucesso! Faça login.'),
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
        title: const Text('Criar Conta'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0D47A1),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  'Preencha seus dados para criar uma conta.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 24),

                // Nome
                TextFormField(
                  controller: _nomeController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nome completo',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Igreja
                TextFormField(
                  controller: _igrejaController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Igreja / Congregação',
                    prefixIcon: Icon(Icons.church),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe a igreja';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // E-mail
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
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

                // Senha
                TextFormField(
                  controller: _senhaController,
                  obscureText: !_senhaVisivel,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _senhaVisivel
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _senhaVisivel = !_senhaVisivel),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a senha';
                    }
                    if (value.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirmar Senha
                TextFormField(
                  obscureText: true,
                  controller: _confirmarSenhaController,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Senha',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirme a senha';
                    }
                    if (value != _senhaController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Tipo de perfil
                DropdownButtonFormField<String>(
                  value: _roleSelecionado,
                  decoration: const InputDecoration(
                    labelText: 'Perfil',
                    prefixIcon: Icon(Icons.badge),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'recepcionista',
                      child: Text('Recepcionista'),
                    ),
                    DropdownMenuItem(
                      value: 'admin',
                      child: Text('Administrador'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _roleSelecionado = value);
                    }
                  },
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _carregando ? null : _cadastrar,
                    child: _carregando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Criar Conta'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}