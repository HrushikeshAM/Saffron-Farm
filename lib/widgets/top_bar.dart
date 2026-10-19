import 'package:flutter/material.dart';
import '../services/game_controller.dart';
import '../theme/game_theme.dart';

class TopBar extends StatelessWidget {
  final GameController controller;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenMenu;

  const TopBar({
    super.key,
    required this.controller,
    required this.onOpenSettings,
    required this.onOpenMenu,
  });

  Widget _buildCapsule({
    required Widget icon,
    required Widget label,
    Widget? trailing,
    VoidCallback? onTap,
    String? tooltip,
    Color borderColor = const Color(0x55D4AF37),
  }) {
    Widget content = Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: const Color(0xEE1E150F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 1.5)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 4),
          label,
          if (trailing != null) ...[
            const SizedBox(width: 4),
            trailing,
          ],
        ],
      ),
    );

    if (onTap != null) {
      content = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    if (tooltip != null) {
      content = Tooltip(
        message: tooltip,
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    final state = controller.state;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const BoxDecoration(
        color: Color(0xEE140D09),
        border: Border(
          bottom: BorderSide(color: Color(0x33D4AF37), width: 1.0),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. Level Badge
            _buildCapsule(
              tooltip: 'Farm Rank: Level ${state.level} (${(state.xpProgress * 100).toInt()}% XP)',
              borderColor: const Color(0x66D4AF37),
              icon: Image.asset(
                'assets/icons/icon_level_progress_badge.png',
                width: 17,
                height: 17,
                errorBuilder: (_, __, ___) => const Icon(Icons.star, color: GameTheme.gold, size: 16),
              ),
              label: Text(
                'Lv.${state.level}',
                style: GameTheme.badgeStyle.copyWith(
                  color: GameTheme.gold,
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 2. VR Coins (Formatted Compact)
            _buildCapsule(
              tooltip: '${GameTheme.formatExactCoins(state.coins)} VR Coins',
              borderColor: const Color(0x66D4AF37),
              icon: Image.asset(
                'assets/icons/icon_currency_gold_coin.png',
                width: 17,
                height: 17,
                errorBuilder: (_, __, ___) => const Icon(Icons.monetization_on, color: GameTheme.gold, size: 16),
              ),
              label: Text(
                GameTheme.formatCompactCoins(state.coins),
                style: GameTheme.headingStyle.copyWith(
                  color: GameTheme.gold,
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 3. Water Tank + Refill
            _buildCapsule(
              tooltip: 'Water Tank: ${state.waterLevel.toInt()}/${state.maxWaterLevel.toInt()}L (Tap to refill)',
              borderColor: const Color(0x6638BDF8),
              onTap: () {
                if (state.waterLevel < state.maxWaterLevel) {
                  controller.refillWater();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('💧 Water Tank fully refilled from reservoir!'),
                      duration: Duration(seconds: 1),
                      backgroundColor: GameTheme.waterBlue,
                    ),
                  );
                }
              },
              icon: Image.asset(
                'assets/icons/icon_resource_water_drop.png',
                width: 16,
                height: 16,
                errorBuilder: (_, __, ___) => const Icon(Icons.water_drop, color: GameTheme.waterBlueLight, size: 15),
              ),
              label: Text(
                '${state.waterLevel.toInt()}L',
                style: GameTheme.bodyStyle.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF7DD3FC),
                ),
              ),
              trailing: const Icon(Icons.add_circle, color: Color(0xFF38BDF8), size: 13),
            ),

            // 4. Seed Packets
            _buildCapsule(
              tooltip: '${state.seedPackets} Seed Packets (25 Corms each)',
              borderColor: const Color(0x55F59E0B),
              icon: Image.asset(
                'assets/icons/icon_saffron_corm_bulb.png',
                width: 16,
                height: 16,
                errorBuilder: (_, __, ___) => const Icon(Icons.spa, color: Colors.greenAccent, size: 15),
              ),
              label: Text(
                '${state.seedPackets} pkts',
                style: GameTheme.bodyStyle.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFED7AA),
                ),
              ),
            ),

            // 5. Settings / Guide Button
            Tooltip(
              message: 'Settings & Farm Guide',
              child: GestureDetector(
                onTap: onOpenSettings,
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Center(
                    child: Image.asset(
                      'assets/ui_buttons/btn_settings_options.png',
                      width: 28,
                      height: 28,
                      errorBuilder: (_, __, ___) => const Icon(Icons.settings, color: GameTheme.gold, size: 15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
