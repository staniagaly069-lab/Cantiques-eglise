import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/constants.dart';
import 'utils/themes.dart';
import 'utils/routes.dart';
import 'screens/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final p = await SharedPreferences.getInstance();
  final saved = p.getString(AppConstants.prefsTheme);
  final initial = saved == 'dark'
      ? ThemeMode.dark
      : saved == 'light'
          ? ThemeMode.light
          : ThemeMode.system;
  runApp(DicoApp(initialMode: initial));
}

class DicoApp extends StatefulWidget {
  final ThemeMode initialMode;
  const DicoApp({super.key, required this.initialMode});

  @override
  State<DicoApp> createState() => _DicoAppState();
}

class _DicoAppState extends State<DicoApp> {
  late final ValueNotifier<ThemeMode> _mode =
      ValueNotifier<ThemeMode>(widget.initialMode);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _mode,
      builder: (_, mode, __) => ThemeScope(
        notifier: _mode,
        child: MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          themeMode: mode,
          initialRoute: AppRoutes.splash,
          routes: AppRoutes.all(_mode),
        ),
      ),
    );
  }
}
