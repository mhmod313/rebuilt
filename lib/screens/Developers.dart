import 'package:flutter/material.dart';
import 'package:rebuilt/core/Fade_Animation.dart';

import '../utils/utils.dart';

class DEvelopers extends StatefulWidget {
  const DEvelopers({Key? key}) : super(key: key);

  @override
  State<DEvelopers> createState() => _DEvelopersState();
}

class _DEvelopersState extends State<DEvelopers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor:Color.fromARGB(150, 255, 187, 79),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.9, 0.5, 0.3, 0.9],
            colors: [
              hexStringToColor("#3E4C59"),
              hexStringToColor("#FFCF9F"),
              hexStringToColor("#FFCF9F"),
              hexStringToColor("#3E4C59")
            ],
          ),
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                hexStringToColor("#FFCF9F").withOpacity(0.1),
                BlendMode.dstATop),
            image: const AssetImage('assets/Images/civil-engineering.png'),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FadeAnimation(
                delay: 0.8,
                child: Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[800],
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 3,
                        blurRadius: 4,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: 20,),
                      const Text(
                        "Mahmoud Ismael",
                        style: TextStyle(
                            fontFamily: "Pacifico", fontSize: 40, color: Color.fromARGB(
                            255, 201, 201, 201)),
                      ),
                      const Text(
                        "FLUTTER DEVELOPER",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "SourceSansPro",
                          letterSpacing: 3,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(
                        endIndent: 20,
                        indent: 20,
                        thickness: 1,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        color: Color.fromARGB(255, 190, 143, 83),
                        child: ListTile(

                          leading: Icon(
                            Icons.location_on,
                            color: Colors.grey[200],
                          ),
                          title: const Text("Damascus/Al-Qatifa",style: TextStyle(color: Colors.black),),
                        ),
                      ),
                      Card(
                          margin:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                          color: Color.fromARGB(255, 190, 143, 83),
                          child: ListTile(
                            leading: Icon(
                              Icons.facebook,
                              color: Colors.grey[200],
                            ),
                            title: const Text("www.facebook.com/M-mahmoud A-ismael"),
                          )),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        color: Color.fromARGB(255, 190, 143, 83),
                        child: ListTile(
                          leading: Icon(
                            Icons.school_rounded,
                            color: Colors.grey[200],
                          ),
                          title: const Text("University Of kalamoon"),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        color: Color.fromARGB(255, 190, 143, 83),
                        child: ListTile(
                          leading: Icon(
                            Icons.whatsapp,
                            color: Colors.grey[200],
                          ),
                          title: const Text("+963991647022"),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        color: Color.fromARGB(255, 190, 143, 83),
                        child: ListTile(
                          leading: Icon(
                            Icons.alternate_email,
                            color: Colors.grey[200],
                          ),
                          title: const Text("mhmodismael313@gmail.com"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FadeAnimation(
                delay: 1.5,
                child: Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[800],
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 3,
                        blurRadius: 4,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: 20,),
                      const Text(
                        "Ameer Younes",
                        style: TextStyle(
                            fontFamily: "Pacifico", fontSize: 40, color: Color.fromARGB(
                            255, 201, 201, 201)),
                      ),
                      const Text(
                        "Analayzer",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "SourceSansPro",
                          letterSpacing: 3,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(
                        endIndent: 20,
                        indent: 20,
                        thickness: 1,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        color: Color.fromARGB(255, 190, 143, 83),
                        child: ListTile(

                          leading: Icon(
                            Icons.location_on,
                            color: Colors.grey[200],
                          ),
                          title: const Text("Damascus/Qara",style: TextStyle(color: Colors.black),),
                        ),
                      ),
                      Card(
                          margin:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                          color: Color.fromARGB(255, 190, 143, 83),
                          child: ListTile(
                            leading: Icon(
                              Icons.facebook,
                              color: Colors.grey[200],
                            ),
                            title: const Text("www.facebook.com/Ameer Younes"),
                          )),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        color: Color.fromARGB(255, 190, 143, 83),
                        child: ListTile(
                          leading: Icon(
                            Icons.school_rounded,
                            color: Colors.grey[200],
                          ),
                          title: const Text("University Of kalamoon"),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        color: Color.fromARGB(255, 190, 143, 83),
                        child: ListTile(
                          leading: Icon(
                            Icons.whatsapp,
                            color: Colors.grey[200],
                          ),
                          title: const Text("+963938300943"),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        color: Color.fromARGB(255, 190, 143, 83),
                        child: ListTile(
                          leading: Icon(
                            Icons.alternate_email,
                            color: Colors.grey[200],
                          ),
                          title: const Text("ameer.abomalaz.81@gmail.com"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
