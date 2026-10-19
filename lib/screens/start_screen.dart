import 'package:flutter/material.dart';
import '../services/game_controller.dart';
import '../theme/game_theme.dart';
import 'farm_screen.dart';
import 'settings_dialog.dart';

class StartScreen extends StatelessWidget {
  final GameController controller;

  const StartScreen({super.key, required this.controller});

  void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: GameTheme.panelDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How to Play — AxiomGreen', style: GameTheme.titleStyle.copyWith(fontSize: 18)),
              const SizedBox(height: 12),
              Text(
                '• Start with 5 unlocked 5×5 cultivation trays.\n'
                '• Tap empty cells to plant saffron corms.\n'
                '• Water trays and adjust LED lighting to boost growth.\n'
                '• Harvest vibrant purple saffron blossoms when ready.\n'
                '• Dehydrate fresh flowers in the Dryer room.\n'
                '• Export cured red saffron for VR Coins at the Trade desk!\n'
                '• Swipe to the "+" card at the end of the carousel to unlock new trays!',
                style: GameTheme.bodyStyle.copyWith(fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(backgroundColor: GameTheme.emeraldGreen),
                  child: const Text('Back to Menu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset(
            'assets/backgrounds/background_greenhouse_interior.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: GameTheme.woodDark),
          ),
          // Vignette
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xCC0D0907),
                  Color(0x661A120D),
                  Color(0xEE0D0907),
                ],
              ),
            ),
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title Banner
                  Image.asset(
                    'assets/icons/banner_axiomgreen_title.png',
                    height: 52,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'SAFFRON FARMING SIMULATOR',
                    style: GameTheme.titleStyle.copyWith(
                      letterSpacing: 2.0,
                      color: GameTheme.gold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Premium Indoor Vertical Cultivation',
                    style: GameTheme.bodyStyle.copyWith(color: const Color(0xFFFED7AA), fontSize: 13),
                  ),
                  const SizedBox(height: 36),

                  // Play / Continue Button
                  SizedBox(
                    width: 240,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => AnimatedBuilder(
                              animation: controller,
                              builder: (_, __) => FarmScreen(controller: controller),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GameTheme.emeraldGreen,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Color(0xFF6EE7B7), width: 1.5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.play_arrow, size: 28, color: Colors.white),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              controller.state.xp > 0 ? 'CONTINUE FARM' : 'START FARMING',
                              style: GameTheme.headingStyle.copyWith(fontSize: 14, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // How to Play
                  SizedBox(
                    width: 240,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => _showHowToPlay(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xCC2A1F18),
                        side: const BorderSide(color: Color(0xFF6B4D36), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        'HOW TO PLAY',
                        style: GameTheme.badgeStyle.copyWith(fontSize: 13, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Settings
                  SizedBox(
                    width: 240,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => SettingsDialog(controller: controller),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xCC2A1F18),
                        side: const BorderSide(color: Color(0xFF6B4D36), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        'SETTINGS',
                        style: GameTheme.badgeStyle.copyWith(fontSize: 13, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Starting status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xDD1C140E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF4A3424)),
                    ),
                    child: Text(
                      '5 Unlocked Trays • 500 Starting Coins • 35 Corms',
                      style: GameTheme.bodyStyle.copyWith(fontSize: 11, color: Colors.white60),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
