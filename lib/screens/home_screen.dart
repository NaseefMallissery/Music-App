import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musica/screens/styles/favorite_button.dart';
import 'package:musica/database/favorite_db.dart';
import 'package:musica/screens/now_playing.dart';
import 'package:musica/screens/search_screen.dart';
import 'package:musica/screens/styles/song_store.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static List<SongModel> song = [];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Songs',
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.07,
            letterSpacing: 2,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.02),
            child: IconButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(
                  MaterialPageRoute(
                    builder: (context) => const Search(),
                  ),
                );
              },
              icon: Icon(
                Icons.search_outlined,
                color: Colors.white,
                size: MediaQuery.of(context).size.width * 0.08,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          if (item.data!.isEmpty) {
            return const Center(
              child: Text(
                'No Songs Found',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }
          HomeScreen.song = item.data!;
          if (!FavoriteDB.isInitialized) {
            FavoriteDB.initialise(item.data!);
          }
          StoreSong.songCopy = item.data!;
          return ListView.builder(
            itemBuilder: ((context, index) => ListTile(
                  leading: QueryArtworkWidget(
                    id: item.data![index].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.075,
                      backgroundColor: const Color.fromARGB(255, 43, 42, 42),
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    item.data![index].displayNameWOExt,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    item.data![index].artist.toString(),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: FavoriteBut(song: HomeScreen.song[index]),
                  onTap: () {
                    StoreSong.player.setAudioSource(
                        StoreSong.createSongList(item.data!),
                        initialIndex: index);
                    StoreSong.player.play();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NowPlayingScreen(
                          playerSong: item.data!,
                        ),
                      ),
                    );
                  },
                )),
            itemCount: item.data!.length,
          );
        },
      ),
    );
  }
}
