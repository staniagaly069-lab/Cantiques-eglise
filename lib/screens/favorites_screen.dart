import 'package:flutter/material.dart';
import '../models/word_model.dart';
import '../services/favorite_service.dart';
import '../widgets/word_card.dart';

class FavoritesScreen extends StatefulWidget {
  final bool embedded;
  const FavoritesScreen({super.key, this.embedded = false});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<WordModel>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() => setState(() => _future = FavoriteService.getAll());

  @override
  Widget build(BuildContext context) {
    final body = FutureBuilder<List<WordModel>>(
      future: _future,
      builder: (_, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final list = snap.data ?? [];
        if (list.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Aucun favori pour le moment.\nTouchez ❤️ sur un mot pour le sauvegarder.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => _reload(),
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) => WordCard(
              word: list[i],
              frToLi: true,
              onChanged: _reload,
            ),
          ),
        );
      },
    );
    if (widget.embedded) return body;
    return Scaffold(appBar: AppBar(title: const Text('Favoris')), body: body);
  }
}
