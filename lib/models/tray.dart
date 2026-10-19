import 'crop_slot.dart';

class CultivationTray {
  final int id;
  String name;
  CropStage stage;
  DateTime? plantedAt;
  DateTime? stageStartedAt;
  double moisture; // 0.0 to 100.0
  int lightLevel; // 1 (Dim), 2 (Medium), 3 (Standard), 4 (Bright Glow)
  double lightIntensity; // 0.0 to 1.0 (0% to 100%)
  DateTime? lastWateredAt;
  final int totalPlantsCount = 25;

  CultivationTray({
    required this.id,
    required this.name,
    this.stage = CropStage.empty,
    this.plantedAt,
    this.stageStartedAt,
    this.moisture = 40.0,
    this.lightLevel = 3,
    double? lightIntensity,
    this.lastWateredAt,
  }) : lightIntensity = lightIntensity ?? (lightLevel >= 3 ? 1.0 : (lightLevel == 2 ? 0.6 : 0.25));

  bool get isEmpty => stage == CropStage.empty || stage == CropStage.harvested;
  bool get isPlanted => stage != CropStage.empty && stage != CropStage.harvested;
  bool get isReadyToHarvest => stage == CropStage.flowering;
  bool get isGrowing => stage != CropStage.empty && stage != CropStage.flowering && stage != CropStage.harvested;
  bool get isNeedsWater => moisture < 25.0;
  bool get isLightOn => lightIntensity > 0.05;
  set isLightOn(bool value) {
    setIntensity(value ? 1.0 : 0.0);
  }

  void setIntensity(double val) {
    lightIntensity = val.clamp(0.0, 1.0);
    if (lightIntensity <= 0.05) {
      lightLevel = 1;
    } else if (lightIntensity <= 0.35) {
      lightLevel = 2;
    } else if (lightIntensity <= 0.70) {
      lightLevel = 3;
    } else {
      lightLevel = 4;
    }
  }

  int get plantCount => totalPlantsCount;
  String get currentAssetStage => stageImage;

  String get currentGrowLightAsset {
    if (lightIntensity <= 0.05) {
      return 'assets/grow_lights/grow_light_stage_01_dim.png';
    } else if (lightIntensity <= 0.35) {
      return 'assets/grow_lights/grow_light_stage_01_dim.png';
    } else if (lightIntensity <= 0.70) {
      return 'assets/grow_lights/grow_light_stage_02_medium.png';
    } else if (lightIntensity <= 0.90) {
      return 'assets/grow_lights/grow_light_stage_04_standard.png';
    } else {
      return 'assets/grow_lights/grow_light_stage_03_bright_glow.png';
    }
  }

  String get stageImage {
    switch (stage) {
      case CropStage.empty:
      case CropStage.harvested:
        return 'assets/cultivation_trays/tray_stage_01_soil.png';
      case CropStage.planted:
        return 'assets/cultivation_trays/tray_stage_02_bulbs.png';
      case CropStage.sprouting:
        return 'assets/cultivation_trays/tray_stage_03_sprouting.png';
      case CropStage.growing:
        return 'assets/cultivation_trays/tray_stage_04_growing.png';
      case CropStage.mature:
        return 'assets/cultivation_trays/tray_stage_05_vegetative.png';
      case CropStage.flowering:
        return 'assets/cultivation_trays/tray_stage_06_bloom.png';
    }
  }

  String get stageName {
    switch (stage) {
      case CropStage.empty:
      case CropStage.harvested:
        return 'Empty Soil Bed';
      case CropStage.planted:
        return 'Planted Corms';
      case CropStage.sprouting:
        return 'Early Sprouting';
      case CropStage.growing:
        return 'Active Leaf Growth';
      case CropStage.mature:
        return 'Vegetative Foliage';
      case CropStage.flowering:
        return 'Flowering (Ready to Harvest!)';
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'stage': stage.index,
    'plantedAt': plantedAt?.toIso8601String(),
    'stageStartedAt': stageStartedAt?.toIso8601String(),
    'moisture': moisture,
    'lightLevel': lightLevel,
    'lightIntensity': lightIntensity,
    'lastWateredAt': lastWateredAt?.toIso8601String(),
  };

  factory CultivationTray.fromJson(Map<String, dynamic> json) {
    final level = (json['lightLevel'] as int? ?? 3).clamp(1, 4);
    final intensity = (json['lightIntensity'] as num?)?.toDouble() ??
        (level >= 3 ? 1.0 : (level == 2 ? 0.6 : 0.25));
    return CultivationTray(
      id: json['id'] as int? ?? 1,
      name: json['name'] as String? ?? 'Tray #1',
      stage: CropStage.values[(json['stage'] as int? ?? 0).clamp(0, CropStage.values.length - 1)],
      plantedAt: json['plantedAt'] != null ? DateTime.tryParse(json['plantedAt']) : null,
      stageStartedAt: json['stageStartedAt'] != null ? DateTime.tryParse(json['stageStartedAt']) : null,
      moisture: (json['moisture'] as num?)?.toDouble() ?? 40.0,
      lightLevel: level,
      lightIntensity: intensity,
      lastWateredAt: json['lastWateredAt'] != null ? DateTime.tryParse(json['lastWateredAt']) : null,
    );
  }
}
