import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:rebuilt/screens/table_tender.dart';

import '../utils/utils.dart';

class Offer_made extends StatefulWidget {
  const Offer_made({Key? key}) : super(key: key);

  @override
  State<Offer_made> createState() => _Offer_madeState();
}

class _Offer_madeState extends State<Offer_made> {
  List<Map<String, dynamic>> userOrders = [];

  CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orderswithprice');

  void sendEmail(String recipientEmail, String subject, String body) async {
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: [recipientEmail],
    );

    try {
      await FlutterEmailSender.send(email);
      print('Email sent successfully!');
    } catch (e) {
      print('Error occurred while sending email: $e');
    }
  }

  Future<void> fetchUserOrders() async {
    User? currentCon = FirebaseAuth.instance.currentUser;

    if (currentCon != null) {
      try {
        QuerySnapshot snapshot = await ordersCollection
            .where('value', isEqualTo: false)
            .where('email', isEqualTo: currentCon.email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          setState(() {
            userOrders = snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
          });
        } else {
          print('No orders found for the current user.');
        }
      } catch (error) {
        print('Error fetching user orders: $error');
      }
    } else {
      print('User not logged in.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserOrders();
    print(userOrders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contractor offers'),
        backgroundColor: Color.fromARGB(150, 255, 187, 79),
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
        child: ListView.builder(
          padding: EdgeInsets.only(top: 10),
          itemCount: userOrders.length,
          itemBuilder: (context, index) {
            var rowNumber;
            var buildingMaterials;
            var quantity;
            var measurement;
            var total_price;
            var Duration;
            Map<String, dynamic> orderData = userOrders[index];
            rowNumber = orderData['row1'][0]['id'] ?? ""; // Handle null values
            buildingMaterials = orderData['row1'][0]['buildingMaterials'] ?? "";
            quantity = orderData['row1'][0]['quantity'] ?? "";
            measurement = orderData['row1'][0]['One measurement'] ?? "";
            total_price = orderData['total price']?? "";
            Duration = orderData['Duration']?? "";
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => tender(index)),
                );
              },
              child: Container(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, // Adjust the outline color as desired
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.black,
                ),
                child: Card(
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
                        color:
                            Color.fromARGB(150, 255, 178, 18).withOpacity(0.8),
                        // Adjust the fill color as desired
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the border radius as desired
                      ),
                      child: Text(
                        'order ${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text('id: $rowNumber'),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Building Materials: $buildingMaterials'),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Quantity: $quantity'),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Measurement: $measurement'),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Duration: $Duration'),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Total Price: $total_price'),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Order status: wating"),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 800,
                          height: 2,
                          color: Colors.black,
                        ),
                        if (orderData['value'] == false)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    minimumSize: Size(40, 30),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (orderData['order'] ==
                                          'order${index + 1}') {
                                        ordersCollection
                                            .doc('order${index + 1}')
                                            .update({'value': true});
                                      }
                                      print(orderData['order']);
                                      print(index + 1);
                                    });
                                    sendEmail(
                                        orderData['email con'],
                                        "The offer is accepted",
                                        "Your offer has been accepted");
                                  },
                                  child: Text("Accept the Offer")),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    minimumSize: Size(40, 30),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (orderData['order'] ==
                                          'order${index + 1}') {
                                        ordersCollection
                                            .doc('order${index + 1}')
                                            .update({'value': false});
                                      }
                                      print(orderData['order']);
                                      print(index + 1);
                                    });
                                    sendEmail(
                                        orderData['email con'],
                                        "The offer is rejected",
                                        "Your offer has been rejected");

                                  },
                                  child: Text("cancle the order ")),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
