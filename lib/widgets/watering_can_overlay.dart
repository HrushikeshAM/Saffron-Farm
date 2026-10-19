import 'package:flutter/material.dart';

class WateringCanOverlay extends StatefulWidget {
  final bool isActive;

  const WateringCanOverlay({super.key, required this.isActive});

  @override
  State<WateringCanOverlay> createState() => _WateringCanOverlayState();
}

class _WateringCanOverlayState extends State<WateringCanOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int _currentFrame = 1;

  final List<String> _frames = [
    'assets/watering_can/watering_can_anim_01_idle.png',
    'assets/watering_can/watering_can_anim_02_tilt.png',
    'assets/watering_can/watering_can_anim_03_spray.png',
    'assets/watering_can/watering_can_anim_04_stream.png',
    'assets/watering_can/watering_can_anim_05_drip.png',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..addListener(() {
        final frameIndex = (_animController.value * (_frames.length - 1)).round();
        if (frameIndex != _currentFrame) {
          setState(() {
            _currentFrame = frameIndex;
          });
        }
      });
  }

  @override
  void didUpdateWidget(WateringCanOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) return const SizedBox.shrink();

    return IgnorePointer(
      child: Center(
        child: SizedBox(
          width: 220,
          height: 220,
          child: Image.asset(
            _frames[_currentFrame.clamp(0, _frames.length - 1)],
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
