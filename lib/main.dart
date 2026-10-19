import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'screens/start_screen.dart';
import 'services/game_controller.dart';
import 'services/storage_service.dart';
import 'theme/game_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedState = await StorageService.loadGame();
  final controller = GameController(initialState: savedState);

  runApp(SaffronFarmApp(controller: controller));
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class SaffronFarmApp extends StatelessWidget {
  final GameController controller;

  const SaffronFarmApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AxiomGreen — Saffron Farming',
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: GameTheme.woodDark,
        primaryColor: GameTheme.emeraldGreen,
        colorScheme: const ColorScheme.dark(
          primary: GameTheme.emeraldGreen,
          secondary: GameTheme.gold,
          surface: GameTheme.woodMedium,
        ),
      ),
      home: StartScreen(controller: controller),
    );
  }
}
