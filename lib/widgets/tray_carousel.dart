import 'package:flutter/material.dart';
import '../services/game_controller.dart';
import '../theme/game_theme.dart';
import 'plus_tray_card.dart';
import 'tray_view.dart';

class TrayCarousel extends StatefulWidget {
  final GameController controller;

  const TrayCarousel({super.key, required this.controller});

  @override
  State<TrayCarousel> createState() => _TrayCarouselState();
}

class _TrayCarouselState extends State<TrayCarousel> {
  late PageController _pageController;
  bool _isSliderDragging = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.controller.activeTrayIndex);
  }

  @override
  void didUpdateWidget(TrayCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_pageController.hasClients &&
        _pageController.page?.round() != widget.controller.activeTrayIndex) {
      _pageController.animateToPage(
        widget.controller.activeTrayIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPrevious() {
    if (_pageController.hasClients && _pageController.page! > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    final totalPages = widget.controller.state.trays.length + 1;
    if (_pageController.hasClients && _pageController.page! < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;
    final totalTrays = state.trays.length;
    final totalPages = totalTrays + 1; // Unlocked trays + the Plus Tray card

    final currentIndex = widget.controller.activeTrayIndex.clamp(0, totalPages - 1);
    final isPlusPage = currentIndex == totalTrays;

    return Column(
      children: [
        // --- Tray Navigation Header ---
        Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, top: 36, bottom: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Arrow
              GestureDetector(
                onTap: currentIndex > 0 ? _goToPrevious : null,
                child: Opacity(
                  opacity: currentIndex > 0 ? 1.0 : 0.35,
                  child: Image.asset(
                    'assets/ui_buttons/btn_navigation_left.png',
                    width: 30,
                    height: 30,
                    errorBuilder: (_, __, ___) => const Icon(Icons.arrow_circle_left, color: GameTheme.gold, size: 28),
                  ),
                ),
              ),

              // Tray Indicator & Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xEE2A1D14),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isPlusPage ? GameTheme.gold : const Color(0xFF6A4528),
                    width: 1.2,
                  ),
                  boxShadow: const [
                    BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 1)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isPlusPage ? 'Unlock Tray #${totalTrays + 1} (+)' : 'Tray ${currentIndex + 1} of $totalTrays',
                      style: GameTheme.headingStyle.copyWith(
                        fontSize: 12.5,
                        color: isPlusPage ? GameTheme.gold : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Mini dot indicators
                    Row(
                      children: List.generate(totalPages, (i) {
                        final isActive = i == currentIndex;
                        final isPlusDot = i == totalTrays;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                          width: isActive ? 8 : 5,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.5),
                            color: isActive
                                ? (isPlusDot ? GameTheme.gold : GameTheme.emeraldGreen)
                                : Colors.white24,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // Right Arrow
              GestureDetector(
                onTap: currentIndex < totalPages - 1 ? _goToNext : null,
                child: Opacity(
                  opacity: currentIndex < totalPages - 1 ? 1.0 : 0.35,
                  child: Image.asset(
                    'assets/ui_buttons/btn_navigation_right.png',
                    width: 30,
                    height: 30,
                    errorBuilder: (_, __, ___) => const Icon(Icons.arrow_circle_right, color: GameTheme.gold, size: 28),
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- Snapping PageView Carousel ---
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: _isSliderDragging
                ? const NeverScrollableScrollPhysics()
                : const PageScrollPhysics(),
            itemCount: totalPages,
            onPageChanged: (index) {
              widget.controller.setActiveTray(index);
            },
            itemBuilder: (context, index) {
              if (index < totalTrays) {
                return TrayView(
                  tray: state.trays[index],
                  controller: widget.controller,
                  onSliderDrag: (dragging) {
                    if (_isSliderDragging != dragging) {
                      setState(() => _isSliderDragging = dragging);
                    }
                  },
                );
              } else {
                return PlusTrayCard(controller: widget.controller);
              }
            },
          ),
        ),
      ],
    );
  }
}
