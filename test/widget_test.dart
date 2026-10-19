import 'package:flutter_test/flutter_test.dart';
import 'package:saffron_farm/models/crop_slot.dart';
import 'package:saffron_farm/models/game_state.dart';
import 'package:saffron_farm/services/game_controller.dart';
import 'package:saffron_farm/services/audio_service.dart';
import 'package:saffron_farm/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AudioService.enableAudio = false;

  group('AxiomGreen Saffron Farm Core Systems', () {
    test('Starting State: Exactly 5 Free, Empty Trays', () {
      final state = GameState();

      // Exactly 5 starting trays
      expect(state.trays.length, equals(5));

      // All 5 trays MUST initially be empty (Stage 1: Soil)
      for (final tray in state.trays) {
        expect(tray.stage, equals(CropStage.empty));
        expect(tray.plantCount, equals(25));
        expect(tray.isPlanted, isFalse);
        expect(tray.currentAssetStage, equals('assets/cultivation_trays/tray_stage_01_soil.png'));
      }

      // Starts with 5 seed packets (each plants 25 plants)
      expect(state.seedPackets, equals(5));

      // Currency
      expect(state.coins, equals(500));

      // Level 1
      expect(state.level, equals(1));

      // Next unlock cost for Tray 6
      expect(state.nextTrayUnlockCost, equals(250));
    });

    test('1 Seed Packet Plants All 25 Plants in One Action', () {
      final controller = GameController(
        initialState: GameState(coins: 500, seedPackets: 5),
      );

      expect(controller.state.seedPackets, equals(5));
      expect(controller.currentTray.isPlanted, isFalse);
      expect(controller.currentTray.stage, equals(CropStage.empty));

      // Plant tray 0: consumes exactly 1 packet, sets all 25 plants to planted
      final success = controller.plantTray(0);
      expect(success, isTrue);
      expect(controller.state.seedPackets, equals(4));
      expect(controller.currentTray.stage, equals(CropStage.planted));
      expect(controller.currentTray.isPlanted, isTrue);
      expect(controller.currentTray.currentAssetStage, equals('assets/cultivation_trays/tray_stage_02_bulbs.png'));

      // Cannot plant in already planted tray
      final secondTry = controller.plantTray(0);
      expect(secondTry, isFalse);
      expect(controller.state.seedPackets, equals(4));
    });

    test('Watering and Moisture System with Draggable Trigger', () {
      final controller = GameController(
        initialState: GameState(waterLevel: 100.0, maxWaterLevel: 100.0),
      );
      controller.currentTray.moisture = 20.0;

      // Simulate dragging over tray
      controller.setWateringOverTray(true);
      expect(controller.isWateringOverTray, isTrue);

      // Apply water
      final success = controller.waterTray(0);
      expect(success, isTrue);
      expect(controller.currentTray.moisture, equals(100.0));
      expect(controller.state.waterLevel, equals(80.0)); // consumed 20L

      controller.setWateringOverTray(false);
      expect(controller.isWateringOverTray, isFalse);

      // Refill tank
      controller.refillWater();
      expect(controller.state.waterLevel, equals(100.0));
    });

    test('Lighting Controls: ON (Stage 3) and OFF (Stage 2)', () {
      final controller = GameController();
      // Starts ON (Stage 3: Bright Glow)
      expect(controller.currentTray.isLightOn, isTrue);
      expect(controller.currentTray.currentGrowLightAsset, equals('assets/grow_lights/grow_light_stage_03_bright_glow.png'));

      // Toggle to OFF (Stage 2: Medium)
      controller.toggleTrayLight(0);
      expect(controller.currentTray.isLightOn, isFalse);
      expect(controller.currentTray.currentGrowLightAsset, equals('assets/grow_lights/grow_light_stage_02_medium.png'));

      // Toggle back to ON (Stage 3: Bright Glow)
      controller.toggleTrayLight(0);
      expect(controller.currentTray.isLightOn, isTrue);
      expect(controller.currentTray.currentGrowLightAsset, equals('assets/grow_lights/grow_light_stage_03_bright_glow.png'));
    });

    test('Harvesting Blooming Tray Yields 25 Saffron Blossoms', () {
      final controller = GameController();
      final tray = controller.currentTray;
      tray.stage = CropStage.flowering;

      expect(tray.isReadyToHarvest, isTrue);
      expect(tray.currentAssetStage, equals('assets/cultivation_trays/tray_stage_06_bloom.png'));
      expect(controller.state.freshFlowers, equals(0));

      final yieldAmount = controller.harvestTray(0);
      expect(yieldAmount, equals(25)); // 25 blooming plants
      expect(controller.state.freshFlowers, equals(25));
      expect(tray.stage, equals(CropStage.empty)); // Resets to empty soil
      expect(tray.currentAssetStage, equals('assets/cultivation_trays/tray_stage_01_soil.png'));
    });

    test('Dryer States, Processing Timers, and Yields', () {
      final controller = GameController(
        initialState: GameState(freshFlowers: 25),
      );

      final started = controller.startDryingBatch(25);
      expect(started, isTrue);
      expect(controller.state.freshFlowers, equals(0));
      expect(controller.state.dryingBatches.length, equals(1));

      final batch = controller.state.dryingBatches.first;
      expect(batch.freshFlowersCount, equals(25));
      expect(batch.driedGramsYield, equals(5.0)); // 25 / 5 = 5.0g
    });

    test('Selling Counter and Economy', () {
      final controller = GameController(
        initialState: GameState(coins: 500, driedGrams: 5.0),
      );

      final earnings = controller.sellDriedSaffron(2.0);
      expect(earnings, equals(50)); // 2g * 25 coins
      expect(controller.state.coins, equals(550));
      expect(controller.state.driedGrams, equals(3.0));
    });

    test('Plus-Tray Expansion with In-Game Currency', () {
      final controller = GameController(
        initialState: GameState(coins: 600),
      );

      expect(controller.state.trays.length, equals(5));
      expect(controller.state.nextTrayUnlockCost, equals(250));

      // Unlock Tray #6
      final unlocked = controller.unlockNextTray();
      expect(unlocked, isTrue);
      expect(controller.state.trays.length, equals(6));
      expect(controller.state.coins, equals(350));
      expect(controller.state.trays.last.name, equals('Tray #6'));
      expect(controller.state.trays.last.stage, equals(CropStage.empty));

      // Next cost scales for Tray #7
      expect(controller.state.nextTrayUnlockCost, equals(450));
    });

    testWidgets('App Launches and displays StartScreen', (WidgetTester tester) async {
      final controller = GameController();
      await tester.pumpWidget(SaffronFarmApp(controller: controller));
      await tester.pump();

      expect(find.text('SAFFRON FARMING SIMULATOR'), findsOneWidget);
      expect(find.text('START FARMING'), findsOneWidget);

      controller.dispose();
    });
  });
}
