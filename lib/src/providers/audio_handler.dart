import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';


import '../models/audio/audio.dart';
import '../models/file/file.dart';

class AudioHandler with ChangeNotifier {
  static const duration = Duration(milliseconds: 200);
  late AudioPlayer player;
  late Audio audio;
  late File file;
  PlayerState playerState = PlayerState.STOPPED;
  late StreamSubscription _playerStateStream;

  AudioHandler(this.player) {
    _playerStateStream = player.onPlayerStateChanged.listen((state) {
      playerState = state;

      if(state == PlayerState.COMPLETED) {
        Future.delayed(Duration(milliseconds: 500)).then((_) {
          // audio = Audio();
          // file = null;
          notifyListeners();
        });
      }

      notifyListeners();
    });
  }

  Future<void> play(Audio audio, File file) async {
    this.audio = audio;
    this.file = file;

    await player.play(file.url!);
  }

  Future<void> pause() async {
    await player.pause();
  }

  Future<void> resume() async {
    await player.resume();
  }

  Future<void> seek(Duration position) async {
    await player.seek(position);
  }

  Future<void> release() async {
    await player.release();
  }

  @override
  void dispose() {
    _playerStateStream.cancel();
    super.dispose();
  }

}