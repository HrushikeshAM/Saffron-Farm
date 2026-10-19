import 'package:flutter/material.dart';
import '../services/game_controller.dart';
import '../theme/game_theme.dart';

class ExpansionScreen extends StatelessWidget {
  final GameController controller;

  const ExpansionScreen({super.key, required this.controller});

  Widget _buildRoomCard({
    required BuildContext context,
    required String roomId,
    required String title,
    required String subtitle,
    required String previewAsset,
    required int unlockLevel,
    required int cost,
    required String perks,
  }) {
    final state = controller.state;
    final isUnlocked = state.unlockedRooms.contains(roomId);
    final levelOk = state.level >= unlockLevel;
    final coinsOk = state.coins >= cost;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: GameTheme.panelDecoration.copyWith(
        border: Border.all(
          color: isUnlocked ? GameTheme.emeraldGreen : (levelOk ? GameTheme.gold : const Color(0xFF5A3C26)),
          width: isUnlocked ? 2 : 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Room Preview Graphic
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  previewAsset,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 140,
                    color: const Color(0xFF261A12),
                    child: const Icon(Icons.domain, color: GameTheme.gold, size: 48),
                  ),
                ),
                if (!isUnlocked)
                  Container(
                    height: 140,
                    color: const Color(0xBB000000),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/ui_buttons/btn_status_locked.png', width: 44, height: 44),
                          const SizedBox(height: 6),
                          Text(
                            levelOk ? 'Available for Expansion' : 'Unlocks at Level $unlockLevel',
                            style: GameTheme.badgeStyle.copyWith(color: levelOk ? GameTheme.gold : Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUnlocked ? GameTheme.emeraldGreen : const Color(0xDD000000),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isUnlocked ? 'Active Facility' : 'Locked',
                      style: GameTheme.badgeStyle.copyWith(fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GameTheme.headingStyle.copyWith(fontSize: 15)),
                const SizedBox(height: 2),
                Text(subtitle, style: GameTheme.bodyStyle.copyWith(color: Colors.white70, fontSize: 11)),
                const SizedBox(height: 6),
                Text('Facility Perks: $perks', style: GameTheme.bodyStyle.copyWith(color: const Color(0xFFFED7AA), fontSize: 11)),
                const SizedBox(height: 10),
                if (!isUnlocked)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/icons/icon_currency_gold_coin.png', width: 20, height: 20),
                          const SizedBox(width: 6),
                          Text('$cost Coins', style: GameTheme.headingStyle.copyWith(color: GameTheme.gold, fontSize: 14)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: levelOk && coinsOk
                            ? () {
                                controller.unlockRoom(roomId, cost);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('🏭 Unlocked $title! Capacity expanded!'),
                                    backgroundColor: GameTheme.emeraldGreen,
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GameTheme.emeraldGreen,
                          disabledBackgroundColor: const Color(0xFF261D16),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          !levelOk ? 'Requires LV $unlockLevel' : (coinsOk ? 'Expand Facility' : 'Need Coins'),
                          style: GameTheme.badgeStyle.copyWith(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: GameTheme.panelDecoration,
            child: Row(
              children: [
                Image.asset('assets/ui_buttons/btn_greenhouse_facility.png', width: 46, height: 46),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Farm Expansion & Facilities', style: GameTheme.headingStyle.copyWith(fontSize: 16)),
                      Text('Expand indoor vertical cultivation chambers', style: GameTheme.bodyStyle.copyWith(fontSize: 11, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _buildRoomCard(
            context: context,
            roomId: 'room_starter_greenhouse',
            title: 'Facility Alpha: Starter Vertical Greenhouse',
            subtitle: 'Warm cedar timber indoor facility with automated grow racks.',
            previewAsset: 'assets/environment/farm_room.png',
            unlockLevel: 1,
            cost: 0,
            perks: '5 Starting Trays + Modular Tray Carousel (+)',
          ),
          _buildRoomCard(
            context: context,
            roomId: 'room_hydro_bay_b',
            title: 'Facility Beta: Hydroponic Chamber Bay B',
            subtitle: 'Precision climate-controlled room with high-efficiency air circulation.',
            previewAsset: 'assets/environment/farm_room_empty.png',
            unlockLevel: 2,
            cost: 500,
            perks: '+10% Crop Moisture Retention & +25 Corms Bonus',
          ),
          _buildRoomCard(
            context: context,
            roomId: 'room_biosphere_vault',
            title: 'Facility Gamma: Saffron Biosphere Vault',
            subtitle: 'Ultra-pure saffron cultivation laboratory with peak thermal yield.',
            previewAsset: 'assets/environment/farm_room_harvest_ready.png',
            unlockLevel: 4,
            cost: 1200,
            perks: '+15% Saffron Flower Harvest Yield & +50 Corms Bonus',
          ),
        ],
      ),
    );
  }
}
