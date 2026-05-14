import 'dart:async';
import 'package:flutter/material.dart';
import '../data/local_dictionary.dart';
import '../models/word_model.dart';
import '../services/history_service.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/word_card.dart';
import 'favorites_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ctrl = TextEditingController();
  bool _frToLi = true;
  List<WordModel> _results = [];
  Timer? _debounce;
  int _tab = 0;

  void _onChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 180), () {
      setState(() => _results = LocalDictionary.search(q, frToLi: _frToLi));
    });
  }

  void _swap() {
    setState(() {
      _frToLi = !_frToLi;
      _results = LocalDictionary.search(_ctrl.text, frToLi: _frToLi);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  Widget _searchBody() {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: SearchBarWidget(
                  controller: _ctrl,
                  onChanged: _onChanged,
                  hint: _frToLi
                      ? 'Rechercher en français...'
                      : 'Koluka liloba ya lingala...',
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: 'Inverser le sens',
                icon: const Icon(Icons.swap_horiz),
                onPressed: _swap,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Chip(
                label: Text(_frToLi ? 'Français → Lingala' : 'Lingala → Français'),
                backgroundColor: cs.primaryContainer,
                labelStyle: TextStyle(color: cs.onPrimaryContainer),
              ),
              const Spacer(),
              Text('${_results.length} résultat(s)',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: _ctrl.text.isEmpty
              ? _emptyState(
                  icon: Icons.search,
                  title: 'Commencez à taper',
                  message:
                      'Saisissez un mot en ${_frToLi ? "français" : "lingala"} pour voir sa traduction.',
                )
              : _results.isEmpty
                  ? _emptyState(
                      icon: Icons.sentiment_dissatisfied,
                      title: 'Aucun résultat',
                      message: 'Aucune entrée trouvée pour « ${_ctrl.text} ».',
                    )
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (_, i) {
                        final w = _results[i];
                        return GestureDetector(
                          onTap: () => HistoryService.add(w),
                          child: WordCard(word: w, frToLi: _frToLi),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _emptyState(
      {required IconData icon,
      required String title,
      required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _searchBody(),
      const FavoritesScreen(embedded: true),
      const HistoryScreen(embedded: true),
      const SettingsScreen(embedded: true),
    ];
    final titles = ['Dictionnaire', 'Favoris', 'Historique', 'Paramètres'];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_tab])),
      body: SafeArea(child: pages[_tab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: 'Rechercher'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favoris'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Historique'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Paramètres'),
        ],
      ),
    );
  }
}
