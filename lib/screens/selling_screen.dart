import 'package:flutter/material.dart';
import '../services/game_controller.dart';
import '../theme/game_theme.dart';

class SellingScreen extends StatefulWidget {
  final GameController controller;

  const SellingScreen({super.key, required this.controller});

  @override
  State<SellingScreen> createState() => _SellingScreenState();
}

class _SellingScreenState extends State<SellingScreen> {
  double _gramsToSell = 1.0;

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;
    final availableGrams = state.driedGrams;
    final hasLuxury = state.purchasedUpgrades.contains('luxury_packaging');
    final pricePerGram = hasLuxury ? 32 : 25;

    final effectiveGrams = _gramsToSell.clamp(0.0, availableGrams);
    final totalEarnings = (effectiveGrams * pricePerGram).round();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Selling Counter Display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: GameTheme.panelDecoration,
            child: Column(
              children: [
                Image.asset(
                  'assets/equipment/saffron_packaged_product.png',
                  height: 140,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/production/saffron_selling_counter.png',
                    height: 140,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'AxiomGreen Saffron Trading Desk',
                  style: GameTheme.headingStyle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  'Export Grade A+ Kashmiri Crimson Saffron',
                  style: GameTheme.bodyStyle.copyWith(color: GameTheme.gold, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Inventory & Pricing Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: GameTheme.panelDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dried Saffron in Vault:',
                      style: GameTheme.bodyStyle.copyWith(color: Colors.white70),
                    ),
                    Text(
                      '${availableGrams.toStringAsFixed(1)} grams',
                      style: GameTheme.headingStyle.copyWith(
                        color: GameTheme.gold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Market Rate:',
                      style: GameTheme.bodyStyle.copyWith(color: Colors.white70),
                    ),
                    Text(
                      '$pricePerGram VR Coins / gram ${hasLuxury ? "(+28% Luxury Bonus)" : ""}',
                      style: GameTheme.badgeStyle.copyWith(
                        color: hasLuxury ? GameTheme.emeraldGreen : Colors.white,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFF4A3828), height: 24),

                Text(
                  'Select Quantity to Export:',
                  style: GameTheme.headingStyle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),

                if (availableGrams > 0) ...[
                  Slider(
                    value: effectiveGrams,
                    min: 0.0,
                    max: availableGrams,
                    divisions: (availableGrams * 2).round().clamp(1, 100),
                    activeColor: GameTheme.gold,
                    inactiveColor: const Color(0xFF3E2718),
                    onChanged: (val) {
                      setState(() {
                        _gramsToSell = (val * 2).round() / 2.0; // snap to 0.5g
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: availableGrams >= 1.0 ? () => setState(() => _gramsToSell = 1.0) : null,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF6B4D36)),
                        ),
                        child: const Text('1.0g', style: TextStyle(color: Colors.white)),
                      ),
                      OutlinedButton(
                        onPressed: availableGrams >= 5.0 ? () => setState(() => _gramsToSell = 5.0) : null,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF6B4D36)),
                        ),
                        child: const Text('5.0g', style: TextStyle(color: Colors.white)),
                      ),
                      OutlinedButton(
                        onPressed: availableGrams > 0 ? () => setState(() => _gramsToSell = availableGrams) : null,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: GameTheme.gold),
                        ),
                        child: const Text('All In Vault', style: TextStyle(color: GameTheme.gold)),
                      ),
                    ],
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No dried saffron in vault. Dry harvested flowers in the Dryer room first.',
                      style: GameTheme.bodyStyle.copyWith(color: Colors.white54, fontSize: 13),
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // Total Earnings Preview
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF261B12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: GameTheme.goldDark),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order Total Payout:', style: GameTheme.bodyStyle.copyWith(fontSize: 12)),
                          Text(
                            '$totalEarnings VR Coins',
                            style: GameTheme.titleStyle.copyWith(
                              fontSize: 18,
                              color: GameTheme.gold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: availableGrams > 0 && effectiveGrams > 0
                            ? () {
                                final earnings = widget.controller.sellDriedSaffron(effectiveGrams);
                                if (earnings > 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('💰 Exported ${effectiveGrams.toStringAsFixed(1)}g for +$earnings VR Coins!'),
                                      backgroundColor: GameTheme.emeraldGreen,
                                    ),
                                  );
                                  setState(() {
                                    _gramsToSell = 1.0;
                                  });
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GameTheme.emeraldGreen,
                          disabledBackgroundColor: const Color(0xFF261D16),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'Confirm Sale',
                          style: GameTheme.badgeStyle.copyWith(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
