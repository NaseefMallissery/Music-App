import 'package:flutter/material.dart';
import 'package:musica/database/playlist_db.dart';
import 'package:share/share.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.07,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 25,
          left: 15,
          right: 15,
          bottom: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.share,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.width * 0.055,
                  ),
                  title: Transform.translate(
                    offset: const Offset(-50, 0),
                    child: Text(
                      'Share App',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    Share.share("Musica");
                  },
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                ListTile(
                  horizontalTitleGap: 4,
                  leading: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.width * 0.055,
                  ),
                  title: Transform.translate(
                    offset: const Offset(-50, 0),
                    child: Text(
                      'About Us',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {},
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                ListTile(
                  leading: Icon(
                    Icons.restore,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.width * 0.055,
                  ),
                  title: Transform.translate(
                    offset: const Offset(-50, 0),
                    child: Text(
                      'Reset App',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Reset App',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                                'Are you  want to reset this application?'),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'No',
                                ),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color.fromARGB(
                                          255, 18, 170, 71)),
                                  onPressed: () {
                                    resetAPP(context);
                                  },
                                  child: const Text('Yes'))
                            ],
                          );
                        });
                  },
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ],
            ),
            Text(
              'v.1.0.0',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: MediaQuery.of(context).size.width * 0.04),
            )
          ],
        ),
      ),
    );
  }
}
