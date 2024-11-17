import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import '../utils/utils.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class ConversionTablePage_con extends StatefulWidget {
  var index;
  String value1;
  String email;

  ConversionTablePage_con(this.index, this.value1, this.email);

  @override
  State<ConversionTablePage_con> createState() =>
      _ConversionTablePage_conState();
}

class _ConversionTablePage_conState extends State<ConversionTablePage_con> {
  List<Map<String, dynamic>> tableData = [];
  List<TextEditingController> priceControllers = [];

  bool isCheck = false;
  CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  User? con = FirebaseAuth.instance.currentUser;
  var rowNumber;
  var buildingMaterials;
  var quantity;
  var measurement;
  var rowNumber1;
  var buildingMaterials1;
  var quantity1;
  var measurement1;
  var price1;

  String selectedDuration = '1 month';

  double sum = 0;

  var row1;
  var pcr;

  //var i = 1;
  List<Map<String, dynamic>> userOrders = [];
  List<String> price = [];

  @override
  void initState() {
    super.initState();
    print("emailllllllllllllllllllllllllll" + widget.email);
    fetchUserOrders();
  }

  void saveData() async {
    CollectionReference ordersCollection =
        FirebaseFirestore.instance.collection('orderswithprice');

    DocumentReference documentRef =
        ordersCollection.doc('order${widget.index + 1}');

    List<Map<String, dynamic>> rows = [];
    Map<String, dynamic> orderData;
    orderData = userOrders[widget.index];
    Map<String, dynamic> data = {
      'order': 'order${widget.index + 1}',
      'email': widget.email,
      'email con': con!.email,
      'total price': sum,
      'value': false,
      'Duration':selectedDuration,
    };
    // Read string data from a table and populate the rows list
    for (int i = 1; i <= orderData.length - 6; i++) {
      var rowData = orderData['row$i'];
      if (rowData != null) {
        rowNumber1 = rowData['id'] ?? '';
        buildingMaterials1 = rowData['buildingMaterials'] ?? '';
        quantity1 = rowData['quantity'];
        measurement1 = rowData['One measurement'] ?? '';
      }
      // Add the row data to the rows list

      data["row$i"] = {
        rowData,
        price[i - 1],
      };
    }

    print("llllllllllllllllllllll $price");

    await documentRef.set(data);

    if (data.isNotEmpty) {
      Navigator.pop(context);
    } else {
      final snackBar = SnackBar(
        content: Text('No valid data to add.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

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

  sendnotification() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: "basic_channel",
      title: "You have a new offer",
      body: "An offer has been sent to you from a contractor",
    ));
  }

  @override
  void dispose() {
    // Dispose of the text editing controllers
    tableData.forEach((row) {
      row.forEach((key, controller) => controller.dispose());
    });

    for (var controller in priceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> fetchUserOrders() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        QuerySnapshot snapshot = await ordersCollection
            .where('value', isEqualTo: widget.value1)
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
        title: Text('Order Details'),
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

            priceControllers = [];

            List<List<dynamic>> rowsData1 = [];

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
                    // DataCell(TextField(
                    //   decoration: InputDecoration(
                    //     focusedBorder: UnderlineInputBorder(
                    //       borderSide: BorderSide(color: Colors.black),
                    //     ),
                    //   ),
                    //   cursorColor: Colors.black,
                    //   keyboardType: TextInputType.number,
                    //   controller: priceController,
                    // )),
                  ]),
                );
              }
            }

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: 400,
                      child: DataTable(
                        columnSpacing: 23,
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
                          DataColumn(label: Text('Measurement')),
                          // DataColumn(label: Text('Price')),
                        ],
                        rows: rows,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 5,
                          blurRadius: 0,
                          offset: Offset(-1, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Type project: ${orderData['selectedOption']}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Do you want to fill out the tender prices?"),
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
                  if (isCheck == true)
                    Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: 300,
                      child: Scrollbar(
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.manual,
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              for (int i = 0; i < orderData.length - 6; i++)
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: TextFormField(
                                    cursorColor: Colors.white,
                                    keyboardType: TextInputType.number,
                                    controller: TextEditingController(),
                                    decoration: InputDecoration(
                                      labelText: 'Enter a price${i + 1}',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 2,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      pcr = value;
                                      print("price befor  $price");
                                    },
                                    onEditingComplete: () {
                                      if (pcr != null && pcr.isNotEmpty) {
                                        if (price.length <= i) {
                                          setState(() {
                                            price.add(pcr);
                                            sum += double.parse(pcr);
                                          });
                                        }
                                        ;
                                      } else {
                                        final snackBar = SnackBar(
                                          content: Text('No valid price  .'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
                                  ),
                                ),
                              DropdownButton<String>(
                                value: selectedDuration,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedDuration = newValue!;
                                  });
                                },
                                items: <String>[
                                  '1 month',
                                  '2 month',
                                  '3 month',
                                  '4 month',
                                  '5 month',
                                  '6 months',
                                  '7 month',
                                  '8 month',
                                  '9 month',
                                  '10 month',
                                  '11 month',
                                  '12 month',
                                  '1 year',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "total price: ${sum}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.all(0),
                                  minimumSize: Size(60, 60),
                                ),
                                onPressed: () {
                                  if (pcr != null && pcr.isNotEmpty) {
                                    saveData();
                                    sendnotification();
                                    sendEmail(
                                        widget.email,
                                        "A tender offer has been received",
                                        "You can view the offer in our app");
                                  } else {
                                    final snackBar = SnackBar(
                                      content: Text('No valid price  .'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 80, 67, 3),
                                  radius: 27,
                                  child: Icon(
                                    Icons.send,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
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
