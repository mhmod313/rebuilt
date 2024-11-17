
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../utils/utils.dart';
import 'addoffer-eng.dart';

CollectionReference engineeringCollection =
    FirebaseFirestore.instance.collection('engineering');
CollectionReference ordersCollection =
    engineeringCollection.doc('orders').collection('order');
User? eng = FirebaseAuth.instance.currentUser;

class or_details_eng extends StatefulWidget {
  final Map<String, dynamic> orderData;

  or_details_eng({required this.orderData});

  @override
  State<or_details_eng> createState() => _or_details_engState();
}

class _or_details_engState extends State<or_details_eng> {
  int i = 0;

  ScrollController _scroll=ScrollController();

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls= [];
    String customeremail = '';
    var orderData;

    String note = "";

    String note1 = "";
    String email = "";
    for (int i = 1; i < widget.orderData.length; i++) {
      var orderDataItem = widget.orderData['order$i'];
      if (orderDataItem != null) {
        note1 = orderDataItem['note'];
        email = orderDataItem['Customer email'];
        imageUrls.addAll(List<String>.from(orderDataItem['images']));
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Order Details"),
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
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  height: 300,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 4,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    trackVisibility: true,
                    radius: Radius.circular(40),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: GridView.builder(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 0.0,
                        ),
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              print(index);
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: true,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        color: Colors.black,
                                        child: Center(
                                          child: FadeInImage.assetNetwork(
                                            placeholder: 'assets/placeholder_image.png',
                                            image: imageUrls[index],
                                            fit: BoxFit.contain,
                                            imageErrorBuilder: (context, error, stackTrace) =>
                                                Icon(Icons.error),
                                            placeholderErrorBuilder: (context, error, stackTrace) =>
                                                CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: Colors.black, width: 3.0),
                              ),
                              child: Container(
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder_image.png',
                                  image: imageUrls[index],
                                  fit: BoxFit.cover,
                                  imageErrorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.error),
                                  placeholderErrorBuilder: (context, error, stackTrace) =>
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            ),
                          );
                        },
                      ),



                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Text(
                          "NOTE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${note1}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                StreamBuilder<QuerySnapshot>(
                  stream: ordersCollection
                      .where('engineering email', isEqualTo:eng?.email)
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
                      return Container(
                        height: 60,
                        width: 200,
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                            Map<String, dynamic> orderData =
                            documentSnapshot.data() as Map<String, dynamic>;
                             for (int i = 1; i < orderData.length; i++) {
                              var orderdata = orderData['order$i'];
                              if (orderdata != null) {

                                return Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      if(orderData['value'] == false &&
                                          orderdata['note'] == note1)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                ),
                                                onPressed: () {
                                                  print("${orderdata['note']}");
                                                  for (int i = 2; i < orderData.length; i++) {
                                                    var orderdata = orderData['order$i'];
                                                    if (orderdata != null) {
                                                      note = orderdata['note'] ?? '';
                                                    }
                                                    if (note == orderdata['note']) {
                                                      ordersCollection.doc(documentSnapshot.id).update({'value': true});
                                                    }
                                                    print("${orderdata['note']}");
                                                  }
                                                },
                                                child: Text("Accept order"),
                                              ),
                                            ),
                                            SizedBox(width: 20,),
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                onPressed: () {
                                                  for (int i = 1; i <
                                                      orderData.length; i++) {
                                                    var orderdata = orderData['order$i'];
                                                    if (orderdata != null) {
                                                      note =
                                                          orderdata['note'] ?? '';
                                                    }
                                                    print("${orderdata['note']}");
                                                    if (note ==
                                                        orderdata['note']) {
                                                      ordersCollection
                                                          .doc(
                                                          documentSnapshot.id)
                                                          .delete();
                                                      break; // Exit the loop after deleting the order
                                                    }
                                                    print("${orderdata['note']}");
                                                  }
                                                },
                                                child: Text("Delete Order"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      if(orderData['value'] == true &&
                                          orderdata['note'] == note1)
                                        Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: CircleBorder(),
                                              backgroundColor: Colors.black,
                                              padding: EdgeInsets.all(0),
                                              minimumSize: Size(60, 60),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          add_order_eng(
                                                              i, email)));
                                              setState(() {
                                                if (i == 3)
                                                  i = 1;
                                                else
                                                  i++;
                                              });
                                            },
                                            child: CircleAvatar(
                                                backgroundColor: Color.fromARGB(
                                                    255, 80, 67, 3),
                                                radius: 27,
                                                child: Icon(
                                                  Icons.add_card_sharp,
                                                  size: 30,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ),

                                    ],
                                );
                              }
                            }
                             return Text("");
                          },
                        ),
                      );
                    }
                    return Text('No ${note}');
                  },
                ),



              ],
            ),
          ),
        ));
  }
}
