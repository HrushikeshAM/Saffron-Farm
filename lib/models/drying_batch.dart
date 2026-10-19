enum DryerState {
  offEmpty,      // State 1
  preheating,    // State 2
  dryingLow,     // State 3
  dryingHigh,    // State 4
  completed,     // State 5
  cooldownIdle,  // State 6
}

class DryingBatch {
  final String id;
  final int freshFlowersCount;
  final DateTime startedAt;
  final int durationSeconds;
  bool isCollected;

  DryingBatch({
    required this.id,
    required this.freshFlowersCount,
    required this.startedAt,
    this.durationSeconds = 25,
    this.isCollected = false,
  });

  int get elapsedSeconds {
    final now = DateTime.now();
    return now.difference(startedAt).inSeconds;
  }

  double get progress {
    if (durationSeconds <= 0) return 1.0;
    final p = elapsedSeconds / durationSeconds;
    return p.clamp(0.0, 1.0);
  }

  int get remainingSeconds {
    final rem = durationSeconds - elapsedSeconds;
    return rem < 0 ? 0 : rem;
  }

  bool get isDone => elapsedSeconds >= durationSeconds;

  double get driedGramsYield {
    // 5 fresh flowers = 1.0 gram of dried pure red saffron
    return (freshFlowersCount / 5.0);
  }

  DryerState get visualState {
    if (isCollected) return DryerState.cooldownIdle;
    if (isDone) return DryerState.completed;
    final p = progress;
    if (p < 0.20) return DryerState.preheating;
    if (p < 0.65) return DryerState.dryingLow;
    return DryerState.dryingHigh;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'freshFlowersCount': freshFlowersCount,
    'startedAt': startedAt.toIso8601String(),
    'durationSeconds': durationSeconds,
    'isCollected': isCollected,
  };

  factory DryingBatch.fromJson(Map<String, dynamic> json) {
    return DryingBatch(
      id: json['id'] as String? ?? 'batch_1',
      freshFlowersCount: json['freshFlowersCount'] as int? ?? 5,
      startedAt: DateTime.tryParse(json['startedAt'] as String? ?? '') ?? DateTime.now(),
      durationSeconds: json['durationSeconds'] as int? ?? 25,
      isCollected: json['isCollected'] as bool? ?? false,
    );
  }
}
