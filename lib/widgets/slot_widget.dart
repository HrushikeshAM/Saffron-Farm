import 'package:flutter/material.dart';
import '../models/crop_slot.dart';
import '../theme/game_theme.dart';

class SlotWidget extends StatefulWidget {
  final CropSlot slot;
  final VoidCallback onTap;

  const SlotWidget({
    super.key,
    required this.slot,
    required this.onTap,
  });

  @override
  State<SlotWidget> createState() => _SlotWidgetState();
}

class _SlotWidgetState extends State<SlotWidget> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Widget _buildCropGraphic(CropStage stage) {
    switch (stage) {
      case CropStage.empty:
      case CropStage.harvested:
        return Center(
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.12),
            ),
            child: const Icon(Icons.add, size: 10, color: Color(0x66FFFFFF)),
          ),
        );
      case CropStage.planted:
        return Image.asset(
          'assets/crops/saffron_stage_01.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/icons/icon_saffron_corm_bulb.png',
            fit: BoxFit.contain,
          ),
        );
      case CropStage.sprouting:
        return Image.asset(
          'assets/crops/saffron_stage_02.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(Icons.grass, color: Colors.lightGreenAccent, size: 24),
        );
      case CropStage.growing:
        return Image.asset(
          'assets/crops/saffron_stage_03.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(Icons.eco, color: Colors.green, size: 28),
        );
      case CropStage.mature:
        return Image.asset(
          'assets/crops/saffron_stage_04.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(Icons.forest, color: Colors.greenAccent, size: 30),
        );
      case CropStage.flowering:
        return ScaleTransition(
          scale: _glowAnimation,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x99F59E0B),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/icons/icon_saffron_flower.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Image.asset(
                  'assets/crops/saffron_stage_05.png',
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                bottom: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: GameTheme.gold,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'HARVEST',
                    style: GameTheme.badgeStyle.copyWith(
                      fontSize: 8,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stage = widget.slot.stage;
    final isReady = widget.slot.isReadyToHarvest;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xCC2A1C12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isReady
                ? GameTheme.gold
                : (stage == CropStage.empty ? const Color(0x448B5A36) : const Color(0xFF6A4528)),
            width: isReady ? 2.0 : 1.0,
          ),
          boxShadow: isReady
              ? const [
                  BoxShadow(
                    color: Color(0x66F59E0B),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ]
              : const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
        ),
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: _buildCropGraphic(stage),
        ),
      ),
    );
  }
}
