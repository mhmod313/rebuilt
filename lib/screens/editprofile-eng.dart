import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/utils.dart';

class EditProfileScreen_eng extends StatefulWidget {
  @override
  _EditProfileScreenState_eng createState() => _EditProfileScreenState_eng();
}

class _EditProfileScreenState_eng extends State<EditProfileScreen_eng> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
  _userDataSubscription;

  @override
  void initState() {
    super.initState();
    // Retrieve user data and populate the text fields
    fetchUserData();
  }

  @override
  void dispose() {
    _userDataSubscription.cancel();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void fetchUserData() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userDataSubscription = FirebaseFirestore.instance
          .collection('engineering')
          .where('email', isEqualTo: user.email)
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.size > 0) {
          Map<String, dynamic> userData = snapshot.docs[0].data();
          setState(() {
            _firstnameController.text = userData['firstname'] ?? '';
            _lastnameController.text = userData['lastname'] ?? '';
            _emailController.text = userData['email'] ?? '';
            _phoneController.text = userData['phone'] ?? '';
          });
        }
      });
    }
  }
  void updatedata() async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('engineering')
          .where('email', isEqualTo: user!.email)
          .get();
      if (user != null) {
        try {
          await user.updateEmail(_emailController.text.trim());
          print('Email address updated successfully.');
        } catch (e) {
          print('Error updating email: $e');
        }
      }

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        final DocumentReference profileRef = documentSnapshot.reference;

        await profileRef.update({
          'firstname': _firstnameController.text,
          'lastname': _lastnameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${e}')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(150, 255, 187, 79),
          title: Text('Edit Profile')
      ),
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  elevation: 3,
                  color: const Color.fromARGB(255, 250, 199, 171)
                      .withOpacity(0),
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.all(40.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _firstnameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color:  Colors.orange.withOpacity(0.7),
                            ),
                            labelText: "firstname",
                            labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                const BorderSide(width: 0, style: BorderStyle.none)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your firstname';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _lastnameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.orange.withOpacity(0.7),
                            ),
                            labelText: "lastname",
                            labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                const BorderSide(width: 0, style: BorderStyle.none)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your lastname';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.alternate_email,
                              color:  Colors.orange.withOpacity(0.7),
                            ),
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                const BorderSide(width: 0, style: BorderStyle.none)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                              color:  Colors.orange.withOpacity(0.7),
                            ),
                            labelText: "phone",
                            labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                const BorderSide(width: 0, style: BorderStyle.none)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(150, 255, 187, 79),
                          ),
                          onPressed: updatedata,
                          child: Text('Update Profile'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
