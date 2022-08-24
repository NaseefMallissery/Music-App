import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:musica/database/favorite_db.dart';
import 'package:musica/model/music_player.dart';
import 'package:musica/screens/splash_screen.dart';

ValueNotifier<List<MusicPlayer>> playlistnotifier = ValueNotifier([]);

Future<void> playlistAdd(MusicPlayer value) async {
  final playListDb = Hive.box<MusicPlayer>('playlistDB');
  await playListDb.add(value);

  playlistnotifier.value.add(value);
}

Future<void> getAllPlaylist() async {
  final playListDb = Hive.box<MusicPlayer>('playlistDB');
  playlistnotifier.value.clear();
  playlistnotifier.value.addAll(playListDb.values);

  playlistnotifier.notifyListeners();
}

Future<void> playlistDelete(int index) async {
  final playListDb = Hive.box<MusicPlayer>('playlistDB');

  await playListDb.deleteAt(index);
  getAllPlaylist();
}

Future<void> resetAPP(context) async {
  final playListDb = Hive.box<MusicPlayer>('playlistDB');
  final musicDb = Hive.box<int>('favoriteDB');
  await musicDb.clear();
  await playListDb.clear();
  FavoriteDB.favoriteSongs.value.clear();
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      ),
      (route) => false);
}
