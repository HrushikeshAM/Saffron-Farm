import 'package:flutter/material.dart';
import '../models/drying_batch.dart';
import '../services/game_controller.dart';
import '../theme/game_theme.dart';

class DryingScreen extends StatefulWidget {
  final GameController controller;

  const DryingScreen({super.key, required this.controller});

  @override
  State<DryingScreen> createState() => _DryingScreenState();
}

class _DryingScreenState extends State<DryingScreen> {
  int _selectedFlowers = 5;

  String _getDryerAsset(DryerState state) {
    switch (state) {
      case DryerState.offEmpty:
        return 'assets/dryers/dryer_state_01_off_empty.png';
      case DryerState.preheating:
        return 'assets/dryers/dryer_state_02_preheating.png';
      case DryerState.dryingLow:
        return 'assets/dryers/dryer_state_03_drying_low.png';
      case DryerState.dryingHigh:
        return 'assets/dryers/dryer_state_04_drying_high.png';
      case DryerState.completed:
        return 'assets/dryers/dryer_state_05_completed.png';
      case DryerState.cooldownIdle:
        return 'assets/dryers/dryer_state_06_cooldown_idle.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;
    final freshCount = state.freshFlowers;
    final batches = state.dryingBatches;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: GameTheme.panelDecoration,
            child: Row(
              children: [
                Image.asset(
                  'assets/equipment/saffron_harvest_basket.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saffron Dehydration Chamber',
                        style: GameTheme.headingStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Fresh Harvest in Stock: $freshCount flowers',
                        style: GameTheme.bodyStyle.copyWith(
                          color: GameTheme.gold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Start New Batch Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: GameTheme.panelDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Load Fresh Saffron into Dehydrator',
                  style: GameTheme.headingStyle.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 8),
                Text(
                  'Controlled thermal dehydrating converts delicate fresh petals into high-potency red saffron filaments.',
                  style: GameTheme.bodyStyle.copyWith(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 14),

                // Quantity selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: GameTheme.gold),
                      onPressed: _selectedFlowers > 5
                          ? () => setState(() => _selectedFlowers -= 5)
                          : null,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B1D14),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF6B4D36)),
                      ),
                      child: Text(
                        '$_selectedFlowers Flowers (${(_selectedFlowers / 5).toStringAsFixed(1)}g Dried)',
                        style: GameTheme.headingStyle.copyWith(fontSize: 14),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: GameTheme.gold),
                      onPressed: _selectedFlowers + 5 <= freshCount
                          ? () => setState(() => _selectedFlowers += 5)
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Start button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: freshCount >= _selectedFlowers && _selectedFlowers > 0
                        ? () {
                            final ok = widget.controller.startDryingBatch(_selectedFlowers);
                            if (ok) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('🔥 Dehydrator cycle started! Watch temperature vents rise.'),
                                  backgroundColor: GameTheme.orangeGlow,
                                ),
                              );
                              setState(() {
                                _selectedFlowers = 5;
                              });
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: GameTheme.orangeGlow,
                      disabledBackgroundColor: const Color(0xFF261D16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      freshCount >= _selectedFlowers ? 'Start Dehydration Cycle' : 'Need More Fresh Flowers',
                      style: GameTheme.badgeStyle.copyWith(
                        color: freshCount >= _selectedFlowers ? Colors.white : Colors.white38,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Active Drying Units List
          Text(
            'Active Dehydrator Units (${batches.length})',
            style: GameTheme.headingStyle.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 8),

          if (batches.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: GameTheme.panelDecoration,
              child: Column(
                children: [
                  Image.asset(
                    'assets/dryers/dryer_state_01_off_empty.png',
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'All dehydration units are idle.\nHarvest fresh flowers to start a drying batch.',
                    style: GameTheme.bodyStyle.copyWith(color: Colors.white60, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...batches.map((batch) {
              final visual = batch.visualState;
              final isDone = batch.isDone;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: GameTheme.panelDecoration.copyWith(
                  border: Border.all(
                    color: isDone ? GameTheme.gold : const Color(0xFF6B4D36),
                    width: isDone ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      _getDryerAsset(visual),
                      width: 72,
                      height: 72,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isDone ? 'Cycle Complete!' : 'Dehydrating...',
                                style: GameTheme.headingStyle.copyWith(
                                  fontSize: 14,
                                  color: isDone ? GameTheme.gold : Colors.white,
                                ),
                              ),
                              Text(
                                isDone ? '00:00' : '${batch.remainingSeconds}s',
                                style: GameTheme.badgeStyle.copyWith(
                                  color: isDone ? GameTheme.emeraldGreen : GameTheme.amberGlow,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Yield: ${batch.driedGramsYield.toStringAsFixed(1)}g Pure Red Saffron',
                            style: GameTheme.bodyStyle.copyWith(fontSize: 12, color: const Color(0xFFFED7AA)),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: batch.progress,
                              minHeight: 6,
                              backgroundColor: Colors.black45,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDone ? GameTheme.emeraldGreen : GameTheme.orangeGlow,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (isDone)
                      ElevatedButton(
                        onPressed: () {
                          widget.controller.collectDryingBatch(batch.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('✨ Collected ${batch.driedGramsYield.toStringAsFixed(1)}g Dried Saffron!'),
                              backgroundColor: GameTheme.saffronPurple,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GameTheme.emeraldGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Collect',
                          style: GameTheme.badgeStyle.copyWith(fontSize: 11),
                        ),
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
