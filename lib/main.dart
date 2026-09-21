import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/exploration/map_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const BlockIslandApp());
}

class BlockIslandApp extends StatelessWidget {
  const BlockIslandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Block Island',
      theme: buildAppTheme(),
      themeMode: ThemeMode.light,
      home: const MapScreen(), // SPIKE: temporary home, revert to StyleguideScreen
    );
  }
}
