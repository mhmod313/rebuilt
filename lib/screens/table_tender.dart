import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'acceptedorder-eng.dart';

class tender extends StatefulWidget {
  int index;

  tender(this.index);

  @override
  State<tender> createState() => _tenderState();
}

class _tenderState extends State<tender> {
  List<Map<String, dynamic>> userOrders = [];

  Future<void> fetchUserOrders() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference ordersCollection =
        FirebaseFirestore.instance.collection('orderswithprice');
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
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tender Details'),
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
          itemCount: ((userOrders.length) - userOrders.length + 1).abs(),
          itemBuilder: (context, index) {
            Map<String, dynamic> orderData = {};
            if (userOrders.isNotEmpty && widget.index < userOrders.length) {
              orderData = userOrders[widget.index];
              // Rest of your code using orderData
            } else {
              print("Error: Invalid index or empty userOrders list");
              // Additional error handling or alternative actions
            }
            List<DataRow> rows = [];
            var j=0;
            for (int i = 1; i <= orderData.length; i++) {

              var rowData = orderData['row$i'];
              if (rowData != null) {
                var rowNumber = rowData[j]['id'] ?? '';
                var buildingMaterials = rowData[j]['buildingMaterials'] ?? '';
                var quantity = rowData[j]['quantity'] ?? '';
                var measurement = rowData[j]['One measurement'] ?? '';
                var Price = rowData[1];

                rows.add(
                  DataRow(cells: [
                    DataCell(Text(rowNumber)),
                    DataCell(Text(buildingMaterials)),
                    DataCell(Text(quantity)),
                    DataCell(Text(measurement)),
                    DataCell(Text("${Price}\$")),
                  ]),
                );
              }
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: 400,
                      child: DataTable(
                        columnSpacing: 30,
                        headingRowColor:
                            MaterialStateColor.resolveWith((states) {
                          return Color.fromARGB(150, 255, 178, 18)
                              .withOpacity(0.8);
                          // Adjust the color for the heading row
                        }),
                        dataRowColor: MaterialStateColor.resolveWith((states) {
                          return Colors.white;
                        }),
                        columns: [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Building')),
                          DataColumn(label: Text('Quantity')),
                          DataColumn(label: Text('Measur')),
                          DataColumn(label: Text('Price')),
                        ],
                        rows: rows,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 150,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "total price: ${orderData['total price']}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
