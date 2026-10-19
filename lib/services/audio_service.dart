import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  static bool enableAudio = true;

  AudioPlayer? _sfxPlayer;
  AudioPlayer? _musicPlayer;
  bool _initialized = false;

  bool sfxEnabled = true;
  bool musicEnabled = true;
  double sfxVolume = 0.8;
  double musicVolume = 0.5;

  Future<void> init() async {
    if (!enableAudio || _initialized) return;
    try {
      _sfxPlayer = AudioPlayer();
      _musicPlayer = AudioPlayer();
      await _sfxPlayer?.setVolume(sfxVolume);
      await _musicPlayer?.setVolume(musicVolume);
      await _musicPlayer?.setReleaseMode(ReleaseMode.loop);
      _initialized = true;
    } catch (_) {
      // Gracefully handled if audio platform channel is not present
    }
  }

  Future<void> playClick() async {
    if (!enableAudio || !sfxEnabled || _sfxPlayer == null) return;
    try {
      await _sfxPlayer?.play(AssetSource('audio/sfx/ui_click.ogg'));
    } catch (_) {}
  }

  Future<void> playPlant() async {
    if (!enableAudio || !sfxEnabled || _sfxPlayer == null) return;
    try {
      await _sfxPlayer?.play(AssetSource('audio/sfx/pickup.ogg'));
    } catch (_) {}
  }

  Future<void> playWater() async {
    if (!enableAudio || !sfxEnabled || _sfxPlayer == null) return;
    try {
      await _sfxPlayer?.play(AssetSource('audio/sfx/ui_click.ogg'));
    } catch (_) {}
  }

  Future<void> playHarvest() async {
    if (!enableAudio || !sfxEnabled || _sfxPlayer == null) return;
    try {
      await _sfxPlayer?.play(AssetSource('audio/sfx/correct.ogg'));
    } catch (_) {}
  }

  Future<void> playPurchase() async {
    if (!enableAudio || !sfxEnabled || _sfxPlayer == null) return;
    try {
      await _sfxPlayer?.play(AssetSource('audio/sfx/shop_purchase.ogg'));
    } catch (_) {}
  }

  Future<void> playReward() async {
    if (!enableAudio || !sfxEnabled || _sfxPlayer == null) return;
    try {
      await _sfxPlayer?.play(AssetSource('audio/sfx/combo.ogg'));
    } catch (_) {}
  }

  Future<void> startMusic() async {
    if (!enableAudio || !musicEnabled || _musicPlayer == null) return;
    try {
      await _musicPlayer?.play(AssetSource('audio/music/menu_background.mp3'));
    } catch (_) {}
  }

  Future<void> stopMusic() async {
    if (!enableAudio) return;
    try {
      await _musicPlayer?.stop();
    } catch (_) {}
  }

  void updateVolumes(double sfx, double music) {
    sfxVolume = sfx;
    musicVolume = music;
    sfxEnabled = sfx > 0.05;
    musicEnabled = music > 0.05;
    if (!enableAudio) return;
    try {
      _sfxPlayer?.setVolume(sfxVolume);
      _musicPlayer?.setVolume(musicVolume);
      if (!musicEnabled) {
        _musicPlayer?.stop();
      }
    } catch (_) {}
  }
}
