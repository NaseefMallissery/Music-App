import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musica/screens/styles/favorite_button.dart';
import 'package:musica/screens/styles/song_store.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({
    Key? key,
    required this.playerSong,
  }) : super(key: key);

  final List<SongModel> playerSong;

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  bool _isPlaying = true;
  int currentIndex = 0;
  // bool _isFavorite = false;
  Duration _duration = const Duration();
  Duration _possition = const Duration();

  @override
  void initState() {
    StoreSong.player.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {
          currentIndex = index;
        });
      }
    });
    super.initState();
    playSong();
  }

  playSong() {
    StoreSong.player.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    StoreSong.player.positionStream.listen((p) {
      setState(() {
        _possition = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 16, 183, 71),
                Color.fromARGB(255, 18, 170, 71),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        elevation: 0,
        title: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
            ),
            Icon(Icons.music_note_outlined,
                size: MediaQuery.of(context).size.width * 0.07),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Text(
              'Rhythm',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.07,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 8, 112, 44),
              Color.fromARGB(255, 0, 255, 85),
              Color.fromARGB(255, 8, 112, 44),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      widget.playerSong[currentIndex].displayNameWOExt,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.07,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.playerSong[currentIndex].artist.toString() ==
                              "<unknown>"
                          ? "unknown artist"
                          : widget.playerSong[currentIndex].artist.toString(),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.27,
                  backgroundColor: Colors.black,
                  child: QueryArtworkWidget(
                    artworkFit: BoxFit.cover,
                    keepOldArtwork: true,
                    artworkBorder: BorderRadius.circular(500),
                    artworkWidth: MediaQuery.of(context).size.width * 1,
                    artworkHeight: MediaQuery.of(context).size.height * 1,
                    nullArtworkWidget: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.27,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 37, 36, 36),
                        radius: MediaQuery.of(context).size.width * 0.25,
                        child: Icon(
                          Icons.music_note,
                          size: MediaQuery.of(context).size.width * 0.28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    id: widget.playerSong[currentIndex].id,
                    type: ArtworkType.AUDIO,
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          _possition.toString().split(".")[0],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                        ),
                        Expanded(
                            child: Slider(
                                activeColor:
                                    const Color.fromARGB(255, 228, 228, 228),
                                inactiveColor: Colors.white38,
                                value: _possition.inSeconds.toDouble(),
                                max: _duration.inSeconds.toDouble(),
                                min: const Duration(microseconds: 0)
                                    .inSeconds
                                    .toDouble(),
                                onChanged: (value) {
                                  setState(() {
                                    changeToSecond(value.toInt());
                                    value = value;
                                  });
                                })),
                        Text(
                          _duration.toString().split(".")[0],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: StreamBuilder<LoopMode>(
                            stream: StoreSong.player.loopModeStream,
                            builder: (context, snapshot) {
                              return _repeatButton(
                                  context, snapshot.data ?? LoopMode.off);
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (StoreSong.player.hasPrevious) {
                              _isPlaying = true;
                              await StoreSong.player.seekToPrevious();
                              await StoreSong.player.play();
                            } else {
                              await StoreSong.player.play();
                            }
                          },
                          icon: Icon(
                            Icons.skip_previous,
                            size: MediaQuery.of(context).size.width * 0.13,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: MediaQuery.of(context).size.width * 0.14,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_isPlaying) {
                                StoreSong.player.pause();
                              } else {
                                StoreSong.player.play();
                              }
                              _isPlaying = !_isPlaying;
                            });
                          },
                        ),
                        IconButton(
                          onPressed: () async {
                            if (StoreSong.player.hasNext) {
                              _isPlaying = true;
                              await StoreSong.player.seekToNext();
                              await StoreSong.player.play();
                            } else {
                              await StoreSong.player.play();
                            }
                          },
                          icon: Icon(
                            Icons.skip_next,
                            size: MediaQuery.of(context).size.width * 0.13,
                            color: Colors.white,
                          ),
                        ),
                        StreamBuilder<bool>(
                          stream: StoreSong.player.shuffleModeEnabledStream,
                          builder: (context, snapshot) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                              child: _shuffleButton(
                                  context, snapshot.data ?? false),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        FavoriteBut(song: widget.playerSong[currentIndex]),
                        const Spacer(),
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: Icon(
                        //     Icons.playlist_add,
                        //     color: Colors.white,
                        //     size: MediaQuery.of(context).size.width * 0.08,
                        //   ),
                        // ),
                        const Spacer(),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeToSecond(int seconds) {
    Duration duration = Duration(seconds: seconds);
    StoreSong.player.seek(duration);
  }

  Widget _shuffleButton(BuildContext context, bool isEnabled) {
    return IconButton(
      icon: isEnabled
          ? Icon(
              Icons.shuffle,
              size: MediaQuery.of(context).size.width * 0.08,
              color: Colors.black,
            )
          : Icon(
              Icons.shuffle,
              size: MediaQuery.of(context).size.width * 0.08,
              color: Colors.white,
            ),
      onPressed: () async {
        final enable = !isEnabled;
        if (enable) {
          await StoreSong.player.shuffle();
        }
        await StoreSong.player.setShuffleModeEnabled(enable);
      },
    );
  }

  Widget _repeatButton(BuildContext context, LoopMode loopMode) {
    final icons = [
      Icon(
        Icons.repeat,
        size: MediaQuery.of(context).size.width * 0.08,
        color: Colors.white,
      ),
      Icon(
        Icons.repeat,
        size: MediaQuery.of(context).size.width * 0.08,
        color: Colors.black,
      ),
      Icon(
        Icons.repeat_one,
        size: MediaQuery.of(context).size.width * 0.08,
        color: Colors.black,
      ),
    ];
    const cycleModes = [
      LoopMode.off,
      LoopMode.all,
      LoopMode.one,
    ];
    final index = cycleModes.indexOf(loopMode);
    return IconButton(
      icon: icons[index],
      onPressed: () {
        StoreSong.player.setLoopMode(
            cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
      },
    );
  }
}
