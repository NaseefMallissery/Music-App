import 'package:flutter/material.dart';
import 'package:musica/database/favorite_db.dart';
import 'package:musica/screens/now_playing.dart';
import 'package:musica/screens/styles/song_store.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDB.favoriteSongs,
        builder: (BuildContext ctx, List<SongModel> favorData, Widget? child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Favotites',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.07,
                  letterSpacing: 2,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: FavoriteDB.favoriteSongs.value.isEmpty
                  ? const Center(
                      child: Text(
                      'No Favorites songs',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ))
                  : ListView(children: [
                      ValueListenableBuilder(
                        valueListenable: FavoriteDB.favoriteSongs,
                        builder: (BuildContext ctx, List<SongModel> favorData,
                            Widget? child) {
                          return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (ctx, index) {
                                return ListTile(
                                  onTap: () {
                                    List<SongModel> newlist = [...favorData];
                                    setState(() {});
                                    StoreSong.player.stop();
                                    StoreSong.player.setAudioSource(
                                        StoreSong.createSongList(newlist),
                                        initialIndex: index);
                                    StoreSong.player.play();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => NowPlayingScreen(
                                          playerSong: newlist,
                                        ),
                                      ),
                                    );
                                  },
                                  leading: QueryArtworkWidget(
                                    id: favorData[index].id,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width *
                                              0.075,
                                      backgroundColor:
                                          const Color.fromARGB(255, 43, 42, 42),
                                      child: const Icon(
                                        Icons.music_note,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    favorData[index].displayNameWOExt,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 15),
                                  ),
                                  subtitle: Text(
                                    favorData[index].artist.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        FavoriteDB.favoriteSongs
                                            .notifyListeners();
                                        FavoriteDB.delete(favorData[index].id);
                                        setState(() {});
                                        const snackbar = SnackBar(
                                            backgroundColor: Color.fromARGB(
                                                255, 255, 255, 255),
                                            content: Text(
                                              'Song removed from favorites',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            duration:
                                                Duration(milliseconds: 500));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackbar);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 30,
                                      )),
                                );
                              },
                              separatorBuilder: (ctx, index) {
                                return const Divider();
                              },
                              itemCount: favorData.length);
                        },
                      ),
                    ]),
            ),
          );
        });
  }
}
