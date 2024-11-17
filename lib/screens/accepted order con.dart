import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class acc_order_con extends StatefulWidget {
  const acc_order_con({Key? key}) : super(key: key);

  @override
  State<acc_order_con> createState() => _acc_order_conState();
}

class _acc_order_conState extends State<acc_order_con> {

  List<Map<String, dynamic>> userOrders = [];

  CollectionReference ordersCollection =
  FirebaseFirestore.instance.collection('orderswithprice');
  User? currentCon = FirebaseAuth.instance.currentUser;
  Future<void> fetchUserOrders() async {


    if (currentCon != null) {
      try {
        QuerySnapshot snapshot = await ordersCollection
            .where('value', isEqualTo: true)
            .where('email con', isEqualTo: currentCon!.email)
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
            Map<String, dynamic> orderData = userOrders[index];
            rowNumber = orderData['row1'][0]['id'] ?? ""; // Handle null values
            buildingMaterials = orderData['row1'][0]['buildingMaterials'] ?? "";
            quantity = orderData['row1'][0]['quantity'] ?? "";
            measurement = orderData['row1'][0]['One measurement'] ?? "";
            total_price = orderData['total price']?? "";
            return GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => tender(index)),
                // );
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
                        Text('Building Materials: $buildingMaterials'),
                        Text('Quantity: $quantity'),
                        Text('Measurement: $measurement'),
                        Text('Total Price: $total_price'),
                        Text("Order status: accepted"),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 800,
                          height: 2,
                          color: Colors.black,
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
