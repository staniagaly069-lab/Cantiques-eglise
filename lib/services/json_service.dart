import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/word_model.dart';
import '../utils/constants.dart';

/// Charge les fichiers JSON locaux du dictionnaire.
class JsonService {
  static List<WordModel>? _frLi;
  static List<WordModel>? _liFr;

  static Future<List<WordModel>> loadFrLi() async {
    if (_frLi != null) return _frLi!;
    final raw = await rootBundle.loadString(AppConstants.assetFrLi);
    final list = (jsonDecode(raw) as List)
        .map((e) => WordModel.fromJson(e as Map<String, dynamic>))
        .toList();
    _frLi = list;
    return list;
  }

  static Future<List<WordModel>> loadLiFr() async {
    if (_liFr != null) return _liFr!;
    final raw = await rootBundle.loadString(AppConstants.assetLiFr);
    final list = (jsonDecode(raw) as List).map((e) {
      final m = e as Map<String, dynamic>;
      // On normalise sur le modèle francais/lingala.
      return WordModel(
        francais: (m['francais'] ?? '').toString(),
        lingala: (m['lingala'] ?? '').toString(),
      );
    }).toList();
    _liFr = list;
    return list;
  }
}
