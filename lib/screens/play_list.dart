import 'package:flutter/material.dart';
import 'package:musica/screens/favorite_screen.dart';
import 'package:musica/screens/playlsit_view.dart';

class PlayList extends StatefulWidget {
  const PlayList({Key? key}) : super(key: key);

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Playlist',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.07,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 15,
          right: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              horizontalTitleGap: 60,
              leading: Icon(
                Icons.favorite,
                color: const Color.fromARGB(255, 184, 14, 2),
                size: MediaQuery.of(context).size.width * 0.08,
              ),
              title: Text(
                'Favorites',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.059,
                ),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteScreen(),
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            ListTile(
              horizontalTitleGap: 60,
              leading: Icon(
                Icons.folder_copy_rounded,
                color: Colors.white,
                size: MediaQuery.of(context).size.width * 0.08,
              ),
              title: Text(
                'Playlists',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.059,
                ),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlayListSc(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
