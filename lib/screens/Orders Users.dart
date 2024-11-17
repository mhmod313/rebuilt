import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import 'orderdetails.dart';

class ViewOrder extends StatefulWidget {
  @override
  _ViewOrderState createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {



  CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  List<Map<String, dynamic>> userOrders = [];
  String order='false';
  @override
  void initState() {
    super.initState();
    fetchUserOrders();
  }

  Future<void> fetchUserOrders() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        QuerySnapshot snapshot = await ordersCollection
            .where('email', isEqualTo: currentUser.email)
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Users'),
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
            Map<String, dynamic> orderData = userOrders[index];
              rowNumber = orderData['row1']['id'] ?? ""; // Handle null values
              buildingMaterials = orderData['row1']['buildingMaterials'] ?? "";
              quantity = orderData['row1']['quantity'] ?? "";
              measurement = orderData['row1']['One measurement'] ?? "";
            return GestureDetector(
              onTap: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConversionTablePage(index,order)));
                });
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
                        color: Color.fromARGB(150, 255, 178, 18).withOpacity(0.8),
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
                        SizedBox(height: 20,),
                        Container(width: 800,height: 2,color: Colors.black,),
                        if(orderData['value']=='false')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  minimumSize: Size(40, 30),
                                ),
                                onPressed: (){
                                  setState(() {
                                    if(orderData['order']=='order${index+1}'){
                                      ordersCollection.doc('order${index+1}').update({'value': 'true'});
                                    }
                                    print(orderData['order']);
                                    print(index+1);
                                  });


                                },
                                child: Text("publish the order")
                            ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  minimumSize: Size(40, 30),
                                ),
                                onPressed: (){
                                  setState(() {
                                    if(orderData['order']=='order${index+1}'){
                                      ordersCollection.doc('order${index+1}').update({'value': 'stopped'});
                                    }
                                    print(orderData['order']);
                                    print(index+1);
                                  });
                                },
                                child:Text("Stop the order ")
                              ),

                          ],),
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
