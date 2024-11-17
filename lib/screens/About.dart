import 'package:flutter/material.dart';

import '../core/Fade_Animation.dart';
import '../utils/utils.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Color.fromARGB(150, 255, 187, 79),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            stops: const [0.4, 0.9, 0.8, 0.1],
            colors: [
              hexStringToColor("#3E4C59"),
              hexStringToColor("#FFCF9F"),
              hexStringToColor("#3E4C59"),
              hexStringToColor("#FFCF9F")
            ],
          ),
        ),
        child: Container(
          width: double.infinity,
          child: Container(
            margin: EdgeInsets.only(top: 80,bottom: 80,left: 30,right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeAnimation(
                  delay: 0.8,
                  child: Text(
                    "Rebuilt Application ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Color.fromARGB(
                        255, 194, 194, 194)),
                  ),
                ),
                FadeAnimation(delay: 0.8, child: Text("1.0.0",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Color.fromARGB(
                    255, 201, 201, 201)),)),
                FadeAnimation(
                  delay: 1.3,
                  child: Image.asset(
                    "assets/Images/civil-engineering.png",
                    width: 100,
                    height: 100,
                  ),
                ),
                FadeAnimation(delay: 1.8, child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.copyright),
                      Text("2022-2023 Rebuilt"),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
