import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/crop_slot.dart';
import '../models/drying_batch.dart';
import '../models/game_state.dart';
import '../models/tray.dart';
import 'audio_service.dart';
import 'storage_service.dart';

class GameController extends ChangeNotifier {
  late GameState state;
  final AudioService _audio = AudioService();
  Timer? _ticker;
  int _activeTrayIndex = 0;
  bool isWateringOverTray = false;

  int get activeTrayIndex => _activeTrayIndex;
  CultivationTray get currentTray =>
      state.trays.isNotEmpty ? state.trays[_activeTrayIndex.clamp(0, state.trays.length - 1)] : state.trays.first;

  GameController({GameState? initialState}) {
    state = initialState ?? GameState();
    _init();
  }

  Future<void> _init() async {
    await _audio.init();
    _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void setActiveTray(int index) {
    if (index >= 0 && index <= state.trays.length) {
      _activeTrayIndex = index;
      notifyListeners();
    }
  }

  int getTrayRequiredDurationSec(CultivationTray tray) {
    final baseStageSec = state.isFastGrowthMode ? 4 : 20;
    double lightMultiplier = 1.0;
    if (tray.lightLevel == 1) lightMultiplier = 0.8;
    if (tray.lightLevel == 2) lightMultiplier = 1.0;
    if (tray.lightLevel == 3) lightMultiplier = 1.25;
    if (tray.lightLevel == 4) lightMultiplier = 1.5;

    if (state.purchasedUpgrades.contains('full_spectrum_led')) {
      lightMultiplier *= 1.2;
    }

    return (baseStageSec / lightMultiplier).round().clamp(2, 100);
  }

  int getTrayElapsedSeconds(CultivationTray tray) {
    if (tray.stageStartedAt == null) return 0;
    return DateTime.now().difference(tray.stageStartedAt!).inSeconds;
  }

  int getTrayRemainingSeconds(CultivationTray tray) {
    if (!tray.isGrowing) return 0;
    final req = getTrayRequiredDurationSec(tray);
    final el = getTrayElapsedSeconds(tray);
    final rem = req - el;
    return rem < 0 ? 0 : rem;
  }

  double getTrayProgressFraction(CultivationTray tray) {
    if (tray.isReadyToHarvest) return 1.0;
    if (!tray.isGrowing) return 0.0;
    final req = getTrayRequiredDurationSec(tray);
    final el = getTrayElapsedSeconds(tray);
    return (el / req).clamp(0.0, 1.0);
  }

  void _tick() {
    final now = DateTime.now();
    bool stateChanged = false;

    for (final tray in state.trays) {
      // Natural moisture evaporation
      if (tray.moisture > 0) {
        final evapRate = state.purchasedUpgrades.contains('auto_irrigation') ? 0.05 : 0.15;
        tray.moisture = (tray.moisture - evapRate).clamp(0.0, 100.0);
        if (state.purchasedUpgrades.contains('auto_irrigation') && tray.moisture < 60) {
          tray.moisture = 80.0;
        }
      }

      // Check if growing and has moisture
      if (tray.isGrowing && tray.stageStartedAt != null) {
        // Growth pauses when soil is dry (< 25% moisture)
        if (!tray.isNeedsWater) {
          final requiredDuration = getTrayRequiredDurationSec(tray);
          final elapsed = now.difference(tray.stageStartedAt!).inSeconds;

          if (elapsed >= requiredDuration) {
            tray.stageStartedAt = now;
            final nextStageIndex = tray.stage.index + 1;
            if (nextStageIndex < CropStage.values.length - 1) {
              tray.stage = CropStage.values[nextStageIndex];
              stateChanged = true;
            } else {
              tray.stage = CropStage.flowering; // Ready for harvest!
              stateChanged = true;
            }
          }
        }
      }
    }

    // Auto check finished drying batches
    for (final batch in state.dryingBatches) {
      if (batch.isDone && !batch.isCollected) {
        stateChanged = true;
      }
    }

    // Auto-save periodically
    if (now.second % 10 == 0) {
      StorageService.saveGame(state);
    }

    if (stateChanged) {
      notifyListeners();
    }
  }

  // --- Planting: 1 Packet plants all 25 plants in selected tray ---
  bool plantSelectedTray() {
    return plantTray(_activeTrayIndex);
  }

  bool plantTray(int trayIndex) {
    if (trayIndex < 0 || trayIndex >= state.trays.length) return false;
    final tray = state.trays[trayIndex];

    if (!tray.isEmpty) return false;

    if (state.seedPackets > 0) {
      state.seedPackets--;
    } else if (state.coins >= 50) {
      // Auto-purchase seed packet for 50 coins
      state.coins -= 50;
    } else {
      return false;
    }

    final now = DateTime.now();
    tray.stage = CropStage.planted;
    tray.plantedAt = now;
    tray.stageStartedAt = now;

    _audio.playPlant();
    _incrementMission('mission_plant_first', 1);
    _incrementMission('mission_plant_ten', 1);

    if (state.tutorialStep == 1) {
      state.tutorialStep = 2; // Prompt to water
    }

    notifyListeners();
    StorageService.saveGame(state);
    return true;
  }

  // --- Watering: Applied via drag or action ---
  void setWateringOverTray(bool isOver) {
    if (isWateringOverTray != isOver) {
      isWateringOverTray = isOver;
      notifyListeners();
    }
  }

  bool waterSelectedTray() {
    return waterTray(_activeTrayIndex);
  }

  bool waterTray(int trayIndex) {
    if (trayIndex < 0 || trayIndex >= state.trays.length) return false;
    final tray = state.trays[trayIndex];

    const waterCost = 20.0;
    if (state.waterLevel < waterCost) {
      return false;
    }

    state.waterLevel = (state.waterLevel - waterCost).clamp(0.0, state.maxWaterLevel);
    tray.moisture = 100.0;
    tray.lastWateredAt = DateTime.now();

    _audio.playWater();
    _incrementMission('mission_water_tray', 1);

    if (state.tutorialStep == 2) {
      state.tutorialStep = 3; // Prompt to adjust lighting
    }

    notifyListeners();
    StorageService.saveGame(state);
    return true;
  }

  void refillWater() {
    state.waterLevel = state.maxWaterLevel;
    _audio.playWater();
    notifyListeners();
    StorageService.saveGame(state);
  }

  // --- Lighting (Intensity & Toggle) ---
  void toggleTrayLight(int trayIndex) {
    if (trayIndex < 0 || trayIndex >= state.trays.length) return;
    final tray = state.trays[trayIndex];
    if (tray.lightIntensity > 0.05) {
      tray.setIntensity(0.0);
    } else {
      tray.setIntensity(1.0);
    }
    _audio.playClick();
    _incrementMission('mission_adjust_light', 1);

    if (state.tutorialStep == 3) {
      state.tutorialStep = 4;
    }

    notifyListeners();
    StorageService.saveGame(state);
  }

  void setTrayIntensity(int trayIndex, double intensity) {
    if (trayIndex < 0 || trayIndex >= state.trays.length) return;
    final tray = state.trays[trayIndex];
    tray.setIntensity(intensity);

    if (intensity >= 0.5) {
      _incrementMission('mission_adjust_light', 1);
    }

    if (state.tutorialStep == 3 && intensity >= 0.3) {
      state.tutorialStep = 4;
    }

    notifyListeners();
    StorageService.saveGame(state);
  }

  void setTrayLightLevel(int trayIndex, int level) {
    if (trayIndex < 0 || trayIndex >= state.trays.length) return;
    state.trays[trayIndex].lightLevel = level.clamp(1, 4);
    state.trays[trayIndex].lightIntensity = (level / 4.0).clamp(0.0, 1.0);
    _audio.playClick();

    if (level >= 3) {
      _incrementMission('mission_adjust_light', 1);
    }

    if (state.tutorialStep == 3) {
      state.tutorialStep = 4; // Prompt to wait / harvest
    }

    notifyListeners();
    StorageService.saveGame(state);
  }

  // --- Harvesting: Harvests all 25 blooming plants from tray ---
  int harvestSelectedTray() {
    return harvestTray(_activeTrayIndex);
  }

  int harvestTray(int trayIndex) {
    if (trayIndex < 0 || trayIndex >= state.trays.length) return 0;
    final tray = state.trays[trayIndex];

    if (!tray.isReadyToHarvest) return 0;

    const yieldAmount = 25; // 25 fresh blossoms from the 25 plants in tray!
    state.freshFlowers += yieldAmount;
    addXp(35);

    // Reset tray to empty soil ready for next planting cycle
    tray.stage = CropStage.empty;
    tray.plantedAt = null;
    tray.stageStartedAt = null;

    _audio.playHarvest();
    _incrementMission('mission_harvest_flowers', 25);

    if (state.tutorialStep == 4) {
      state.tutorialStep = 5; // Prompt to visit Dryer
    }

    notifyListeners();
    StorageService.saveGame(state);
    return yieldAmount;
  }

  // --- Drying Room ---
  bool startDryingBatch(int flowersCount) {
    if (state.freshFlowers < flowersCount || flowersCount <= 0) return false;

    state.freshFlowers -= flowersCount;
    final duration = state.purchasedUpgrades.contains('turbo_dryer') ? 10 : 20;

    final batch = DryingBatch(
      id: 'batch_${DateTime.now().millisecondsSinceEpoch}',
      freshFlowersCount: flowersCount,
      startedAt: DateTime.now(),
      durationSeconds: state.isFastGrowthMode ? 4 : duration,
    );

    state.dryingBatches.insert(0, batch);
    _audio.playClick();
    _incrementMission('mission_dry_batch', 1);

    if (state.tutorialStep == 5) {
      state.tutorialStep = 6; // Prompt to visit Market
    }

    notifyListeners();
    StorageService.saveGame(state);
    return true;
  }

  bool collectDryingBatch(String batchId) {
    final batchIndex = state.dryingBatches.indexWhere((b) => b.id == batchId);
    if (batchIndex == -1) return false;

    final batch = state.dryingBatches[batchIndex];
    if (!batch.isDone) return false;

    final yieldGrams = batch.driedGramsYield;
    state.driedGrams += yieldGrams;
    addXp(25);
    batch.isCollected = true;
    state.dryingBatches.removeAt(batchIndex);

    _audio.playReward();
    notifyListeners();
    StorageService.saveGame(state);
    return true;
  }

  // --- Selling Counter ---
  int sellDriedSaffron(double grams) {
    if (state.driedGrams < grams || grams <= 0) return 0;

    state.driedGrams = (state.driedGrams - grams).clamp(0.0, 999999.0);
    final pricePerGram = state.purchasedUpgrades.contains('luxury_packaging') ? 32 : 25;
    final earnings = (grams * pricePerGram).round();

    state.coins += earnings;
    addXp(earnings ~/ 2);

    _audio.playPurchase();
    _incrementMission('mission_sell_saffron', 1);

    if (state.tutorialStep == 6) {
      state.tutorialStep = 7; // Prompt to expand / unlock tray
    }

    notifyListeners();
    StorageService.saveGame(state);
    return earnings;
  }

  // --- Unlock Plus Tray ---
  bool unlockNextTray() {
    final cost = state.nextTrayUnlockCost;
    if (state.coins < cost) return false;

    state.coins -= cost;
    final nextId = state.trays.length + 1;
    final newTray = CultivationTray(
      id: nextId,
      name: 'Tray #$nextId',
      stage: CropStage.empty, // Starts empty!
      moisture: 30.0,
      lightLevel: 3,
    );

    state.trays.add(newTray);
    addXp(60);
    _audio.playReward();
    _incrementMission('mission_buy_tray', 1);

    if (state.tutorialStep == 7) {
      state.tutorialStep = 8;
      state.tutorialCompleted = true;
    }

    // Snap to the newly purchased tray
    _activeTrayIndex = state.trays.length - 1;

    notifyListeners();
    StorageService.saveGame(state);
    return true;
  }

  // --- Shop Purchases ---
  bool buyShopItem(String itemId, int cost, {int? packetsAmount}) {
    if (state.coins < cost) return false;

    state.coins -= cost;

    if (packetsAmount != null) {
      state.seedPackets += packetsAmount;
    } else {
      state.purchasedUpgrades.add(itemId);
      if (itemId == 'large_tank') {
        state.maxWaterLevel = 250.0;
        state.waterLevel = 250.0;
      }
    }

    _audio.playPurchase();
    addXp(cost ~/ 3);

    notifyListeners();
    StorageService.saveGame(state);
    return true;
  }

  // --- Missions ---
  void _incrementMission(String missionId, int amount) {
    for (final mission in state.missions) {
      if (mission.id == missionId && !mission.isCompleted) {
        mission.currentProgress += amount;
        if (mission.currentProgress >= mission.targetCount) {
          mission.currentProgress = mission.targetCount;
          mission.isCompleted = true;
        }
      }
    }
  }

  bool claimMissionReward(String missionId) {
    final mission = state.missions.firstWhere((m) => m.id == missionId);
    if (!mission.isCompleted || mission.isClaimed) return false;

    mission.isClaimed = true;
    state.coins += mission.rewardCoins;
    addXp(mission.rewardXp);

    _audio.playReward();
    notifyListeners();
    StorageService.saveGame(state);
    return true;
  }

  void addXp(int amount) {
    state.xp += amount;
    while (state.xp >= state.xpForNextLevel) {
      state.xp -= state.xpForNextLevel;
      state.level++;
      state.coins += state.level * 100;
      _incrementMission('mission_reach_level_3', state.level);
    }
  }

  void toggleFastGrowthMode() {
    state.isFastGrowthMode = !state.isFastGrowthMode;
    notifyListeners();
    StorageService.saveGame(state);
  }

  void updateAudioVolumes(double sfx, double music) {
    state.sfxVolume = sfx;
    state.musicVolume = music;
    _audio.updateVolumes(sfx, music);
    notifyListeners();
    StorageService.saveGame(state);
  }

  void unlockRoom(String roomId, int cost) {
    if (state.coins >= cost) {
      state.coins -= cost;
      state.unlockedRooms.add(roomId);
      addXp(100);
      notifyListeners();
      StorageService.saveGame(state);
    }
  }

  void completeTutorial() {
    state.tutorialCompleted = true;
    notifyListeners();
    StorageService.saveGame(state);
  }

  void resetTutorial() {
    state.tutorialStep = 1;
    state.tutorialCompleted = false;
    notifyListeners();
    StorageService.saveGame(state);
  }

  void resetGameData() {
    state = GameState();
    _activeTrayIndex = 0;
    notifyListeners();
    StorageService.saveGame(state);
  }
}
