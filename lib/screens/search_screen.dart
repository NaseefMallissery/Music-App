import 'package:flutter/material.dart';
import 'package:musica/screens/home_screen.dart';
import 'package:musica/screens/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  late List<SongModel> _allSongs;
  List<SongModel> _foundSongs = [];

  void loadAllSongList() async {
    _allSongs = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true);
    _foundSongs = _allSongs;
  }

  void search(String enteredKeyword) {
    List<SongModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allSongs;
    } else {
      results = _allSongs
          .where((element) => element.displayNameWOExt
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundSongs = results;
    });
  }

  @override
  void initState() {
    loadAllSongList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              TextField(
                  onChanged: (value) => search(value),
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    focusColor: Colors.white,
                    filled: true,
                    fillColor: Color.fromARGB(255, 245, 242, 244),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                  )),
              Expanded(
                child: _foundSongs.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: QueryArtworkWidget(
                              id: _foundSongs[index].id,
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
                            ),
                            title: Text(
                              _foundSongs[index].displayNameWOExt,
                              maxLines: 1,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "${_foundSongs[index].artist}",
                              maxLines: 1,
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (ctx) => NowPlayingScreen(
                                        playerSong: HomeScreen.song)),
                              );
                            },
                          );
                        },
                        itemCount: _foundSongs.length)
                    : const Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
              ),
            ],
          ),
        ));
  }
}
