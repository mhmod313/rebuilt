import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/utils.dart';

class EngineeringFlipCardsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(150, 255, 187, 79),
          title: Text('View Engineering'),
      ),
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
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
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('engineering').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              final data = snapshot.data!.docs;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final document = data[index];
                  final documentData = document.data() as Map<String, dynamic>;
                  final firstname = documentData['firstname'] ?? 'No data available';
                  final lastname = documentData['lastname'] ?? 'No data available';
                  final phone = documentData['phone'] ?? 'No data available';
                  final description = documentData['email'] ?? 'No data available';

                  if(documentData['email']!=null)
                  return FlipCard(
                    front: Card(
                      elevation: 8,
                      color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
                      child: ListTile(
                        title: Row(children: [Text(firstname),Text(lastname)],),
                        subtitle: Text(description),
                      ),
                    ),
                    back: Card(
                      child: ListTile(
                        title: Text(lastname),
                        subtitle: Text('${phone}'),
                      ),
                    ),
                  );
                  else
                    return Text("");
                },
              );
            },
          ),
        ),
      ),
    );
  }
}