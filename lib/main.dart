import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/exploration/map_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([ // iPhone-only: portrait locked
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final appState = AppState();
  await appState.load(); // restore persisted state before first frame
  runApp(BlockIslandApp(appState: appState));
}

class BlockIslandApp extends StatelessWidget {
  final AppState appState;

  const BlockIslandApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value( // registered above MaterialApp per CLAUDE.md
      value: appState,
      child: MaterialApp(
        title: 'Block Island',
        theme: buildAppTheme(),
        themeMode: ThemeMode.light, // locked light, no dark mode
        home: const MapScreen(), // SPIKE: temporary home, revert to StyleguideScreen
      ),
    );
  }
}
