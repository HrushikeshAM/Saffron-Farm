import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../models/tray.dart';
import '../services/game_controller.dart';
import '../theme/game_theme.dart';

class TrayView extends StatefulWidget {
  final CultivationTray tray;
  final GameController controller;
  final ValueChanged<bool>? onSliderDrag;

  const TrayView({
    super.key,
    required this.tray,
    required this.controller,
    this.onSliderDrag,
  });

  @override
  State<TrayView> createState() => _TrayViewState();
}

class _TrayViewState extends State<TrayView> with SingleTickerProviderStateMixin {
  bool _isCanHovering = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.98, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleLight() {
    widget.controller.toggleTrayLight(widget.controller.activeTrayIndex);
  }

  void _updateIntensityFromDx(double dx, double trackWidth) {
    if (trackWidth <= 0) return;
    final clampedDx = dx.clamp(0.0, trackWidth);
    final fraction = (clampedDx / trackWidth).clamp(0.0, 1.0);
    widget.controller.setTrayIntensity(widget.controller.activeTrayIndex, fraction);
  }

  Widget _buildIntensitySlider(CultivationTray tray, GameController controller) {
    final intensity = tray.lightIntensity;
    final isLit = intensity > 0.05;
    final percent = (intensity * 100).round();

    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          final delta = -pointerSignal.scrollDelta.dy / 250.0;
          final newIntensity = (intensity + delta).clamp(0.0, 1.0);
          controller.setTrayIntensity(controller.activeTrayIndex, newIntensity);
        }
      },
      child: Container(
        width: 220,
        height: 22,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
        decoration: BoxDecoration(
          color: const Color(0xEE160F0B),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: isLit ? const Color(0x77F59E0B) : Colors.white12,
            width: 1.0,
          ),
          boxShadow: isLit
              ? const [
                  BoxShadow(color: Color(0x22F59E0B), blurRadius: 4, spreadRadius: 0.5),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Clickable sun/power icon to quick toggle
            GestureDetector(
              onTap: _toggleLight,
              child: Tooltip(
                message: isLit ? 'Click to turn OFF' : 'Click to turn ON',
                child: Icon(
                  isLit ? Icons.wb_sunny : Icons.power_settings_new,
                  size: 13,
                  color: isLit ? GameTheme.gold : Colors.white38,
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Text Label
            Text(
              isLit ? '$percent%' : 'OFF',
              style: GameTheme.badgeStyle.copyWith(
                fontSize: 9.0,
                color: isLit ? GameTheme.gold : Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5),

            // Minus button (-10%)
            GestureDetector(
              onTap: () {
                final newIntensity = (intensity - 0.1).clamp(0.0, 1.0);
                controller.setTrayIntensity(controller.activeTrayIndex, newIntensity);
              },
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A1C12),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 0.8),
                ),
                child: const Center(
                  child: Icon(Icons.remove, size: 10, color: GameTheme.gold),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Interactive draggable/scrollable slider track with touch lock
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final trackWidth = constraints.maxWidth;
                  return Listener(
                    behavior: HitTestBehavior.opaque,
                    onPointerDown: (e) {
                      widget.onSliderDrag?.call(true);
                      _updateIntensityFromDx(e.localPosition.dx, trackWidth);
                    },
                    onPointerMove: (e) {
                      _updateIntensityFromDx(e.localPosition.dx, trackWidth);
                    },
                    onPointerUp: (_) {
                      widget.onSliderDrag?.call(false);
                    },
                    onPointerCancel: (_) {
                      widget.onSliderDrag?.call(false);
                    },
                    child: SizedBox(
                      height: 16,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          // Background track
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(color: Colors.white10, width: 0.5),
                            ),
                          ),
                          // Filled progress
                          FractionallySizedBox(
                            widthFactor: intensity.clamp(0.0, 1.0),
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFD97706), Color(0xFFFBBF24)],
                                ),
                                borderRadius: BorderRadius.circular(3),
                                boxShadow: isLit
                                    ? const [
                                        BoxShadow(color: Color(0x88F59E0B), blurRadius: 4),
                                      ]
                                    : null,
                              ),
                            ),
                          ),
                          // Circular thumb handle
                          Positioned(
                            left: ((trackWidth - 9) * intensity).clamp(0.0, trackWidth - 9),
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isLit ? GameTheme.gold : Colors.grey,
                                border: Border.all(color: Colors.white, width: 1.2),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black54, blurRadius: 3),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 4),

            // Plus button (+10%)
            GestureDetector(
              onTap: () {
                final newIntensity = (intensity + 0.1).clamp(0.0, 1.0);
                controller.setTrayIntensity(controller.activeTrayIndex, newIntensity);
              },
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A1C12),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 0.8),
                ),
                child: const Center(
                  child: Icon(Icons.add, size: 10, color: GameTheme.gold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final tray = widget.tray;
        final controller = widget.controller;
        final state = controller.state;
        final isReady = tray.isReadyToHarvest;
        final isNeedsWater = tray.isNeedsWater;
        final remainingSec = controller.getTrayRemainingSeconds(tray);

        final intensity = tray.lightIntensity;
        // Brightness scale from 0.22 (completely dark/off) to 1.0 (full brightness)
        final brightness = 0.22 + (intensity * 0.78);

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
                    // ========================================================
                    // 1. INTERACTIVE INTENSITY BAR (DRAG / SCROLL / TAP)
                    // ========================================================
                    _buildIntensitySlider(tray, controller),

                    const SizedBox(height: 2),

                    // ========================================================
                    // 2. HANGING GROW LIGHT (INCREASED BY 20%: 348x115px)
                    // ========================================================
                    GestureDetector(
                      onTap: _toggleLight,
                      child: SizedBox(
                        width: 348,
                        height: 115,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.matrix([
                            brightness, 0, 0, 0, 0,
                            0, brightness, 0, 0, 0,
                            0, 0, brightness, 0, 0,
                            0, 0, 0, 1, 0,
                          ]),
                          child: Image.asset(
                            tray.currentGrowLightAsset,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    // Radiance light beam shining directly downward onto tray
                    SizedBox(
                      height: 10,
                      child: Opacity(
                        opacity: (intensity * 0.85).clamp(0.0, 1.0),
                        child: Container(
                          width: 312,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0x88EC4899),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ========================================================
                    // 3. THE 2.5D CULTIVATION TRAY (INCREASED BY 10%: 260x148px)
                    //    Directly receiving light from the lamp above
                    // ========================================================
                    DragTarget<String>(
                      onWillAcceptWithDetails: (details) {
                        if (details.data == 'watering_can') {
                          setState(() => _isCanHovering = true);
                          controller.setWateringOverTray(true);
                          return true;
                        }
                        return false;
                      },
                      onLeave: (_) {
                        setState(() => _isCanHovering = false);
                        controller.setWateringOverTray(false);
                      },
                      onAcceptWithDetails: (details) {
                        setState(() => _isCanHovering = false);
                        controller.setWateringOverTray(false);
                        if (details.data == 'watering_can') {
                          final success = controller.waterTray(controller.activeTrayIndex);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('💧 Watered ${tray.name}! Soil moisture restored to 100%.'),
                                backgroundColor: GameTheme.waterBlue,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('⚠️ Water reservoir empty! Tap water icon at top to refill.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                      },
                      builder: (context, candidateData, rejectedData) {
                        return SizedBox(
                          width: 260,
                          height: 148,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Direct 2.5D Composite Tray Artwork
                              ScaleTransition(
                                scale: isReady ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Image.asset(
                                    tray.stageImage,
                                    key: ValueKey(tray.stageImage),
                                    width: 260,
                                    height: 148,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),

                              // Hover Hydration Target Highlight (No duplicate can)
                              if (_isCanHovering)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xFF38BDF8), width: 2.5),
                                      gradient: const RadialGradient(
                                        colors: [
                                          Color(0x4438BDF8),
                                          Colors.transparent,
                                        ],
                                        radius: 0.8,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x6638BDF8),
                                          blurRadius: 16,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 5),

                    // ========================================================
                    // 4. STATUS & MOISTURE ROW (PLACED BELOW THE TRAY)
                    // ========================================================
                    SizedBox(
                      width: 310,
                      height: 24,
                      child: Row(
                        children: [
                          // Stage name badge
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xCC1A120B),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isReady ? GameTheme.gold : const Color(0x66FED7AA),
                                  width: 1.1,
                                ),
                              ),
                              child: Text(
                                '${tray.name} • ${tray.stageName}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GameTheme.headingStyle.copyWith(
                                  fontSize: 10,
                                  color: isReady ? GameTheme.gold : const Color(0xFFFED7AA),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 6),

                          // Moisture & status badge
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xCC1A120B),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isNeedsWater ? Colors.orangeAccent : const Color(0x6638BDF8),
                                  width: 1.1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/icons/icon_resource_water_drop.png', width: 11, height: 11),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      isNeedsWater
                                          ? '💧 ${tray.moisture.toInt()}% (Paused)'
                                          : '💧 ${tray.moisture.toInt()}% Moist',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GameTheme.badgeStyle.copyWith(
                                        fontSize: 9.5,
                                        color: isNeedsWater ? Colors.orangeAccent : GameTheme.waterBlueLight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    // ========================================================
                    // 5. ACTION BUTTON ROW (COMPACT FIXED 44px)
                    // ========================================================
                    SizedBox(
                      height: 44,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // --- Primary Action Button ---
                          if (tray.isEmpty)
                            GestureDetector(
                              onTap: () {
                                if (state.seedPackets <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('⚠️ No seed packets left! Purchase more in the Shop.'),
                                      backgroundColor: Colors.orangeAccent,
                                    ),
                                  );
                                  return;
                                }
                                final ok = controller.plantSelectedTray();
                                if (ok) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('🌱 Sowed 1 Seed Packet into ${tray.name}! All 25 corms planted.'),
                                      backgroundColor: GameTheme.emeraldGreen,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF059669), Color(0xFF10B981)],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white70, width: 1.2),
                                  boxShadow: const [
                                    BoxShadow(color: Color(0x88059669), blurRadius: 8, offset: Offset(0, 2)),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset('assets/icons/icon_saffron_corm_bulb.png', width: 18, height: 18),
                                    const SizedBox(width: 6),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'PLANT 25 CORMS',
                                          style: GameTheme.headingStyle.copyWith(fontSize: 11.5, color: Colors.white),
                                        ),
                                        Text(
                                          'Uses 1 Packet (${state.seedPackets} in stock)',
                                          style: GameTheme.bodyStyle.copyWith(fontSize: 8.5, color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (isReady)
                            GestureDetector(
                              onTap: () {
                                final count = controller.harvestSelectedTray();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('🌸 Harvested $count saffron blossoms from ${tray.name}!'),
                                    backgroundColor: GameTheme.saffronPurple,
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white, width: 1.5),
                                  boxShadow: const [
                                    BoxShadow(color: Color(0xAA000000), blurRadius: 8, offset: Offset(0, 3)),
                                    BoxShadow(color: Color(0x88F59E0B), blurRadius: 10, spreadRadius: 1),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset('assets/icons/icon_saffron_flower.png', width: 18, height: 18),
                                    const SizedBox(width: 6),
                                    Text(
                                      'HARVEST 25 BLOSSOMS',
                                      style: GameTheme.headingStyle.copyWith(fontSize: 11.5, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xCC1A120B),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isNeedsWater ? Colors.orangeAccent : GameTheme.emeraldGreen,
                                  width: 1.1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isNeedsWater ? Icons.warning_amber : Icons.eco,
                                    size: 13,
                                    color: isNeedsWater ? Colors.orangeAccent : GameTheme.emeraldGreen,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    isNeedsWater ? 'Growth Paused: Needs Water' : 'Crops Thriving (${remainingSec}s)',
                                    style: GameTheme.badgeStyle.copyWith(
                                      fontSize: 9.5,
                                      color: isNeedsWater ? Colors.orangeAccent : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(width: 10),

                          // --- Draggable Watering Can Tool ---
                          Draggable<String>(
                            data: 'watering_can',
                            feedback: Material(
                              color: Colors.transparent,
                              child: Transform.rotate(
                                angle: -0.25,
                                child: Image.asset(
                                  'assets/watering_can/watering_can_anim_03_spray.png',
                                  width: 56,
                                  height: 56,
                                ),
                              ),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.35,
                              child: Image.asset(
                                'assets/watering_can/watering_can_anim_01_idle.png',
                                width: 38,
                                height: 38,
                              ),
                            ),
                            child: Tooltip(
                              message: 'Tap or drag over tray to water',
                              child: GestureDetector(
                                onTap: () {
                                  final success = controller.waterTray(controller.activeTrayIndex);
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('💧 Watered ${tray.name}! Soil moisture restored to 100%.'),
                                        backgroundColor: GameTheme.waterBlue,
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('⚠️ Water reservoir empty! Tap water icon at top to refill.'),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xCC1A120B),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isNeedsWater ? Colors.orangeAccent : const Color(0x8838BDF8),
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isNeedsWater ? const Color(0x66F97316) : Colors.black45,
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'assets/watering_can/watering_can_anim_01_idle.png',
                                    width: 36,
                                    height: 36,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
