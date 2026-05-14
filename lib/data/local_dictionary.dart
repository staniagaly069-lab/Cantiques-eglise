import '../models/word_model.dart';
import '../services/json_service.dart';

/// Cache mémoire pour le dictionnaire local + recherche rapide.
class LocalDictionary {
  static List<WordModel> frLi = [];
  static List<WordModel> liFr = [];
  static bool _loaded = false;

  static Future<void> ensureLoaded() async {
    if (_loaded) return;
    frLi = await JsonService.loadFrLi();
    liFr = await JsonService.loadLiFr();
    _loaded = true;
  }

  /// Recherche dans la direction donnée. [frToLi] true = chercher en français.
  static List<WordModel> search(String query, {required bool frToLi}) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    final source = frToLi ? frLi : liFr;
    final starts = <WordModel>[];
    final contains = <WordModel>[];
    for (final w in source) {
      final key = (frToLi ? w.francais : w.lingala).toLowerCase();
      if (key.startsWith(q)) {
        starts.add(w);
      } else if (key.contains(q)) {
        contains.add(w);
      }
      if (starts.length >= 200) break;
    }
    return [...starts, ...contains].take(200).toList();
  }
}
