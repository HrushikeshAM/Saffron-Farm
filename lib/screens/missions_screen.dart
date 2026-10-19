import 'package:flutter/material.dart';
import '../services/game_controller.dart';
import '../theme/game_theme.dart';

class MissionsScreen extends StatelessWidget {
  final GameController controller;

  const MissionsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final missions = controller.state.missions;

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
                  'assets/ui_buttons/btn_quests_tasks.png',
                  width: 48,
                  height: 48,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agronomist Milestones',
                        style: GameTheme.headingStyle.copyWith(fontSize: 16),
                      ),
                      Text(
                        'Complete agricultural goals to earn VR Coins and prestige',
                        style: GameTheme.bodyStyle.copyWith(fontSize: 11, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          ...missions.map((mission) {
            final isDone = mission.isCompleted;
            final isClaimed = mission.isClaimed;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: GameTheme.panelDecoration.copyWith(
                border: Border.all(
                  color: isDone && !isClaimed ? GameTheme.gold : const Color(0xFF5A3C26),
                  width: isDone && !isClaimed ? 2.0 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  // Icon
                  Image.asset(
                    isDone
                        ? 'assets/icons/icon_status_checkmark.png'
                        : 'assets/icons/icon_timer_stopwatch.png',
                    width: 36,
                    height: 36,
                    errorBuilder: (_, __, ___) => Icon(
                      isDone ? Icons.check_circle : Icons.pending,
                      color: isDone ? GameTheme.emeraldGreen : Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mission.title,
                          style: GameTheme.headingStyle.copyWith(
                            fontSize: 14,
                            color: isDone ? Colors.white : const Color(0xFFFED7AA),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          mission.description,
                          style: GameTheme.bodyStyle.copyWith(color: Colors.white70, fontSize: 11),
                        ),
                        const SizedBox(height: 6),
                        // Progress bar
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: mission.progressFraction,
                                  minHeight: 5,
                                  backgroundColor: Colors.black54,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDone ? GameTheme.emeraldGreen : GameTheme.amberGlow,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${mission.currentProgress} / ${mission.targetCount}',
                              style: GameTheme.badgeStyle.copyWith(fontSize: 10, color: Colors.white60),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Rewards preview
                        Row(
                          children: [
                            Image.asset('assets/icons/icon_currency_gold_coin.png', width: 14, height: 14),
                            const SizedBox(width: 3),
                            Text('+${mission.rewardCoins}', style: const TextStyle(color: GameTheme.gold, fontSize: 11, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 10),
                            Image.asset('assets/icons/icon_rating_star.png', width: 14, height: 14),
                            const SizedBox(width: 3),
                            Text('+${mission.rewardXp} XP', style: const TextStyle(color: Colors.amberAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Claim button
                  if (isDone && !isClaimed)
                    ElevatedButton(
                      onPressed: () {
                        controller.claimMissionReward(mission.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('⭐ Claimed +${mission.rewardCoins} Coins & +${mission.rewardXp} XP!'),
                            backgroundColor: GameTheme.emeraldGreen,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GameTheme.goldDark,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Claim', style: GameTheme.badgeStyle.copyWith(color: Colors.black, fontSize: 11)),
                    )
                  else if (isClaimed)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22543D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Claimed', style: GameTheme.badgeStyle.copyWith(fontSize: 10)),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B1D14),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Active', style: GameTheme.badgeStyle.copyWith(fontSize: 10, color: Colors.white38)),
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
