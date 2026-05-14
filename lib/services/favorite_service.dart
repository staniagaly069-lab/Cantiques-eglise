import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word_model.dart';
import '../utils/constants.dart';

class FavoriteService {
  static Future<List<WordModel>> getAll() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(AppConstants.prefsFavorites);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List)
          .map((e) => WordModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<bool> isFavorite(WordModel w) async {
    final list = await getAll();
    return list.any((e) => e.id == w.id);
  }

  static Future<void> toggle(WordModel w) async {
    final list = await getAll();
    list.removeWhere((e) => e.id == w.id);
    final exists = (await getAll()).any((e) => e.id == w.id);
    if (!exists) list.insert(0, w);
    final p = await SharedPreferences.getInstance();
    await p.setString(
      AppConstants.prefsFavorites,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  static Future<void> remove(WordModel w) async {
    final list = await getAll();
    list.removeWhere((e) => e.id == w.id);
    final p = await SharedPreferences.getInstance();
    await p.setString(
      AppConstants.prefsFavorites,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(AppConstants.prefsFavorites);
  }
}
