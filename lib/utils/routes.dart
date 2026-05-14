import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/history_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String favorites = '/favorites';
  static const String history = '/history';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> all(
    ValueNotifier<ThemeMode> themeMode,
  ) =>
      {
        splash: (_) => const SplashScreen(),
        home: (_) => const HomeScreen(),
        favorites: (_) => const FavoritesScreen(),
        history: (_) => const HistoryScreen(),
        settings: (_) => SettingsScreen(themeMode: themeMode),
      };
}
