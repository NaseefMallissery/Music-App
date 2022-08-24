import 'package:flutter/material.dart';

import 'package:just_audio_background/just_audio_background.dart';
import 'package:musica/model/music_player.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:musica/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(MusicPlayerAdapter().typeId)) {
    Hive.registerAdapter(MusicPlayerAdapter());
  }
  await Hive.openBox<int>('favoriteDB');
  await Hive.openBox<MusicPlayer>('playlistDB');

  await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      preloadArtwork: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rhythm',
      theme: ThemeData(
          // fontFamily: 'Signatra',
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromARGB(255, 17, 17, 17),
          ),
          scaffoldBackgroundColor: Colors.black),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
