import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/crop_slot.dart';
import '../models/game_state.dart';

class StorageService {
  static const String _storageKey = 'axiomgreen_saffron_farm_save_v1';

  static Future<void> saveGame(GameState state) async {
    try {
      state.lastSavedAt = DateTime.now();
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(state.toJson());
      await prefs.setString(_storageKey, jsonString);
    } catch (_) {}
  }

  static Future<GameState> loadGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final Map<String, dynamic> data = jsonDecode(jsonString);
        final state = GameState.fromJson(data);
        _applyOfflineSimulation(state);
        return state;
      }
    } catch (_) {}
    return GameState();
  }

  /// Calculates elapsed offline time and simulates crop growth & drying progress
  static void _applyOfflineSimulation(GameState state) {
    final now = DateTime.now();
    final elapsedSec = now.difference(state.lastSavedAt).inSeconds;
    if (elapsedSec <= 0) return;

    final baseStageDuration = state.isFastGrowthMode ? 4 : 20;

    for (final tray in state.trays) {
      if (tray.moisture > 0) {
        final evapRate = state.purchasedUpgrades.contains('auto_irrigation') ? 0.05 : 0.15;
        final waterLost = elapsedSec * evapRate;
        tray.moisture = (tray.moisture - waterLost).clamp(0.0, 100.0);
        if (state.purchasedUpgrades.contains('auto_irrigation') && tray.moisture < 60) {
          tray.moisture = 80.0;
        }
      }

      if (tray.isGrowing && tray.stageStartedAt != null) {
        if (!tray.isNeedsWater) {
          double lightMultiplier = 1.0;
          if (tray.lightLevel == 1) lightMultiplier = 0.8;
          if (tray.lightLevel == 2) lightMultiplier = 1.0;
          if (tray.lightLevel == 3) lightMultiplier = 1.25;
          if (tray.lightLevel == 4) lightMultiplier = 1.5;

          final effectiveDuration = (baseStageDuration / lightMultiplier).round().clamp(2, 100);
          final totalElapsed = now.difference(tray.stageStartedAt!).inSeconds;
          final stagesAdvanced = totalElapsed ~/ effectiveDuration;

          if (stagesAdvanced > 0) {
            final nextStageIndex = tray.stage.index + stagesAdvanced;
            if (nextStageIndex >= CropStage.flowering.index) {
              tray.stage = CropStage.flowering;
            } else {
              tray.stage = CropStage.values[nextStageIndex.clamp(1, 5)];
              tray.stageStartedAt = now;
            }
          }
        }
      }
    }

    state.lastSavedAt = now;
  }
}
