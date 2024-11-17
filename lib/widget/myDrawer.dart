import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rebuilt/core/Fade_Animation.dart';
import 'package:rebuilt/screens/About.dart';
import 'package:rebuilt/screens/Developers.dart';
import 'package:rebuilt/screens/Rating.dart';
import 'package:rebuilt/screens/feedback.dart';
import 'package:rebuilt/screens/profile.dart';
import 'package:rebuilt/widget/getusername.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/signin_screen.dart';
import '../utils/utils.dart';

class MyDrawer extends StatefulWidget {
  final double width;

  const MyDrawer({Key? key, required this.width}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.9, 0.3, 0.5, 0.2],
          colors: [
            hexStringToColor("#3E4C59"),
            hexStringToColor("#3E4C59"),
            hexStringToColor("#3E4C59"),
            hexStringToColor("#3E4C59"),
          ],
        ),
      ),
      child: SafeArea(
        child: Theme(
          data: ThemeData(brightness: Brightness.dark),
          child: SizedBox(
            width: widget.width,
            height: double.infinity,
            child: FadeAnimation(
              delay: 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 15),
                    height: 50,
                    decoration: BoxDecoration(
                      color:Color.fromARGB(186, 255, 208, 117),
                    ),
                    child: Text(
                      "welcome:${currentUser?.email ?? ''}",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20,),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => profile()),
                      );
                    },
                  ),
                   ListTile(
                    leading: Icon(Icons.feedback),
                    title: Text('Feedback'),
                     onTap: (){
                       Navigator.push(context,MaterialPageRoute(builder: (context)=>feedback()));
                     },
                  ),
                   ListTile(
                    leading: Icon(Icons.insert_emoticon_rounded),
                    title: Text('Rating'),
                     onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>RatingBarScreen()));
                     },
                  ),
                   ListTile(
                    leading: Icon(Icons.account_box_outlined),
                    title: Text('Developers'),
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>DEvelopers())
                      );
                    },
                  ),
                   ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About'),
                     onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>About()));
                     },

                  ),
                  SizedBox(height:347),
                  Container(
                    width:double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        bottom:BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                        left:  BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                        right:BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.1, 0.4, 0.3, 0.9],
                        colors: [
                          hexStringToColor("#3E4C59"),
                          hexStringToColor("#3E4C59"),
                          hexStringToColor("#3E4C59"),
                          hexStringToColor("#FFCFAF")
                        ],
                      ),
                    ),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Logout",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white
                        ),),
                        IconButton(
                          color: Colors.white,
                          iconSize: 40,
                          onPressed: () {
                            FirebaseAuth.instance.signOut().then((value) {
                              print("Signed Out");
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => SignInScreen()));
                            });
                          }, icon: Icon(Icons.logout_rounded),
                        ),
                      ],

                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}