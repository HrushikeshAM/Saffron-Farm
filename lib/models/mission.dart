class Mission {
  final String id;
  final String title;
  final String description;
  final int targetCount;
  int currentProgress;
  final int rewardCoins;
  final int rewardXp;
  bool isCompleted;
  bool isClaimed;

  Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.targetCount,
    this.currentProgress = 0,
    required this.rewardCoins,
    required this.rewardXp,
    this.isCompleted = false,
    this.isClaimed = false,
  });

  double get progressFraction => (currentProgress / targetCount).clamp(0.0, 1.0);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'targetCount': targetCount,
    'currentProgress': currentProgress,
    'rewardCoins': rewardCoins,
    'rewardXp': rewardXp,
    'isCompleted': isCompleted,
    'isClaimed': isClaimed,
  };

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      targetCount: json['targetCount'] as int,
      currentProgress: json['currentProgress'] as int? ?? 0,
      rewardCoins: json['rewardCoins'] as int? ?? 50,
      rewardXp: json['rewardXp'] as int? ?? 25,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isClaimed: json['isClaimed'] as bool? ?? false,
    );
  }

  static List<Mission> initialMissions() {
    return [
      Mission(
        id: 'mission_plant_first',
        title: 'Plant Your First Corm',
        description: 'Plant a saffron corm in any empty tray slot.',
        targetCount: 1,
        rewardCoins: 50,
        rewardXp: 30,
      ),
      Mission(
        id: 'mission_water_tray',
        title: 'Irrigation Basics',
        description: 'Water an active growing tray using the watering can.',
        targetCount: 1,
        rewardCoins: 60,
        rewardXp: 35,
      ),
      Mission(
        id: 'mission_adjust_light',
        title: 'Optimal Photoperiod',
        description: 'Set your LED Grow Lights to Standard or Bright Glow.',
        targetCount: 1,
        rewardCoins: 50,
        rewardXp: 25,
      ),
      Mission(
        id: 'mission_plant_ten',
        title: 'Field Cultivator',
        description: 'Plant 10 saffron corms across your farm trays.',
        targetCount: 10,
        rewardCoins: 120,
        rewardXp: 60,
      ),
      Mission(
        id: 'mission_harvest_flowers',
        title: 'Red Gold Harvest',
        description: 'Harvest 10 fully blossomed saffron flowers.',
        targetCount: 10,
        rewardCoins: 180,
        rewardXp: 90,
      ),
      Mission(
        id: 'mission_dry_batch',
        title: 'Dehydration Master',
        description: 'Dry your fresh harvest in the dehydrator unit.',
        targetCount: 1,
        rewardCoins: 200,
        rewardXp: 100,
      ),
      Mission(
        id: 'mission_sell_saffron',
        title: 'First Saffron Sale',
        description: 'Sell packaged dried saffron at the trade counter.',
        targetCount: 1,
        rewardCoins: 250,
        rewardXp: 120,
      ),
      Mission(
        id: 'mission_buy_tray',
        title: 'Farm Expansion',
        description: 'Unlock and purchase a 6th cultivation tray (+ Card).',
        targetCount: 1,
        rewardCoins: 350,
        rewardXp: 200,
      ),
      Mission(
        id: 'mission_reach_level_3',
        title: 'Master Agronomist',
        description: 'Reach Farmer Level 3 through experience.',
        targetCount: 3,
        rewardCoins: 500,
        rewardXp: 300,
      ),
    ];
  }
}
