import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'orderdetail-eng.dart';

CollectionReference engineeringCollection =
FirebaseFirestore.instance.collection('engineering');
CollectionReference ordersCollection =
engineeringCollection.doc('orders').collection('order');
User? eng = FirebaseAuth.instance.currentUser;

class accepted_order_eng extends StatefulWidget {
  const accepted_order_eng({Key? key}) : super(key: key);

  @override
  State<accepted_order_eng> createState() => _accepted_order_engState();
}

class _accepted_order_engState extends State<accepted_order_eng> {

  String customeremail = '';
  String note = '';
  List<String> imageUrls = [];
  var orderData;
  var orders;
  int i = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accepted Orders'),
        backgroundColor: Color.fromARGB(150, 255, 187, 79),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
        child: StreamBuilder<QuerySnapshot>(
          stream: ordersCollection
              .where('engineering email', isEqualTo: eng?.email)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot documentSnapshot =
                  snapshot.data!.docs[index];
                  Map<String, dynamic> orderData =
                  documentSnapshot.data() as Map<String, dynamic>;
                  for (int i = 1; i < orderData.length; i++) {
                    var orderdata = orderData['order${i}'];
                    if (orderdata != null) {
                      customeremail = orderdata['Customer email'] ?? '';
                      note = orderdata['note'] ?? '';
                      imageUrls = List<String>.from(orderdata['images']);
                    }
                  }
                  if(orderData['value']==true)
                  return Card(
                    shadowColor: Colors.white,
                    elevation: 2,
                    color: Color.fromARGB(150, 255, 246, 212),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ListTile(
                      title: Container(
                        padding: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(150, 255, 178, 18)
                              .withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          'Order ${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                              SizedBox(height: 5),
                              Text('ID: ${index + 1}',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('Customer Email: $customeremail',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text('Note: $note',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text('Image URLs: $imageUrls',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                          Container(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>or_details_eng(orderData: orderData,)));
                              },
                              child: Text("view order"),
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                  return Text('');
                },
              );
            }
            return Text('No orders found');
          },
        ),
      ),
    );
  }
}
