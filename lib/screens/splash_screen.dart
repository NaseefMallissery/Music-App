import 'package:flutter/material.dart';

import 'package:musica/screens/styles/bottom_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    gotoHomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
              'assets/logo.png',
            ),
          ),
        ),
      ),
    );
  }

  Future<void> gotoHomeScreen() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: ((ctx) => const BottomNav()),
      ),
    );
  }
}
