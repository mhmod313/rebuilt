import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Getuser extends StatelessWidget {
  final String documentid;
  const Getuser({Key? key, required this.documentid}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    CollectionReference users=FirebaseFirestore.instance.collection('engineering');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentid).get(),
        builder: ((context,snapshot){
      if(snapshot.connectionState==ConnectionState.done){
        Map<String,dynamic> data=snapshot.data!.data() as Map<String,dynamic>;
        return Text('${data['firstname']}');
      }
      return Text("loading....");
    }),
    );
  }
}
