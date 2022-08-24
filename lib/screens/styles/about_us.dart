import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About us',
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.07,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
        ),
        child: Container(
          child: Text(
            '''This application is created by Naseef Ali.M at Brototype.The app promises a user friendly experience to the customers and highlights the simple and important features needed in a music player''',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      )),
    );
  }
}
