import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rebuilt/screens/home_screenuser.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../utils/utils.dart';
import 'dart:io' show File, Platform;

CollectionReference engineeringCollection =
    FirebaseFirestore.instance.collection('engineering');
CollectionReference ordersCollection =
    engineeringCollection.doc('orders').collection('order');
CollectionReference ordersCollection2 =
    FirebaseFirestore.instance.collection('orders');

class MyTable extends StatefulWidget {
  int i;

  MyTable(this.i);

  @override
  _MyTableState createState() => _MyTableState();
}

class _MyTableState extends State<MyTable> {
  List<Map<String, dynamic>> tableData = [];
  String? selectedOption;
  int selectedDay = 7; // Default value
  List<int> days = List.generate(30, (index) => index + 1);
  bool isChecked = false;
  bool isCheck = false;
  bool value = false;
  TextEditingController _noteController = TextEditingController();
  final picker = ImagePicker();
  List<XFile>? _pickedImage = [];
  List<File> _selectedFiles = [];
  String? selectedemail;

  User? curr12 = FirebaseAuth.instance.currentUser;

  var documentCount;

  void selectImages() async {
    final List<XFile>? selectedImages = await picker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      _pickedImage!.addAll(selectedImages);
    }
    setState(() {});
  }

  List<Map<String, dynamic>> engineers = [];
  String value1 = 'false';

  Stream<QuerySnapshot> getEngineersStream() {
    CollectionReference engineersCollection =
        FirebaseFirestore.instance.collection('engineering');

    return engineersCollection.snapshots();
  }

  void sendtoENG() async {
    final note = 'Your note text';

    List<String> imageUrls = [];
    for (var image in _pickedImage!) {
      // Upload the image to Firebase Storage
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child('order${widget.i}')
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      final uploadTask = storageRef.putFile(File(image.path));
      final snapshot = await uploadTask.whenComplete(() {});

      // Get the image URL after the upload is complete
      final downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    Map<String, dynamic> data = {
      'engineering email': selectedemail,
      'value': value,
    };
    data['order${widget.i}'] = {
      'note': _noteController.text,
      'Customer email': currentUser?.email,
      'images': imageUrls,
    };

    if (_noteController.text != "" && imageUrls.isNotEmpty) {
      if (data.isNotEmpty) {
        await ordersCollection.add(data);
        Navigator.pop(context);
      } else {
        final snackBar = SnackBar(
          content: Text('No valid data to add.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(
        content: Text('No valid data to add.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    getEngineersStream();
    //ss();
    print("errrrrrrrrrrrrrrrrrrrrrrrrr");
    countDocumentsWithEmail(curr12!.email);
    print("qaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    super.initState();
    tableData = [
      {
        'id': 0,
        'buildingMaterials': TextEditingController(text: 'Cement'),
        'quantity': TextEditingController(text: '50'),
        'One measurement': TextEditingController(text: 'cm'),
      },
    ];


  }

  @override
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

  void saveData() async {
    CollectionReference ordersCollection =
        FirebaseFirestore.instance.collection('orders');

    DocumentReference documentRef = ordersCollection.doc('order${widget.i}');

    var currentUserEmail = currentUser?.email! ?? '';
    Map<String, dynamic> data = {
      'order': 'order${widget.i}',
      'email': currentUserEmail,
      'selectedOption': selectedOption,
      'selectedDay': selectedDay,
      'value': value1,
    };

    List<String> imageUrls = [];
    for (var image in _pickedImage!) {
      // Upload the image to Firebase Storage
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child('order${widget.i}')
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      final uploadTask = storageRef.putFile(File(image.path));
      final snapshot = await uploadTask.whenComplete(() {});

      // Get the image URL after the upload is complete
      final downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    data['images'] = imageUrls;

    for (var row in tableData) {
      var buildingMaterials = row['buildingMaterials']?.text;
      var quantity = row['quantity']?.text;
      var measurement = row['One measurement']?.text;

      if (buildingMaterials != "" &&
          quantity != "" &&
          measurement != "" &&
          selectedOption != null) {
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

  Future<int> countDocumentsWithEmail(var email) async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('orders');
      QuerySnapshot querySnapshot =
          await usersCollection.where('email', isEqualTo: curr12!.email).get();
      // Get the number of documents that match the query
       documentCount = querySnapshot.size;
      print("${documentCount}");
      return documentCount;
    } catch (e) {
      print('Error counting documents: $e');
      return -1; // Return -1 to indicate an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(150, 255, 187, 79),
        title: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: currentUser!.email)
                .snapshots(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(
                  color: Colors.white,
                );
              }
              final data = snapshot.data?.docs;
              return Container(
                alignment: Alignment.center,
                height: 95,
                child: ListView.builder(
                    itemCount: data?.length,
                    itemBuilder: (ctx, index) => Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${data![index]['firstname']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                            ],
                          ),
                        )),
              );
            }),
          ),
        ),
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
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                width: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[400],
                ),
                child: Text(
                  "Order table ${widget.i}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 360,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      topLeft: Radius.circular(40)),
                  color: Color.fromARGB(255, 190, 143, 83),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 5,
                      blurRadius: 0,
                      offset: Offset(-1, 0),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              "Duration of completion",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            alignment: Alignment.topCenter,
                          ),
                          Container(
                            width: 150, // Adjust the width as needed
                            height: 3, // Adjust the height as needed
                            color: Color.fromARGB(255, 80, 67, 3),
                            // Specify the color of the line
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              value: selectedDay,
                              items: days.map((int day) {
                                return DropdownMenuItem<int>(
                                  value: day,
                                  child: Text("Day ${day.toString()}"),
                                );
                              }).toList(),
                              onChanged: (int? day) {
                                setState(() {
                                  selectedDay =
                                      day!; // Update selected day in Firebase
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 190, 143, 83),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(-1, 0),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "I want to fill out \n the tender  table",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Checkbox(
                                        activeColor: Colors.black,
                                        value: isCheck,
                                        onChanged: (value) {
                                          setState(() {
                                            isCheck = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1.0, // Adjust the width as needed
                      height: 200, // Adjust the height as needed
                      color: Colors.black, // Specify the color of the line
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Type of Request",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Container(
                            width: 150, // Adjust the width as needed
                            height: 3, // Adjust the height as needed
                            color: Color.fromARGB(255, 80, 67, 3),
                            // Specify the color of the line
                          ),
                          RadioListTile<String>(
                            activeColor: Colors.black,
                            title: const Text(
                              'Covering',
                              style: TextStyle(color: Colors.black),
                            ),
                            value: 'Covering',
                            groupValue: selectedOption,
                            onChanged: (String? value) {
                              setState(() {
                                selectedOption = value;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            activeColor: Colors.black,
                            title: const Text(
                              'Restoration',
                              style: TextStyle(color: Colors.black),
                            ),
                            value: 'Restoration',
                            groupValue: selectedOption,
                            onChanged: (String? value) {
                              setState(() {
                                selectedOption = value;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            activeColor: Colors.black,
                            title: const Text(
                              'Construct',
                              style: TextStyle(color: Colors.black),
                            ),
                            value: 'Construct',
                            groupValue: selectedOption,
                            onChanged: (String? value) {
                              setState(() {
                                selectedOption = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              if (selectedOption != null && isCheck)
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
              SizedBox(
                height: 19,
              ),
              if (!isCheck)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: getEngineersStream(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          List<Map<String, dynamic>> engineers = snapshot
                              .data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            return {
                              if (data['email'] != null) 'email': data['email'],
                              'firstName': data['firstname'],
                              'lastName': data['lastname'],
                            };
                          }).toList();
                          return Container(
                            padding: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(40),
                                  topLeft: Radius.circular(40)),
                              color: Color.fromARGB(255, 190, 143, 83),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 3,
                                  blurRadius: 0,
                                  offset: Offset(-1, 0),
                                ),
                              ],
                            ),
                            child:
                                DropdownButtonFormField<Map<String, dynamic>>(
                              hint: Text("$selectedemail"),
                              items: engineers
                                  .where(
                                      (engineer) => engineer['email'] != null)
                                  .map((engineer) {
                                return DropdownMenuItem<Map<String, dynamic>>(
                                  value: engineer,
                                  child: Text('${engineer['email']}'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  if (value != null && value['email'] != null) {
                                    selectedemail = value['email'];
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
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
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.all(0),
                            minimumSize: Size(60, 60),
                          ),
                          onPressed: selectImages,
                          child: CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 80, 67, 3),
                              radius: 27,
                              child: Icon(
                                Icons.image,
                                size: 30,
                                color: Colors.white,
                              )),
                        ),
                        SizedBox(width: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.all(0),
                            minimumSize: Size(60, 60),
                          ),
                          onPressed: sendtoENG,
                          child: CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 80, 67, 3),
                              radius: 27,
                              child: Icon(
                                Icons.send,
                                size: 30,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              SizedBox(
                height: 10,
              ),
              if (isCheck && selectedOption != null)
                Container(
                  width: 200,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(40),
                        topLeft: Radius.circular(40)),
                    color: Color.fromARGB(255, 190, 143, 83),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 5,
                        blurRadius: 0,
                        offset: Offset(-1, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.all(0),
                          minimumSize: Size(60, 60),
                        ),
                        onPressed: (){
                          if(documentCount<3)
                          saveData();
                          else{
                            final snackBar = SnackBar(
                              content: Text('you have 3 order'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                        child: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 80, 67, 3),
                            radius: 27,
                            child: Icon(
                              Icons.save,
                              size: 30,
                              color: Colors.white,
                            )),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.all(0),
                          minimumSize: Size(60, 60),
                        ),
                        onPressed: selectImages,
                        child: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 80, 67, 3),
                            radius: 27,
                            child: Icon(
                              Icons.image,
                              size: 30,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
