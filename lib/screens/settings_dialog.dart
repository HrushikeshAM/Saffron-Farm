import 'package:flutter/material.dart';
import '../services/game_controller.dart';
import '../theme/game_theme.dart';

class SettingsDialog extends StatelessWidget {
  final GameController controller;

  const SettingsDialog({super.key, required this.controller});

  void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: GameTheme.panelDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('How to Farm Saffron', style: GameTheme.titleStyle.copyWith(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '1. Plant Corms: Tap any empty cell in your 5×5 trays or tap "Plant All" to sow seeds.\n\n'
                '2. Irrigate & Illuminate: Keep soil moisture above 40% and adjust LED grow lights (1-4) for maximum growth speed.\n\n'
                '3. Harvest Red Gold: When purple flowers blossom, tap them to collect fresh saffron blooms.\n\n'
                '4. Dehydrate: Place fresh harvests in the Dryer room to cure them into high-value dried saffron filaments.\n\n'
                '5. Trade & Expand: Export dried saffron at the trade counter for VR Coins, unlock additional trays (+ Card), and upgrade equipment!',
                style: GameTheme.bodyStyle.copyWith(fontSize: 12, height: 1.4),
              ),
              const SizedBox(height: 14),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(backgroundColor: GameTheme.emeraldGreen),
                  child: const Text('Got It!'),
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
    final state = controller.state;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: GameTheme.panelDecoration.copyWith(
          border: Border.all(color: GameTheme.gold, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Farm Settings', style: GameTheme.titleStyle.copyWith(fontSize: 18)),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Image.asset(
                    'assets/ui_buttons/btn_action_cancel_close.png',
                    width: 32,
                    height: 32,
                  ),
                ),
              ],
            ),
            const Divider(color: Color(0xFF5A3C26), height: 20),

            // SFX Volume
            Row(
              children: [
                const Icon(Icons.volume_up, color: GameTheme.gold, size: 20),
                const SizedBox(width: 8),
                Text('Sound Effects', style: GameTheme.bodyStyle),
                Expanded(
                  child: Slider(
                    value: state.sfxVolume,
                    min: 0.0,
                    max: 1.0,
                    activeColor: GameTheme.gold,
                    onChanged: (val) {
                      controller.updateAudioVolumes(val, state.musicVolume);
                    },
                  ),
                ),
              ],
            ),

            // Music Volume
            Row(
              children: [
                const Icon(Icons.music_note, color: GameTheme.gold, size: 20),
                const SizedBox(width: 8),
                Text('Ambient Music', style: GameTheme.bodyStyle),
                Expanded(
                  child: Slider(
                    value: state.musicVolume,
                    min: 0.0,
                    max: 1.0,
                    activeColor: GameTheme.gold,
                    onChanged: (val) {
                      controller.updateAudioVolumes(state.sfxVolume, val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Fast Growth Mode (Debug / Development toggle)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF2B1D14),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: state.isFastGrowthMode ? GameTheme.amberGlow : Colors.transparent),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fast Crop Growth Mode', style: GameTheme.headingStyle.copyWith(fontSize: 13)),
                      Text('Speeds up stage timers for rapid testing', style: GameTheme.bodyStyle.copyWith(fontSize: 10, color: Colors.white60)),
                    ],
                  ),
                  Switch(
                    value: state.isFastGrowthMode,
                    activeTrackColor: GameTheme.amberGlow,
                    onChanged: (_) => controller.toggleFastGrowthMode(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Action Buttons
            OutlinedButton.icon(
              icon: const Icon(Icons.help_outline, color: GameTheme.gold, size: 18),
              label: const Text('How to Play Guide', style: TextStyle(color: Colors.white)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF6A4528)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onPressed: () => _showHowToPlay(context),
            ),
            const SizedBox(height: 8),

            OutlinedButton.icon(
              icon: const Icon(Icons.refresh, color: Colors.orangeAccent, size: 18),
              label: const Text('Replay Tutorial', style: TextStyle(color: Colors.white)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF6A4528)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onPressed: () {
                controller.resetTutorial();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Interactive Tutorial restarted!')),
                );
              },
            ),
            const SizedBox(height: 8),

            TextButton(
              onPressed: () {
                controller.resetGameData();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Game data reset to fresh 5-tray farm!')),
                );
              },
              child: const Text('Reset All Farm Progress', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
