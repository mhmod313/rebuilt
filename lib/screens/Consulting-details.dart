import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class ConversionTablePage_consulting extends StatefulWidget {
  var index;

  ConversionTablePage_consulting(this.index);

  @override
  State<ConversionTablePage_consulting> createState() => _ConversionTablePageState_consulting ();
}

class _ConversionTablePageState_consulting extends State<ConversionTablePage_consulting> {
  CollectionReference ordersCollection =
  FirebaseFirestore.instance.collection('Consulting');
  var rowNumber;
  var buildingMaterials;
  var quantity;
  var measurement;
  var i = 1;
  List<Map<String, dynamic>> userOrders = [];

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
        title: Text('Consulting Details'),
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
          itemCount: ((userOrders.length)-userOrders.length+1).abs(),
          itemBuilder: (context, index) {
            Map<String, dynamic> orderData={};

            if (userOrders.isNotEmpty && widget.index < userOrders.length) {
              orderData = userOrders[widget.index];
              // Rest of your code using orderData
            } else {
              print("Error: Invalid index or empty userOrders list");
              // Additional error handling or alternative actions
            }
            List<DataRow> rows = [];

            for (int i = 1; i <= orderData.length; i++) {
              var rowData = orderData['row$i'];
              if (rowData != null) {
                var rowNumber = rowData['id'] ?? '';
                var buildingMaterials = rowData['buildingMaterials'] ?? '';
                var quantity = rowData['quantity'] ?? '';
                var measurement = rowData['One measurement'] ?? '';

                rows.add(
                  DataRow(cells: [
                    DataCell(Text(rowNumber)),
                    DataCell(Text(buildingMaterials)),
                    DataCell(Text(quantity)),
                    DataCell(Text(measurement)),
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
                        columnSpacing:53,
                        headingRowColor: MaterialStateColor.resolveWith((states) {
                          return Color.fromARGB(150, 255, 178, 18).withOpacity(0.8);
                          // Adjust the color for the heading row
                        }),
                        dataRowColor: MaterialStateColor.resolveWith((states) {
                          return Colors.white;
                        }),
                        columns: [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Building')),
                          DataColumn(label: Text('Quantity')),
                          DataColumn(label: Text('Measurement')),
                        ],
                        rows: rows,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
