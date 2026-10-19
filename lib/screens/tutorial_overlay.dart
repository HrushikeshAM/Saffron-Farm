import 'package:flutter/material.dart';
import '../services/game_controller.dart';
import '../theme/game_theme.dart';

class TutorialOverlay extends StatelessWidget {
  final GameController controller;

  const TutorialOverlay({super.key, required this.controller});

  String _getInstruction(int step) {
    switch (step) {
      case 1:
        return '🌱 Step 1: Tap any empty cell (or "Plant All") on Tray #1 to plant saffron corms!';
      case 2:
        return '💧 Step 2: Great! Now tap "Water Tray" to hydrate the soil and accelerate growth.';
      case 3:
        return '💡 Step 3: Choose LED Grow Light intensity (buttons 1-4) for full-spectrum photosynthesis.';
      case 4:
        return '🌸 Step 4: Watch your saffron sprout and mature! When flowers bloom, tap to harvest!';
      case 5:
        return '🔥 Step 5: Switch to the "Dryer" tab below to dehydrate fresh blossoms into red saffron.';
      case 6:
        return '💰 Step 6: Head to the "Trade" tab to export dried saffron for VR Coins!';
      case 7:
        return '➕ Step 7: Swipe right to the final "+" card in the carousel to unlock an additional tray!';
      default:
        return '🎉 You have mastered the fundamentals of saffron farming! Expand and prosper!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    if (state.tutorialCompleted) return const SizedBox.shrink();

    final text = _getInstruction(state.tutorialStep);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xF5241A12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GameTheme.gold, width: 1.5),
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/banner_axiomgreen_title.png',
            width: 24,
            height: 24,
            errorBuilder: (_, __, ___) => const Icon(Icons.school, color: GameTheme.gold, size: 22),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GameTheme.bodyStyle.copyWith(
                fontSize: 11,
                color: const Color(0xFFFEF3C7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              controller.completeTutorial();
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF3E2718),
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
