import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/culto.dart';
import '../models/user_model.dart';

class StorageService {
  static const String _cultosKey = 'cultos';
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';

  // ─── Cultos ───────────────────────────────────────────────

  /// Salva a lista completa de cultos (com visitantes embutidos)
  static Future<void> saveCultos(List<Culto> cultos) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cultosJson =
        cultos.map((c) => jsonEncode(c.toJson())).toList();
    await prefs.setStringList(_cultosKey, cultosJson);
  }

  /// Carrega todos os cultos salvos
  static Future<List<Culto>> loadCultos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cultosJson = prefs.getStringList(_cultosKey) ?? [];
    return cultosJson
        .map((json) => Culto.fromJson(jsonDecode(json)))
        .toList();
  }

  /// Remove todos os cultos do armazenamento local
  static Future<void> clearCultos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cultosKey);
  }

  // ─── Usuários ─────────────────────────────────────────────

  /// Salva a lista de usuários cadastrados
  static Future<void> saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> usersJson =
        users.map((u) => jsonEncode(u.toJson())).toList();
    await prefs.setStringList(_usersKey, usersJson);
  }

  /// Carrega todos os usuários cadastrados
  static Future<List<UserModel>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> usersJson = prefs.getStringList(_usersKey) ?? [];

    // Se não houver usuários, inicializa com usuários padrão
    if (usersJson.isEmpty) {
      final defaultUsers = _defaultUsers();
      await saveUsers(defaultUsers);
      return defaultUsers;
    }

    return usersJson
        .map((json) => UserModel.fromJson(jsonDecode(json)))
        .toList();
  }

  /// Autentica um usuário por e-mail e senha
  static Future<UserModel?> authenticate(String email, String password) async {
    final users = await loadUsers();
    try {
      return users.firstWhere(
        (u) =>
            u.email.toLowerCase() == email.toLowerCase() &&
            u.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  /// Atualiza a senha de um usuário pelo e-mail
  static Future<bool> updatePassword(String email, String newPassword) async {
    final users = await loadUsers();
    final index = users.indexWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );
    if (index == -1) return false;
    users[index].password = newPassword;
    await saveUsers(users);
    return true;
  }

  /// Registra um novo usuário
  static Future<bool> registerUser(UserModel user) async {
    final users = await loadUsers();
    final exists = users.any(
      (u) => u.email.toLowerCase() == user.email.toLowerCase(),
    );
    if (exists) return false;
    users.add(user);
    await saveUsers(users);
    return true;
  }

  // ─── Sessão atual ─────────────────────────────────────────

  /// Salva o usuário logado
  static Future<void> saveCurrentUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
  }

  /// Carrega o usuário logado
  static Future<UserModel?> loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_currentUserKey);
    if (data == null) return null;
    return UserModel.fromJson(jsonDecode(data));
  }

  /// Remove a sessão do usuário logado (logout)
  static Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // ─── Dados Padrão ─────────────────────────────────────────

  static List<UserModel> _defaultUsers() {
    return [
      UserModel(
        name: 'Administrador',
        church: 'Igreja SmartCulto',
        email: 'admin@smartculto.com',
        password: 'admin123',
        role: 'admin',
      ),
      UserModel(
        name: 'Recepcionista',
        church: 'Igreja SmartCulto',
        email: 'recepcionista@smartculto.com',
        password: '123456',
        role: 'recepcionista',
      ),
    ];
  }
}
