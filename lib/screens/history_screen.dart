import 'package:flutter/material.dart';
import '../models/word_model.dart';
import '../services/history_service.dart';
import '../widgets/word_card.dart';

class HistoryScreen extends StatefulWidget {
  final bool embedded;
  const HistoryScreen({super.key, this.embedded = false});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<WordModel>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() => setState(() => _future = HistoryService.getAll());

  Future<void> _clear() async {
    await HistoryService.clear();
    _reload();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Historique effacé')),
      );
    }
  }

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
              child: Text('Aucune recherche récente.',
                  textAlign: TextAlign.center),
            ),
          );
        }
        return Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text('Vider'),
                onPressed: _clear,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) => WordCard(
                  word: list[i],
                  frToLi: true,
                  onChanged: _reload,
                ),
              ),
            ),
          ],
        );
      },
    );
    if (widget.embedded) return body;
    return Scaffold(appBar: AppBar(title: const Text('Historique')), body: body);
  }
}
