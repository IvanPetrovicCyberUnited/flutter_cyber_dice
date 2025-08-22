import 'package:audioplayers/audioplayers.dart';

class SoundEffects {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playStandard() async {
    await _player.stop();
    await _player.play(AssetSource('assets/sounds/roll.mp3'), volume: 0.7);
  }

  static Future<void> playSnow() async {
    await _player.stop();
    await _player.play(AssetSource('assets/sounds/snow.mp3'), volume: 0.7);
  }

  static Future<void> playVolcano() async {
    await _player.stop();
    await _player.play(AssetSource('assets/sounds/volcano.mp3'), volume: 0.7);
  }

  static Future<void> playThunder() async {
    await _player.stop();
    await _player.play(AssetSource('assets/sounds/thunder.mp3'), volume: 0.7);
  }
}
