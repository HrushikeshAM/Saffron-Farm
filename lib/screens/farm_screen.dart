import 'package:flutter/material.dart';
import '../services/game_controller.dart';
import '../theme/game_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/top_bar.dart';
import '../widgets/tray_carousel.dart';
import 'drying_screen.dart';
import 'expansion_screen.dart';
import 'inventory_screen.dart';
import 'missions_screen.dart';
import 'selling_screen.dart';
import 'settings_dialog.dart';
import 'shop_screen.dart';
import 'tutorial_overlay.dart';

class FarmScreen extends StatefulWidget {
  final GameController controller;

  const FarmScreen({super.key, required this.controller});

  @override
  State<FarmScreen> createState() => _FarmScreenState();
}

class _FarmScreenState extends State<FarmScreen> {
  GameScreenTab _currentTab = GameScreenTab.farm;

  void _openSettings() {
    showDialog(
      context: context,
      builder: (ctx) => SettingsDialog(controller: widget.controller),
    );
  }

  void _openExpansionsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Color(0xF518120D),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: GameTheme.gold, width: 2)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Greenhouse Facility Expansion', style: GameTheme.titleStyle.copyWith(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ExpansionScreen(controller: widget.controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentTab) {
      case GameScreenTab.farm:
        return Column(
          children: [
            TutorialOverlay(controller: widget.controller),
            Expanded(
              child: TrayCarousel(controller: widget.controller),
            ),
          ],
        );
      case GameScreenTab.dryer:
        return DryingScreen(controller: widget.controller);
      case GameScreenTab.sell:
        return SellingScreen(controller: widget.controller);
      case GameScreenTab.shop:
        return ShopScreen(controller: widget.controller);
      case GameScreenTab.missions:
        return MissionsScreen(controller: widget.controller);
      case GameScreenTab.inventory:
        return InventoryScreen(controller: widget.controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameTheme.woodDark,
      endDrawer: Drawer(
        backgroundColor: const Color(0xF51C140E),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFF5D3A24), width: 1.5)),
                ),
                child: Column(
                  children: [
                    Image.asset('assets/icons/banner_axiomgreen_title.png', height: 40),
                    const SizedBox(height: 6),
                    Text(
                      'Saffron Farming Simulator',
                      style: GameTheme.headingStyle.copyWith(fontSize: 14, color: GameTheme.gold),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Image.asset('assets/ui_buttons/btn_greenhouse_facility.png', width: 28, height: 28),
                title: const Text('Farm HQ', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() => _currentTab = GameScreenTab.farm);
                },
              ),
              ListTile(
                leading: Image.asset('assets/ui_buttons/btn_status_locked.png', width: 28, height: 28),
                title: const Text('Facility Expansions', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop();
                  _openExpansionsModal();
                },
              ),
              ListTile(
                leading: Image.asset('assets/ui_buttons/btn_settings_options.png', width: 28, height: 28),
                title: const Text('Settings & Guide', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop();
                  _openSettings();
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'AxiomGreen Saffron Farm\nVersion 1.0.0 (Production 2.5D Engine)',
                  style: GameTheme.bodyStyle.copyWith(color: Colors.white38, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background greenhouse image
          Image.asset(
            'assets/backgrounds/background_greenhouse_interior.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: GameTheme.woodDark),
          ),
          // Subtle top/bottom vignette so warm wooden greenhouse background is vibrant
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x880D0907),
                  Color(0x15000000),
                  Color(0x990D0907),
                ],
              ),
            ),
          ),
          // Content Layout
          Column(
            children: [
              TopBar(
                controller: widget.controller,
                onOpenSettings: _openSettings,
                onOpenMenu: () => Scaffold.of(context).openEndDrawer(),
              ),
              Expanded(
                child: _buildBody(),
              ),
              BottomNav(
                currentTab: _currentTab,
                onSelectTab: (tab) => setState(() => _currentTab = tab),
                controller: widget.controller,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
