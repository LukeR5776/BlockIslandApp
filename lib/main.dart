import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/exploration/map_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final appState = AppState();
  await appState.load();
  runApp(BlockIslandApp(appState: appState));
}

class BlockIslandApp extends StatelessWidget {
  final AppState appState;

  const BlockIslandApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value(
      value: appState,
      child: MaterialApp(
        title: 'Block Island',
        theme: buildAppTheme(),
        themeMode: ThemeMode.light,
        home: const MapScreen(), // SPIKE: temporary home, revert to StyleguideScreen
      ),
    );
  }
}
