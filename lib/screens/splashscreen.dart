
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rebuilt/screens/home_screen_contractor.dart';
import 'package:rebuilt/screens/home_screen_eng.dart';
import 'package:rebuilt/screens/home_screenuser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/utils.dart';

class ImageSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<ImageSplashScreen> {
  List<String> emailList = [];
  List<String> emailList1 = [];
  List<String> emailList2 = [];
  User? currentuser;

  Future<void> getUserProfile() async {
    User? user = await FirebaseAuth.instance.currentUser;
    setState(() {
      currentuser = user;
    });
  }

  void uu() {
    var firstore = FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        querySnapshot.docs.forEach((DocumentSnapshot doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
          if (data!.containsKey('email')) {
            String email = data['email'];
            emailList.add(email);
          }
        });
      } else {
        print('Collection "users" does not exist or is empty');
      }
    });
  }

  void ee() {
    var firstore = FirebaseFirestore.instance
        .collection('engineering')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        querySnapshot.docs.forEach((DocumentSnapshot doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          if (data!.containsKey('email')) {
            String email = data['email'];
            emailList1.add(email);
          }
        });
      } else {
        print('Collection "engineering" does not exist or is empty');
      }
    });
  }

  void cc() {
    var firstore = FirebaseFirestore.instance
        .collection('contractor')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        querySnapshot.docs.forEach((DocumentSnapshot doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          if (data!.containsKey('email')) {
            String email = data['email'];
            emailList2.add(email);
          }
        });
      }
    });
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences _pre = await SharedPreferences.getInstance();
    var e = _pre.getString("e");
    var p = _pre.getString("p");
    if (emailList.isNotEmpty) {
      emailList.forEach((email) {
        if (email == e) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      });
    }
    if (emailList1.isNotEmpty) {
      emailList1.forEach((email) {
        if (email == e) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomeScreeneng()));
        }
      });
    }
    if (emailList2.isNotEmpty) {
      emailList2.forEach((email) {
        if (email == e) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomeScreencontractor()));
        }
      });
    }
  }
  @override
  void initState() {
    getUserProfile()??" ";
    navigationPage();
    uu();
    ee();
    cc();
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.1, 0.4, 0.7, 0.9],
          colors: [
            hexStringToColor("#3E4C59"),
            hexStringToColor("#FFCF9F"),
            hexStringToColor("#FFCF9F"),
            hexStringToColor("#F2D7A6")
          ],
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              hexStringToColor("#fff").withOpacity(0.2), BlendMode.dstATop),
          image: const AssetImage(
            'assets/Images/01b4bd84253993.5d56acc35e143.jpg',
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(
              "assets/Images/civil-engineering.png",
              width: 150,
              height: 150,
            ),
          ),
          if(currentuser?.email!=null)
          Text(
            " ${currentuser!.email}",
            style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: Colors.black,
              padding: EdgeInsets.all(0),
              minimumSize: Size(60, 60),
            ),
            onPressed: navigationPage,
            child: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 80, 67, 3),
                radius: 27,
                child: Icon(
                  Icons.refresh,
                  size: 30,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    ));
  }
}
