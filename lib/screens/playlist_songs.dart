import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musica/database/playlist_db.dart';
import 'package:musica/model/music_player.dart';
import 'package:musica/screens/now_playing.dart';
import 'package:musica/screens/songs_to_playlist.dart';
import 'package:musica/screens/styles/song_store.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistData extends StatefulWidget {
  const PlaylistData(
      {Key? key, required this.playlist, required this.folderindex})
      : super(key: key);
  final MusicPlayer playlist;
  final int folderindex;
  // static List<SongModel> playlistSongid = [];
  @override
  State<PlaylistData> createState() => _PlaylistDataState();
}

class _PlaylistDataState extends State<PlaylistData> {
  late List<SongModel> playlistsong;
  @override
  Widget build(BuildContext context) {
    getAllPlaylist();
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        automaticallyImplyLeading: false,
        title: Text(widget.playlist.name,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
            valueListenable: Hive.box<MusicPlayer>('playlistDB').listenable(),
            builder:
                (BuildContext context, Box<MusicPlayer> value, Widget? child) {
              playlistsong = listPlaylist(
                  value.values.toList()[widget.folderindex].songIds);

              return playlistsong.isEmpty
                  ? const Center(
                      child: Text(
                        'No songs in this playlist',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                            onTap: () {
                              List<SongModel> newlist = [...playlistsong];

                              StoreSong.player.stop();
                              StoreSong.player.setAudioSource(
                                  StoreSong.createSongList(newlist),
                                  initialIndex: index);
                              StoreSong.player.play();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => NowPlayingScreen(
                                        playerSong: playlistsong,
                                      )));
                            },
                            leading: QueryArtworkWidget(
                              id: playlistsong[index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: CircleAvatar(
                                radius:
                                    MediaQuery.of(context).size.width * 0.075,
                                backgroundColor:
                                    const Color.fromARGB(255, 43, 42, 42),
                                child: const Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                ),
                              ),
                              errorBuilder: (context, excepion, gdb) {
                                setState(() {});
                                return Image.asset('');
                              },
                            ),
                            title: Text(
                              playlistsong[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                            subtitle: Text(
                              playlistsong[index].artist!,
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  widget.playlist
                                      .deleteData(playlistsong[index].id);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                )));
                      },
                      separatorBuilder: (ctx, index) {
                        return const Divider();
                      },
                      itemCount: playlistsong.length);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => SongListPage(
                playlist: widget.playlist,
              ),
            ),
          );
        },
        label: const Text(
          'Add song',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 16, 183, 71),
      ),
    );
  }

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> plsongs = [];
    for (int i = 0; i < StoreSong.songCopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (StoreSong.songCopy[i].id == data[j]) {
          plsongs.add(StoreSong.songCopy[i]);
        }
      }
    }
    return plsongs;
  }
}
