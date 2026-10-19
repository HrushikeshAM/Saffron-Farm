import 'package:flutter/material.dart';
import '../services/game_controller.dart';
import '../theme/game_theme.dart';

class PlusTrayCard extends StatelessWidget {
  final GameController controller;

  const PlusTrayCard({super.key, required this.controller});

  void _showUnlockDialog(BuildContext context) {
    final cost = controller.state.nextTrayUnlockCost;
    final nextId = controller.state.trays.length + 1;
    final hasEnough = controller.state.coins >= cost;

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: GameTheme.panelDecoration.copyWith(
              border: Border.all(color: GameTheme.gold, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/banner_axiomgreen_title.png',
                  height: 36,
                  errorBuilder: (_, __, ___) => Text(
                    'FARM EXPANSION',
                    style: GameTheme.titleStyle.copyWith(color: GameTheme.gold),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Unlock Growing Tray #$nextId',
                  style: GameTheme.titleStyle.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Add a brand-new permanent 5×5 cultivation tray (25 planting slots) to your indoor farm rack.',
                  style: GameTheme.bodyStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF291F18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: GameTheme.goldDark),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/icon_currency_gold_coin.png',
                        width: 28,
                        height: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Cost: $cost VR Coins',
                        style: GameTheme.headingStyle.copyWith(
                          color: GameTheme.gold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(0xFF3E2718),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Cancel',
                          style: GameTheme.bodyStyle.copyWith(color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: hasEnough
                            ? () {
                                Navigator.of(ctx).pop();
                                final success = controller.unlockNextTray();
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('🎉 Tray #$nextId successfully installed & ready to plant!'),
                                      backgroundColor: GameTheme.emeraldGreen,
                                    ),
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: GameTheme.emeraldGreen,
                          disabledBackgroundColor: Colors.grey.shade800,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          hasEnough ? 'Purchase' : 'Need Coins',
                          style: GameTheme.badgeStyle.copyWith(
                            color: hasEnough ? Colors.white : Colors.white38,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cost = controller.state.nextTrayUnlockCost;
    final nextId = controller.state.trays.length + 1;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Placeholder intensity bar space for visual alignment
                Container(
                  width: 220,
                  height: 22,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: const Color(0xEE160F0B),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: Colors.white12, width: 1.0),
                  ),
                  child: Center(
                    child: Text(
                      'TRAY #$nextId (LOCKED EXPANSION)',
                      style: GameTheme.badgeStyle.copyWith(
                        fontSize: 9.0,
                        color: GameTheme.gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 2),

                // Hanging Grow Light (Dimmed for locked tray)
                Opacity(
                  opacity: 0.35,
                  child: Image.asset(
                    'assets/grow_lights/grow_light_stage_01_dim.png',
                    width: 348,
                    height: 115,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 10),

                // Direct Darkened Tray Sprite with Centered Golden Plus Icon
                GestureDetector(
                  onTap: () => _showUnlockDialog(context),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Base Soil Tray with dark overlay
                      ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Color(0xB00B0806),
                          BlendMode.srcATop,
                        ),
                        child: Image.asset(
                          'assets/cultivation_trays/tray_stage_01_soil.png',
                          width: 260,
                          height: 148,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Golden Plus Icon Ring
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xEE2A1F18),
                              border: Border.all(color: GameTheme.gold, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x99F59E0B),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/ui_buttons/btn_action_add_plus.png',
                              width: 32,
                              height: 32,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'TAP TO EXPAND',
                            style: GameTheme.badgeStyle.copyWith(
                              color: GameTheme.gold,
                              letterSpacing: 1.2,
                              fontSize: 9.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                // Floating locked badge (placed below tray)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xCC1A120B),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: GameTheme.gold, width: 1.1),
                  ),
                  child: Text(
                    'LOCKED EXPANSION SLOT • TRAY #$nextId',
                    style: GameTheme.badgeStyle.copyWith(
                      color: GameTheme.gold,
                      fontSize: 10,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Sleek Floating Unlock Button
                GestureDetector(
                  onTap: () => _showUnlockDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 1.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xAA000000),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                        BoxShadow(
                          color: Color(0x77F59E0B),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icons/icon_currency_gold_coin.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'UNLOCK TRAY #$nextId FOR $cost COINS',
                          style: GameTheme.headingStyle.copyWith(
                            fontSize: 11.5,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
