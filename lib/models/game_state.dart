import 'crop_slot.dart';
import 'tray.dart';
import 'drying_batch.dart';
import 'mission.dart';

class GameState {
  int coins;
  int xp;
  int level;
  int seedPackets; // 1 packet = 25 seeds for an entire tray
  int freshFlowers;
  double driedGrams;
  double waterLevel;
  double maxWaterLevel;
  List<CultivationTray> trays;
  List<DryingBatch> dryingBatches;
  List<Mission> missions;
  List<String> unlockedRooms;
  Set<String> purchasedUpgrades;
  int tutorialStep;
  bool tutorialCompleted;
  bool isFastGrowthMode;
  double sfxVolume;
  double musicVolume;
  DateTime lastSavedAt;

  GameState({
    this.coins = 500,
    this.xp = 0,
    this.level = 1,
    this.seedPackets = 5,
    this.freshFlowers = 0,
    this.driedGrams = 0.0,
    this.waterLevel = 100.0,
    this.maxWaterLevel = 100.0,
    List<CultivationTray>? trays,
    List<DryingBatch>? dryingBatches,
    List<Mission>? missions,
    List<String>? unlockedRooms,
    Set<String>? purchasedUpgrades,
    this.tutorialStep = 1,
    this.tutorialCompleted = false,
    this.isFastGrowthMode = false,
    this.sfxVolume = 0.8,
    this.musicVolume = 0.5,
    DateTime? lastSavedAt,
  })  : trays = trays ??
            List.generate(
              5,
              (i) => CultivationTray(
                id: i + 1,
                name: 'Tray #${i + 1}',
                stage: CropStage.empty, // All 5 start completely empty!
                moisture: 30.0,
                lightLevel: 3,
              ),
            ),
        dryingBatches = dryingBatches ?? [],
        missions = missions ?? Mission.initialMissions(),
        unlockedRooms = unlockedRooms ?? ['room_starter_greenhouse'],
        purchasedUpgrades = purchasedUpgrades ?? {},
        lastSavedAt = lastSavedAt ?? DateTime.now();

  int get xpForNextLevel => level * 150;
  double get xpProgress => (xp / xpForNextLevel).clamp(0.0, 1.0);

  int get nextTrayUnlockCost {
    final nextId = trays.length + 1;
    // Base cost 250 for tray 6, then scaling
    return (250 + (nextId - 6) * 200).clamp(250, 5000);
  }

  Map<String, dynamic> toJson() => {
    'coins': coins,
    'xp': xp,
    'level': level,
    'seedPackets': seedPackets,
    'freshFlowers': freshFlowers,
    'driedGrams': driedGrams,
    'waterLevel': waterLevel,
    'maxWaterLevel': maxWaterLevel,
    'trays': trays.map((t) => t.toJson()).toList(),
    'dryingBatches': dryingBatches.map((b) => b.toJson()).toList(),
    'missions': missions.map((m) => m.toJson()).toList(),
    'unlockedRooms': unlockedRooms,
    'purchasedUpgrades': purchasedUpgrades.toList(),
    'tutorialStep': tutorialStep,
    'tutorialCompleted': tutorialCompleted,
    'isFastGrowthMode': isFastGrowthMode,
    'sfxVolume': sfxVolume,
    'musicVolume': musicVolume,
    'lastSavedAt': lastSavedAt.toIso8601String(),
  };

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      coins: json['coins'] as int? ?? 500,
      xp: json['xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      seedPackets: json['seedPackets'] as int? ?? (json['corms'] != null ? ((json['corms'] as int) ~/ 5).clamp(1, 100) : 5),
      freshFlowers: json['freshFlowers'] as int? ?? 0,
      driedGrams: (json['driedGrams'] as num?)?.toDouble() ?? 0.0,
      waterLevel: (json['waterLevel'] as num?)?.toDouble() ?? 100.0,
      maxWaterLevel: (json['maxWaterLevel'] as num?)?.toDouble() ?? 100.0,
      trays: (json['trays'] as List<dynamic>?)
              ?.map((t) => CultivationTray.fromJson(t as Map<String, dynamic>))
              .toList() ??
          List.generate(
            5,
            (i) => CultivationTray(
              id: i + 1,
              name: 'Tray #${i + 1}',
              stage: CropStage.empty,
              moisture: 30.0,
              lightLevel: 3,
            ),
          ),
      dryingBatches: (json['dryingBatches'] as List<dynamic>?)
              ?.map((b) => DryingBatch.fromJson(b as Map<String, dynamic>))
              .toList() ??
          [],
      missions: (json['missions'] as List<dynamic>?)
              ?.map((m) => Mission.fromJson(m as Map<String, dynamic>))
              .toList() ??
          Mission.initialMissions(),
      unlockedRooms: (json['unlockedRooms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['room_starter_greenhouse'],
      purchasedUpgrades: (json['purchasedUpgrades'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toSet() ??
          {},
      tutorialStep: json['tutorialStep'] as int? ?? 1,
      tutorialCompleted: json['tutorialCompleted'] as bool? ?? false,
      isFastGrowthMode: json['isFastGrowthMode'] as bool? ?? false,
      sfxVolume: (json['sfxVolume'] as num?)?.toDouble() ?? 0.8,
      musicVolume: (json['musicVolume'] as num?)?.toDouble() ?? 0.5,
      lastSavedAt: json['lastSavedAt'] != null
          ? DateTime.tryParse(json['lastSavedAt'])
          : DateTime.now(),
    );
  }
}
