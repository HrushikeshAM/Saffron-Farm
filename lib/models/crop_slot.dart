enum CropStage {
  empty,
  planted,     // Corm bulb in soil
  sprouting,   // Small green shoots
  growing,     // Young leaves growing
  mature,      // Full vegetative foliage
  flowering,   // Ready to harvest purple bloom
  harvested,   // Ready to be cleared / replanted
}

class CropSlot {
  final int index;
  CropStage stage;
  DateTime? plantedAt;
  DateTime? lastStageUpdate;
  double health; // 0.0 to 1.0

  CropSlot({
    required this.index,
    this.stage = CropStage.empty,
    this.plantedAt,
    this.lastStageUpdate,
    this.health = 1.0,
  });

  bool get isEmpty => stage == CropStage.empty || stage == CropStage.harvested;
  bool get isReadyToHarvest => stage == CropStage.flowering;
  bool get isGrowing => stage != CropStage.empty && stage != CropStage.flowering && stage != CropStage.harvested;

  Map<String, dynamic> toJson() => {
    'index': index,
    'stage': stage.index,
    'plantedAt': plantedAt?.toIso8601String(),
    'lastStageUpdate': lastStageUpdate?.toIso8601String(),
    'health': health,
  };

  factory CropSlot.fromJson(Map<String, dynamic> json) {
    return CropSlot(
      index: json['index'] as int? ?? 0,
      stage: CropStage.values[json['stage'] as int? ?? 0],
      plantedAt: json['plantedAt'] != null ? DateTime.tryParse(json['plantedAt']) : null,
      lastStageUpdate: json['lastStageUpdate'] != null ? DateTime.tryParse(json['lastStageUpdate']) : null,
      health: (json['health'] as num?)?.toDouble() ?? 1.0,
    );
  }
}
