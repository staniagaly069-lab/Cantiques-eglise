import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/word_model.dart';
import '../services/favorite_service.dart';

class WordCard extends StatefulWidget {
  final WordModel word;
  final bool frToLi;
  final VoidCallback? onChanged;

  const WordCard({
    super.key,
    required this.word,
    required this.frToLi,
    this.onChanged,
  });

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  final FlutterTts _tts = FlutterTts();
  bool _fav = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final f = await FavoriteService.isFavorite(widget.word);
    if (mounted) setState(() => _fav = f);
  }

  Future<void> _speak(String text, String lang) async {
    try {
      await _tts.setLanguage(lang);
      await _tts.setSpeechRate(0.45);
      await _tts.speak(text);
    } catch (_) {}
  }

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copié : $text'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _share() {
    final text = '${widget.word.francais}  →  ${widget.word.lingala}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Traduction copiée — collez-la dans une app pour partager.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final source = widget.frToLi ? widget.word.francais : widget.word.lingala;
    final target = widget.frToLi ? widget.word.lingala : widget.word.francais;
    final sourceLabel = widget.frToLi ? 'Français' : 'Lingala';
    final targetLabel = widget.frToLi ? 'Lingala' : 'Français';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sourceLabel,
                          style: TextStyle(
                              fontSize: 11,
                              color: cs.primary,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(source,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(targetLabel,
                          style: TextStyle(
                              fontSize: 11,
                              color: cs.secondary,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(target,
                          style: const TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: _fav ? 'Retirer des favoris' : 'Ajouter aux favoris',
                  icon: Icon(_fav ? Icons.favorite : Icons.favorite_border,
                      color: _fav ? Colors.red : null),
                  onPressed: () async {
                    await FavoriteService.toggle(widget.word);
                    await _refresh();
                    widget.onChanged?.call();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Écouter le mot',
                  icon: const Icon(Icons.volume_up),
                  onPressed: () => _speak(source, widget.frToLi ? 'fr-FR' : 'fr-FR'),
                ),
                IconButton(
                  tooltip: 'Copier la traduction',
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copy(target),
                ),
                IconButton(
                  tooltip: 'Partager',
                  icon: const Icon(Icons.share),
                  onPressed: _share,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
