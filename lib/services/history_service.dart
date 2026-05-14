import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word_model.dart';
import '../utils/constants.dart';

class HistoryService {
  static Future<List<WordModel>> getAll() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(AppConstants.prefsHistory);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List)
          .map((e) => WordModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> add(WordModel w) async {
    final list = await getAll();
    list.removeWhere((e) => e.id == w.id);
    list.insert(0, w);
    if (list.length > AppConstants.maxHistory) {
      list.removeRange(AppConstants.maxHistory, list.length);
    }
    final p = await SharedPreferences.getInstance();
    await p.setString(
      AppConstants.prefsHistory,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(AppConstants.prefsHistory);
  }
}
