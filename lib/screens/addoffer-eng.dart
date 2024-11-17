import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rebuilt/core/Fade_Animation.dart';

import '../utils/utils.dart';

class add_order_eng extends StatefulWidget {
  int i;
  String email;
  add_order_eng(this.i,this.email);



  @override
  State<add_order_eng> createState() => _add_order_engState();
}

class _add_order_engState extends State<add_order_eng> {

  bool ischeack=false;

  TextEditingController _noteController = TextEditingController();
  List<Map<String, dynamic>> tableData = [];
  int i=1;
  User? currentUser;
  void dispose() {
    // Dispose of the text editing controllers
    tableData.forEach((row) {
      row.forEach((key, controller) => controller.dispose());
    });
    super.dispose();
  }

  void addRow() {
    setState(() {
      tableData.add({
        'id': int,
        'buildingMaterials': TextEditingController(),
        'quantity': TextEditingController(),
        'One measurement': TextEditingController(),
      });
    });
  }

  void removeRow(int index) {
    setState(() {
      tableData.removeAt(index);
    });
  }
  @override
  void initState() {
    tableData = [
      {
        'id': 0,
        'buildingMaterials': TextEditingController(text: ''),
        'quantity': TextEditingController(text: ''),
        'One measurement': TextEditingController(text: ''),
      },
    ];
    super.initState();
  }

  void saveData() async {
    CollectionReference ordersCollection =
    FirebaseFirestore.instance.collection('Consulting');

    DocumentReference documentRef = ordersCollection.doc('order${widget.i}');

    var currentUserEmail = currentUser?.email! ?? '';
    Map<String, dynamic> data = {
      'email':widget.email,
      'email-eng':currentUserEmail,
      'note':_noteController.text,
    };

    for (var row in tableData) {
      var buildingMaterials = row['buildingMaterials']?.text;
      var quantity = row['quantity']?.text;
      var measurement = row['One measurement']?.text;

      if (buildingMaterials != "" &&
          quantity != "" &&
          measurement != "" )
         {
        data['row${tableData.indexOf(row) + 1}'] = {
          'id': '${tableData.indexOf(row)}',
          'buildingMaterials': buildingMaterials,
          'quantity': quantity,
          'One measurement': measurement,
        };
      }
    }

    if (data.isNotEmpty) {
      await documentRef.set(data);
      Navigator.pop(context);
    } else {
      final snackBar = SnackBar(
        content: Text('No valid data to add.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Order"),
        backgroundColor: Color.fromARGB(150, 255, 187, 79),
      ),
      body: SingleChildScrollView(
        child: Container(
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
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Text(
                "Order table ${widget.i}",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 10,
            ),
            Table(
              border: TableBorder.all(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color:
                    Color.fromARGB(150, 255, 178, 18).withOpacity(0.8),
                  ),
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('ID'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Building Materials'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Quantity'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('One measurement'),
                      ),
                    ),
                    TableCell(
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: addRow,
                      ),
                    ),
                  ],
                ),
                for (int i = 0; i < tableData.length; i++)
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${i}"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            cursorColor: Color.fromARGB(150, 255, 178, 18),
                            controller: tableData[i]['buildingMaterials'],
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            cursorColor: Color.fromARGB(150, 255, 178, 18),
                            controller: tableData[i]['quantity'],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            cursorColor: Color.fromARGB(150, 255, 178, 18),
                            controller: tableData[i]['One measurement'],
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => removeRow(i),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 20,),
            Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Do you want to fill out the tender prices?"),
                  Checkbox(
                    activeColor: Colors.black,
                    value: ischeack,
                    onChanged: (value) {
                      setState(() {
                        ischeack = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            if(ischeack==true)
              FadeAnimation(
                delay: 0.9,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: _noteController,
                    maxLines: 5, // Set the maximum lines to 5
                    decoration: InputDecoration(
                      hintText: 'Please enter Note',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                          BorderSide(width: 3, color: Colors.black)),
                      filled: true,
                      fillColor: Colors.grey[400],
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ), // Additional properties and logic for the text field
                  ),
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.black,
                padding: EdgeInsets.all(0),
                minimumSize: Size(60, 60),
              ),
              onPressed: (){
               saveData();
              },
              child: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 80, 67, 3),
                  radius: 27,
                  child: Icon(
                    Icons.send,
                    size: 30,
                    color: Colors.white,
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}

