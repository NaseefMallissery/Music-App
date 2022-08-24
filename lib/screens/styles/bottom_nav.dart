import 'package:flutter/material.dart';
import 'package:musica/screens/home_screen.dart';
import 'package:musica/screens/play_list.dart';
import 'package:musica/screens/settings_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  List<Widget> pages = <Widget>[
    const HomeScreen(),
    const PlayList(),
    const SettingsScreen()
  ];
  int _selected = 0;
  void _onItemClick(int index) {
    setState(() {
      _selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selected],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.headphones_rounded,
              size: 35,
            ),
            label: 'Songs',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.playlist_add,
                size: 35,
              ),
              label: 'Playlist'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: 37,
              ),
              label: 'Settings')
        ],
        currentIndex: _selected,
        selectedIconTheme: const IconThemeData(
          color: Color.fromARGB(255, 255, 19, 2),
        ),
        onTap: _onItemClick,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        // showSelectedLabels: false,
        selectedLabelStyle: const TextStyle(color: Colors.black),
      ),
    );
  }
}
