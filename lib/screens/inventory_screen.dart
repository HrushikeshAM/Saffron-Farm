import 'package:flutter/material.dart';
import '../services/game_controller.dart';
import '../theme/game_theme.dart';

class InventoryScreen extends StatelessWidget {
  final GameController controller;

  const InventoryScreen({super.key, required this.controller});

  Widget _buildItemCard({
    required String name,
    required String quantity,
    required String description,
    required String assetPath,
    Color? accentColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: GameTheme.panelDecoration.copyWith(
        border: Border.all(color: accentColor ?? const Color(0xFF6B4D36), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF261A12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF5A3C26)),
            ),
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.inventory_2, color: GameTheme.gold, size: 28),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: GameTheme.headingStyle.copyWith(fontSize: 14)),
                    Text(
                      quantity,
                      style: GameTheme.headingStyle.copyWith(
                        fontSize: 14,
                        color: accentColor ?? GameTheme.gold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: GameTheme.bodyStyle.copyWith(color: Colors.white70, fontSize: 11),
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
    final state = controller.state;
    final totalSlots = state.trays.length * 25;

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
                Image.asset('assets/ui_buttons/btn_inventory_backpack.png', width: 46, height: 46),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Farm Inventory & Storage', style: GameTheme.headingStyle.copyWith(fontSize: 16)),
                      Text('Real-time ledger of raw materials and farm assets', style: GameTheme.bodyStyle.copyWith(fontSize: 11, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text('Liquid Treasury & Capital', style: GameTheme.headingStyle.copyWith(fontSize: 15)),
          const SizedBox(height: 8),

          _buildItemCard(
            name: 'VR Gold Coins',
            quantity: '${GameTheme.formatExactCoins(state.coins)} Coins',
            description: 'Exact liquid treasury balance. Usable for expansions, facility upgrades, and seed packets.',
            assetPath: 'assets/icons/icon_currency_gold_coin.png',
            accentColor: GameTheme.gold,
          ),

          const SizedBox(height: 12),
          Text('Crops & Agricultural Resources', style: GameTheme.headingStyle.copyWith(fontSize: 15)),
          const SizedBox(height: 8),

          _buildItemCard(
            name: 'Saffron Seed Packets',
            quantity: 'Seed Packets × ${state.seedPackets}',
            description: '1 Packet contains 25 seeds. Plants 1 full 25-crop tray in one action.',
            assetPath: 'assets/icons/icon_saffron_corm_bulb.png',
            accentColor: const Color(0xFFFED7AA),
          ),
          _buildItemCard(
            name: 'Fresh Saffron Blossoms',
            quantity: '${state.freshFlowers} flowers',
            description: 'Freshly harvested purple petals ready for the dehydrator.',
            assetPath: 'assets/icons/icon_saffron_flower.png',
            accentColor: GameTheme.saffronPurpleLight,
          ),
          _buildItemCard(
            name: 'Pure Dried Saffron',
            quantity: '${state.driedGrams.toStringAsFixed(1)}g',
            description: 'Premium dehydrated red filaments ready for trade export.',
            assetPath: 'assets/equipment/saffron_packaged_product.png',
            accentColor: GameTheme.gold,
          ),
          _buildItemCard(
            name: 'Irrigation Water Reservoir',
            quantity: '${state.waterLevel.toInt()} / ${state.maxWaterLevel.toInt()} L',
            description: 'Filtered nutrient water for optimal tray moisture.',
            assetPath: 'assets/icons/icon_resource_water_drop.png',
            accentColor: GameTheme.waterBlueLight,
          ),

          const SizedBox(height: 12),
          Text('Farm Infrastructure & Installed Equipment', style: GameTheme.headingStyle.copyWith(fontSize: 15)),
          const SizedBox(height: 8),

          _buildItemCard(
            name: 'Cultivation Trays',
            quantity: '${state.trays.length} Trays ($totalSlots Slots)',
            description: '5×5 modular growing beds installed on vertical racks.',
            assetPath: 'assets/cultivation_trays/tray_stage_01_soil.png',
            accentColor: GameTheme.emeraldGreen,
          ),

          if (state.purchasedUpgrades.contains('large_tank'))
            _buildItemCard(
              name: '250L Commercial Water Tank',
              quantity: 'Installed',
              description: 'Industrial capacity tank with reinforced level gauge.',
              assetPath: 'assets/equipment/water_tank_storage.png',
              accentColor: GameTheme.waterBlue,
            ),

          if (state.purchasedUpgrades.contains('auto_irrigation'))
            _buildItemCard(
              name: 'Automated Drip Irrigation',
              quantity: 'Active',
              description: 'Maintains optimal soil moisture above 60% automatically.',
              assetPath: 'assets/icons/icon_resource_water_drop.png',
              accentColor: GameTheme.waterBlueLight,
            ),

          if (state.purchasedUpgrades.contains('full_spectrum_led'))
            _buildItemCard(
              name: 'Full-Spectrum LED Array',
              quantity: 'Active',
              description: 'Overhead grow lights boosting photosynthesis by +20%.',
              assetPath: 'assets/grow_lights/grow_light_stage_03_bright_glow.png',
              accentColor: GameTheme.amberGlow,
            ),

          if (state.purchasedUpgrades.contains('turbo_dryer'))
            _buildItemCard(
              name: 'Turbo Heating Coils',
              quantity: 'Active',
              description: 'Accelerated thermal dehydrator cycle (50% faster).',
              assetPath: 'assets/dryers/dryer_state_04_drying_high.png',
              accentColor: GameTheme.orangeGlow,
            ),

          if (state.purchasedUpgrades.contains('luxury_packaging'))
            _buildItemCard(
              name: 'Luxury Velvet Packaging',
              quantity: 'Active',
              description: 'Premium glass gift jars boosting export sale price by +28%.',
              assetPath: 'assets/equipment/saffron_packaged_product.png',
              accentColor: GameTheme.gold,
            ),
        ],
      ),
    );
  }
}
