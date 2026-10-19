import 'package:flutter/material.dart';
import '../services/game_controller.dart';
import '../theme/game_theme.dart';

class ShopScreen extends StatelessWidget {
  final GameController controller;

  const ShopScreen({super.key, required this.controller});

  Widget _buildShopCard({
    required BuildContext context,
    required String id,
    required String name,
    required String description,
    required String imageAsset,
    required int cost,
    int? packetsAmount,
    bool isOneTime = true,
  }) {
    final state = controller.state;
    final isPurchased = isOneTime && state.purchasedUpgrades.contains(id);
    final canAfford = state.coins >= cost;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: GameTheme.panelDecoration.copyWith(
        border: Border.all(
          color: isPurchased ? GameTheme.emeraldGreen : const Color(0xFF6A4528),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF261A12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF5A3C26)),
            ),
            child: Image.asset(
              imageAsset,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.shopping_bag, color: GameTheme.gold, size: 32),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GameTheme.headingStyle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: GameTheme.bodyStyle.copyWith(color: Colors.white70, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/icon_currency_gold_coin.png',
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$cost VR Coins',
                      style: GameTheme.badgeStyle.copyWith(
                        color: GameTheme.gold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: isPurchased || !canAfford
                ? null
                : () {
                    final ok = controller.buyShopItem(id, cost, packetsAmount: packetsAmount);
                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('🎉 Purchased $name!'),
                          backgroundColor: GameTheme.emeraldGreen,
                        ),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: isPurchased ? Colors.grey.shade800 : GameTheme.emeraldGreen,
              disabledBackgroundColor: const Color(0xFF261D16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              isPurchased ? 'Owned' : (canAfford ? 'Buy' : 'Need Coins'),
              style: GameTheme.badgeStyle.copyWith(
                color: isPurchased ? Colors.white54 : (canAfford ? Colors.white : Colors.white24),
                fontSize: 11,
              ),
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
                Image.asset(
                  'assets/ui_buttons/btn_market_shop.png',
                  width: 46,
                  height: 46,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Agricultural Market & Upgrades', style: GameTheme.headingStyle.copyWith(fontSize: 16)),
                      Text('Invest in high-efficiency farm infrastructure', style: GameTheme.bodyStyle.copyWith(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text('Seeds & Planting Material', style: GameTheme.headingStyle.copyWith(fontSize: 15)),
          const SizedBox(height: 8),

          _buildShopCard(
            context: context,
            id: 'seed_packet_1',
            name: '1× Saffron Seed Packet',
            description: 'Contains 25 Grade-1 saffron corms. Plants 1 full tray in 1 action.',
            imageAsset: 'assets/icons/icon_saffron_corm_bulb.png',
            cost: 35,
            packetsAmount: 1,
            isOneTime: false,
          ),
          _buildShopCard(
            context: context,
            id: 'seed_packet_5',
            name: '5× Bulk Seed Packets',
            description: 'Commercial 5-pack (125 corms). Sufficient to sow 5 cultivation trays.',
            imageAsset: 'assets/icons/icon_saffron_corm_bulb.png',
            cost: 150,
            packetsAmount: 5,
            isOneTime: false,
          ),

          const SizedBox(height: 12),
          Text('Farm Infrastructure & Upgrades', style: GameTheme.headingStyle.copyWith(fontSize: 15)),
          const SizedBox(height: 8),

          _buildShopCard(
            context: context,
            id: 'large_tank',
            name: '250L Hydroponic Water Tank',
            description: 'Expands water storage reservoir capacity to 250 Liters.',
            imageAsset: 'assets/equipment/water_tank_storage.png',
            cost: 200,
          ),
          _buildShopCard(
            context: context,
            id: 'auto_irrigation',
            name: 'Automated Drip Irrigation Grid',
            description: 'Maintains minimum 60% tray moisture automatically.',
            imageAsset: 'assets/icons/icon_resource_water_drop.png',
            cost: 350,
          ),
          _buildShopCard(
            context: context,
            id: 'full_spectrum_led',
            name: 'Full-Spectrum LED Matrix Fixture',
            description: 'Increases photosynthesis rate by +20% across all farm trays.',
            imageAsset: 'assets/grow_lights/grow_light_stage_03_bright_glow.png',
            cost: 300,
          ),
          _buildShopCard(
            context: context,
            id: 'turbo_dryer',
            name: 'Turbo Dehydrator Heating Coils',
            description: 'Halves drying cycle time by 50% for high-speed turnover.',
            imageAsset: 'assets/dryers/dryer_state_04_drying_high.png',
            cost: 400,
          ),
          _buildShopCard(
            context: context,
            id: 'luxury_packaging',
            name: 'Luxury Velvet Saffron Gift Jars',
            description: 'Boosts export sale revenue by +28% (32 Coins / gram).',
            imageAsset: 'assets/equipment/saffron_packaged_product.png',
            cost: 500,
          ),
        ],
      ),
    );
  }
}
