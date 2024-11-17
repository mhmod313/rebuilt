import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rebuilt/core/Fade_Animation.dart';

import '../utils/utils.dart';
import 'home_screen_eng.dart';


class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {

  User? currentuser=FirebaseAuth.instance.currentUser;
  String collectionName = "users";
  String collectionName1 = "engineering";
  String collectionName2 = "contractor";
  var s;
  List<String> emailList = [];
  List<String> emailList1 = [];
  List<String> emailList2 = [];


  void uu() {
    var firstore = FirebaseFirestore.instance
        .collection(collectionName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        querySnapshot.docs.forEach((DocumentSnapshot doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
          if (data!.containsKey('email')) {
            String email = data['email'];
            setState(() {
              if(data['email']==currentuser!.email)
              emailList.add(email);
            });
            print('Collection "$emailList" does not exist or is empty');
          }
        });
      } else {
        print('Collection "$emailList" does not exist or is empty');
      }
    });
  }
  void ee() {
    var firstore = FirebaseFirestore.instance
        .collection(collectionName1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        querySnapshot.docs.forEach((DocumentSnapshot doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          if (data!.containsKey('email')) {
            String email = data['email'];
            setState(() {
              if(data['email']==currentuser!.email)
              emailList1.add(email);
            });
            print('Collection "$emailList1" does not exist or is empty');
          }
        });
      } else {
        print('Collection "$collectionName1" does not exist or is empty');
      }
    });
  }
  void cc() {
    var firstore = FirebaseFirestore.instance
        .collection(collectionName2)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        querySnapshot.docs.forEach((DocumentSnapshot doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          if (data!.containsKey('email')) {
            String email = data['email'];
            setState(() {
              if(data['email']==currentuser!.email)
              emailList2.add(email);
            });

            print('Collection "$emailList2" does not exist or is empty');
          }
        });
      } else {
        print('Collection "$collectionName2" does not exist or is empty');
      }
    });
  }




  @override
  void initState() {
    uu();
    ee();
    cc();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),
        backgroundColor:Color.fromARGB(150, 255, 187, 79),
      ),
      body:  Container(
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
          child: FadeAnimation(
            delay: 1.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 5,),
                if(emailList.isNotEmpty)
                Column(
                  children: [
                    Container(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: currentuser!.email)
                            .snapshots(),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(
                              color: Colors.white,
                            );
                          }
                          final data = snapshot.data?.docs;
                          return Container(
                            alignment: Alignment.center,
                            height: 35,
                            child: ListView.builder(
                                itemCount: data?.length,
                                itemBuilder: (ctx, index) => Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${data![index]['firstname']} ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 25),
                                      ),
                                      Text(
                                        "${data[index]['lastname']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 25),
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        }),
                      ),
                    ),

                    const Divider(
                      endIndent: 20,
                      indent: 20,
                      thickness: 1,
                      color: Color.fromARGB(186, 255, 208, 117),
                    ),
                    Card(
                      color: Color.fromARGB(186, 255, 208, 117),
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      child: ListTile(
                        leading: Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                        title: Container(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .where('email', isEqualTo: currentuser!.email)
                                .snapshots(),
                            builder: ((context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(
                                  color: Colors.white,
                                );
                              }
                              final data = snapshot.data?.docs;
                              return Container(
                                alignment: Alignment.center,
                                height: 15,
                                child: ListView.builder(
                                    itemCount: data?.length,
                                    itemBuilder: (ctx, index) => Container(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "+963:${data![index]['phone']}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "SourceSansPro",
                                              letterSpacing: 3,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                    Card(
                        color: Color.fromARGB(186, 255, 208, 117),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 25),
                        child: ListTile(
                          leading: Icon(
                            Icons.alternate_email,
                            color: Colors.white,
                          ),
                          title: Container(
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .where('email', isEqualTo: currentuser!.email)
                                  .snapshots(),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(
                                    color: Colors.white,
                                  );
                                }
                                final data = snapshot.data?.docs;
                                return Container(
                                  alignment: Alignment.center,
                                  height: 20,
                                  child: ListView.builder(
                                      itemCount: data?.length,
                                      itemBuilder: (ctx, index) => Container(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${data![index]['email']}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "SourceSansPro",
                                                letterSpacing: 3,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              }),
                            ),
                          ),
                        )),
                  ],
                ),
                if(emailList1.isNotEmpty )
                  Column(
                    children: [
                      Container(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('engineering')
                              .where('email', isEqualTo: currentuser!.email)
                              .snapshots(),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator(
                                color: Colors.white,
                              );
                            }
                            final data = snapshot.data?.docs;
                            return Container(
                              alignment: Alignment.center,
                              height: 35,
                              child: ListView.builder(
                                  itemCount: data?.length,
                                  itemBuilder: (ctx, index) => Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${data![index]['firstname']} ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                        Text(
                                          "${data[index]['lastname']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          }),
                        ),
                      ),

                      const Divider(
                        endIndent: 20,
                        indent: 20,
                        thickness: 1,
                        color: Color.fromARGB(186, 255, 208, 117),
                      ),
                      Card(
                        color: Color.fromARGB(186, 255, 208, 117),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        child: ListTile(
                          leading: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          title: Container(
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('engineering')
                                  .where('email', isEqualTo: currentuser!.email)
                                  .snapshots(),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(
                                    color: Colors.white,
                                  );
                                }
                                final data = snapshot.data?.docs;
                                return Container(
                                  alignment: Alignment.center,
                                  height: 15,
                                  child: ListView.builder(
                                      itemCount: data?.length,
                                      itemBuilder: (ctx, index) => Container(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "+963:${data![index]['phone']}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "SourceSansPro",
                                                letterSpacing: 3,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                      Card(
                          color: Color.fromARGB(186, 255, 208, 117),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: ListTile(
                            leading: Icon(
                              Icons.alternate_email,
                              color: Colors.white,
                            ),
                            title: Container(
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('engineering')
                                    .where('email', isEqualTo: currentuser!.email)
                                    .snapshots(),
                                builder: ((context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(
                                      color: Colors.white,
                                    );
                                  }
                                  final data = snapshot.data?.docs;
                                  return Container(
                                    alignment: Alignment.center,
                                    height: 20,
                                    child: ListView.builder(
                                        itemCount: data?.length,
                                        itemBuilder: (ctx, index) => Container(
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${data![index]['email']}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "SourceSansPro",
                                                  letterSpacing: 3,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  );
                                }),
                              ),
                            ),
                          )),
                    ],
                  ),
                if(emailList2.isNotEmpty)
                  Column(
                    children: [
                      Container(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('contractor')
                              .where('email', isEqualTo: currentuser!.email)
                              .snapshots(),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator(
                                color: Colors.white,
                              );
                            }
                            final data = snapshot.data?.docs;
                            return Container(
                              alignment: Alignment.center,
                              height: 35,
                              child: ListView.builder(
                                  itemCount: data?.length,
                                  itemBuilder: (ctx, index) => Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${data![index]['firstname']} ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                        Text(
                                          "${data[index]['lastname']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          }),
                        ),
                      ),

                      const Divider(
                        endIndent: 20,
                        indent: 20,
                        thickness: 1,
                        color: Color.fromARGB(186, 255, 208, 117),
                      ),
                      Card(
                        color: Color.fromARGB(186, 255, 208, 117),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        child: ListTile(
                          leading: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          title: Container(
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('contractor')
                                  .where('email', isEqualTo: currentuser!.email)
                                  .snapshots(),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(
                                    color: Colors.white,
                                  );
                                }
                                final data = snapshot.data?.docs;
                                return Container(
                                  alignment: Alignment.center,
                                  height: 15,
                                  child: ListView.builder(
                                      itemCount: data?.length,
                                      itemBuilder: (ctx, index) => Container(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "+963:${data![index]['phone']}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "SourceSansPro",
                                                letterSpacing: 3,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                      Card(
                          color: Color.fromARGB(186, 255, 208, 117),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: ListTile(
                            leading: Icon(
                              Icons.alternate_email,
                              color: Colors.white,
                            ),
                            title: Container(
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('contractor')
                                    .where('email', isEqualTo: currentuser!.email)
                                    .snapshots(),
                                builder: ((context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(
                                      color: Colors.white,
                                    );
                                  }
                                  final data = snapshot.data?.docs;
                                  return Container(
                                    alignment: Alignment.center,
                                    height: 20,
                                    child: ListView.builder(
                                        itemCount: data?.length,
                                        itemBuilder: (ctx, index) => Container(
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${data![index]['email']}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "SourceSansPro",
                                                  letterSpacing: 3,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  );
                                }),
                              ),
                            ),
                          )),
                    ],
                  ),
              ],
            ),
          ),
        ),
    );
  }
}
