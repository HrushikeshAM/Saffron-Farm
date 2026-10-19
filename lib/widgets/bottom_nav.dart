import 'package:flutter/material.dart';
import '../services/game_controller.dart';
import '../theme/game_theme.dart';

enum GameScreenTab {
  farm,
  dryer,
  sell,
  shop,
  missions,
  inventory,
}

class BottomNav extends StatelessWidget {
  final GameScreenTab currentTab;
  final ValueChanged<GameScreenTab> onSelectTab;
  final GameController controller;

  const BottomNav({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
    required this.controller,
  });

  Widget _buildNavButton({
    required GameScreenTab tab,
    required String label,
    required String assetPath,
    int? badgeCount,
  }) {
    final isSelected = currentTab == tab;

    return Expanded(
      child: GestureDetector(
        onTap: () => onSelectTab(tab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0x665D3A24) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: GameTheme.gold, width: 1.5)
                : Border.all(color: Colors.transparent),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    assetPath,
                    width: 28,
                    height: 28,
                    errorBuilder: (_, __, ___) => const Icon(Icons.circle, size: 24, color: Colors.amber),
                  ),
                  if (badgeCount != null && badgeCount > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                        child: Text(
                          '$badgeCount',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: GameTheme.badgeStyle.copyWith(
                  fontSize: 10,
                  color: isSelected ? GameTheme.gold : const Color(0xFFD6D3D1),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Count claimable missions
    final claimableMissions = controller.state.missions
        .where((m) => m.isCompleted && !m.isClaimed)
        .length;

    // Count finished drying batches
    final readyBatches = controller.state.dryingBatches
        .where((b) => b.isDone && !b.isCollected)
        .length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: const BoxDecoration(
        color: Color(0xF216110D),
        border: Border(
          top: BorderSide(color: Color(0xFF5D3A24), width: 2),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black87, blurRadius: 10, offset: Offset(0, -3)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavButton(
              tab: GameScreenTab.farm,
              label: 'Farm',
              assetPath: 'assets/ui_buttons/btn_greenhouse_facility.png',
            ),
            _buildNavButton(
              tab: GameScreenTab.dryer,
              label: 'Dryer',
              assetPath: 'assets/dryers/dryer_state_01_off_empty.png',
              badgeCount: readyBatches,
            ),
            _buildNavButton(
              tab: GameScreenTab.sell,
              label: 'Trade',
              assetPath: 'assets/equipment/saffron_packaged_product.png',
            ),
            _buildNavButton(
              tab: GameScreenTab.shop,
              label: 'Shop',
              assetPath: 'assets/ui_buttons/btn_market_shop.png',
            ),
            _buildNavButton(
              tab: GameScreenTab.missions,
              label: 'Quests',
              assetPath: 'assets/ui_buttons/btn_quests_tasks.png',
              badgeCount: claimableMissions,
            ),
            _buildNavButton(
              tab: GameScreenTab.inventory,
              label: 'Bag',
              assetPath: 'assets/ui_buttons/btn_inventory_backpack.png',
            ),
          ],
        ),
      ),
    );
  }
}
