import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/culto.dart';

class StorageService {
  static const String _cultosKey = 'cultos';

  /// Salva a lista de cultos no SharedPreferences
  static Future<void> saveCultos(List<Culto> cultos) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> cultosJson = cultos
        .map((culto) => jsonEncode(culto.toJson()))
        .toList();

    await prefs.setStringList(_cultosKey, cultosJson);
  }

  /// Carrega todos os cultos salvos
  static Future<List<Culto>> loadCultos() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> cultosJson =
        prefs.getStringList(_cultosKey) ?? [];

    return cultosJson
        .map((json) => Culto.fromJson(jsonDecode(json)))
        .toList();
  }

  /// Remove todos os cultos do armazenamento local
  static Future<void> clearCultos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cultosKey);
  }
}