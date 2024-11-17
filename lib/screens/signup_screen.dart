import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart ' as http;
import 'package:path/path.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:rebuilt/core/Fade_Animation.dart';
import 'package:rebuilt/reusable_widgets/reusable_widget.dart';
import 'package:rebuilt/screens/home_screen_contractor.dart';
import 'package:rebuilt/screens/home_screen_eng.dart';
import '../utils/utils.dart';
import '../widget/firebase_api.dart';
import 'home_screenuser.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/src/material/dropdown.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _FirstNameTextController = TextEditingController();
  TextEditingController _LastNameTextController = TextEditingController();
  TextEditingController _PhoneTextController = TextEditingController();
  TextEditingController _type = TextEditingController();
  bool passToggle = false;
  final _formfiled = GlobalKey<FormState>();
  String _selected = "user";
  final _typeuser = ["user", "engineering", "contractor"];
  var _image;
  ImagePicker pic = ImagePicker();

  _myformstate() {
    _selected = _typeuser[0];
  }



  void pickImage() async {
    final image = await pic.pickImage(
        source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
    });
  }

  Future uploadFile() async {
    if (_image == null) return;

    final fileName = basename(_image!.path);
    final destination = 'files/$fileName';

    var task = FirebaseApi.uploadFile(destination, _image!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }


  @override
  Widget build(BuildContext context) {
    if (_selected != _typeuser[1] && _selected != _typeuser[2]) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
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
                stops: const [0.1, 0.4, 0.7, 0.9],
                colors: [
                  hexStringToColor("#3E4C59"),
                  hexStringToColor("#FFCF9F"),
                  hexStringToColor("#FFCF9F"),
                  hexStringToColor("#F2D7A6")
                ],
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    hexStringToColor("#fff").withOpacity(0.2),
                    BlendMode.dstATop),
                image: const NetworkImage(
                  'https://mir-s3-cdn-cf.behance.net/project_modules/fs/01b4bd84253993.5d56acc35e143.jpg',
                ),
              ),
            ),
            child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 5,
                        color:
                        const Color.fromARGB(255, 250, 199, 171).withOpacity(
                            0.4),
                        child: Container(
                          width: 400,
                          padding: const EdgeInsets.all(40.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Form(
                            key: _formfiled,
                            child: Column(
                              children: [
                                FadeAnimation(
                                  delay: 0.8,
                                  child: Image.asset(
                                    "assets/Images/civil-engineering.png",
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                SizedBox(height: 20,),
                                DropdownButtonFormField(
                                  value: _selected,
                                  items: _typeuser.map((e) =>
                                      DropdownMenuItem(
                                        child: Text(e), value: e,)).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selected = val as String;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.arrow_drop_down_circle,
                                    color: Colors.black54,
                                  ),
                                  style: TextStyle(color: Colors.white70),
                                  dropdownColor: Colors.black,
                                  decoration: InputDecoration(
                                    labelText: "Type User",
                                    labelStyle: TextStyle(
                                        fontSize: 30, color: Colors.white70),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white70),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.white.withOpacity(0.9)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(height: 20,),
                                FadeAnimation(
                                  delay: 1,
                                  child: TextFormField(
                                      cursorColor: Colors.white,
                                      controller: _FirstNameTextController,
                                      keyboardType: TextInputType.name,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.white70,
                                        ),
                                        labelText: "First Name",
                                        labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(
                                                0.9)),
                                        filled: true,
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                        fillColor: Colors.white.withOpacity(
                                            0.3),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                30.0),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "please enter First Name";
                                        }
                                      }),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                  delay: 1,
                                  child: TextFormField(
                                      cursorColor: Colors.white,
                                      controller: _LastNameTextController,
                                      keyboardType: TextInputType.name,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.white70,
                                        ),
                                        labelText: "Last Name",
                                        labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(
                                                0.9)),
                                        filled: true,
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                        fillColor: Colors.white.withOpacity(
                                            0.3),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                30.0),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "please enter Last Name";
                                        }
                                      }),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                  delay: 1,
                                  child: TextFormField(
                                    cursorColor: Colors.white,
                                    controller: _PhoneTextController,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: Colors.white70,
                                      ),
                                      labelText: "phone number",
                                      labelStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      filled: true,
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                      fillColor: Colors.white.withOpacity(0.3),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              30.0),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "please enter phone";
                                      } else
                                      if (_PhoneTextController.text.length !=
                                          10) {
                                        return "you phone number not correct";
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                  delay: 1,
                                  child: TextFormField(
                                      cursorColor: Colors.white,
                                      controller: _emailTextController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.alternate_email_outlined,
                                          color: Colors.white70,
                                        ),
                                        labelText: "Email",
                                        labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(
                                                0.9)),
                                        filled: true,
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                        fillColor: Colors.white.withOpacity(
                                            0.3),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                30.0),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "enter email";
                                        }
                                        bool emailvalid =
                                        RegExp('[a-z0-9]+@[a-z]+\.[a-z]{2,3}')
                                            .hasMatch(value);
                                        if (!emailvalid) {
                                          return "enter valid email";
                                        }
                                      }),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                    delay: 1,
                                    child: TextFormField(
                                      cursorColor: Colors.white,
                                      controller: _passwordTextController,
                                      keyboardType: TextInputType.emailAddress,
                                      obscureText: passToggle,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Colors.white70,
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              passToggle = !passToggle;
                                            });
                                          },
                                          child: Icon(passToggle
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                        ),
                                        labelText: "Password",
                                        labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(
                                                0.9)),
                                        filled: true,
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                        fillColor: Colors.white.withOpacity(
                                            0.3),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                30.0),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "please enter passowrd";
                                        } else if (_passwordTextController
                                            .text.length <
                                            6) {
                                          return "passowrd length not be less than 6 character";
                                        }
                                      },
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                    delay: 1,
                                    child: firebaseUIButton(
                                        context, "Sign Up", () {
                                      if (_formfiled.currentState!.validate()) {
                                        FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                            email: _emailTextController.text,
                                            password:
                                            _passwordTextController.text)
                                            .then((value) {
                                          print("Created New Account");
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen()));
                                        }).onError((error, stackTrace) {
                                          print("Error ${error.toString()}");
                                        });
                                          adduserdetails(
                                            _selected,
                                            _FirstNameTextController.text
                                                .trim(),
                                            _LastNameTextController.text.trim(),

                                                _PhoneTextController.text
                                                    .trim(),
                                            _emailTextController.text.trim(),
                                            _passwordTextController.text
                                                .trim(),
                                          );
                                      }
                                    })),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))),
      );
    }
    else if (_selected == _typeuser[1]) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
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
                stops: const [0.1, 0.4, 0.7, 0.9],
                colors: [
                  hexStringToColor("#3E4C59"),
                  hexStringToColor("#FFCF9F"),
                  hexStringToColor("#FFCF9F"),
                  hexStringToColor("#F2D7A6")
                ],
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    hexStringToColor("#fff").withOpacity(0.2),
                    BlendMode.dstATop),
                image: const NetworkImage(
                  'https://mir-s3-cdn-cf.behance.net/project_modules/fs/01b4bd84253993.5d56acc35e143.jpg',
                ),
              ),
            ),
            child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 5,
                        color:
                        const Color.fromARGB(255, 250, 199, 171).withOpacity(
                            0.4),
                        child: Container(
                          width: 400,
                          padding: const EdgeInsets.all(40.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Form(
                            key: _formfiled,
                            child: Column(
                              children: [
                                FadeAnimation(
                                  delay: 0.8,
                                  child: Image.asset(
                                    "assets/Images/civil-engineering.png",
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                SizedBox(height: 20,),
                                DropdownButtonFormField(
                                  value: _selected,
                                  items: _typeuser.map((e) =>
                                      DropdownMenuItem(
                                        child: Text(e), value: e,)).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selected = val as String;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.arrow_drop_down_circle,
                                    color: Colors.black54,
                                  ),
                                  style: TextStyle(color: Colors.white70),

                                  dropdownColor: Colors.black,
                                  decoration: InputDecoration(
                                    labelText: "Type User",
                                    labelStyle: TextStyle(
                                        fontSize: 30, color: Colors.white70),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white70),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.white.withOpacity(0.9)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor:  Colors.white.withOpacity(
                                          0.3),
                                      backgroundImage: _image != null
                                          ? FileImage(_image)
                                          : null,
                                      radius: 50,
                                    ),
                                    GestureDetector(onTap: () {
                                      print(_image);
                                      pickImage();
                                    }, child: Icon(Icons.add_a_photo))
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                  delay: 1,
                                  child: TextFormField(
                                      cursorColor: Colors.white,
                                      controller: _FirstNameTextController,
                                      keyboardType: TextInputType.name,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.white70,
                                        ),
                                        labelText: "First Name",
                                        labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(
                                                0.9)),
                                        filled: true,
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                        fillColor: Colors.white.withOpacity(
                                            0.3),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                30.0),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "please enter First Name";
                                        }
                                      }),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                  delay: 1,
                                  child: TextFormField(
                                      cursorColor: Colors.white,
                                      controller: _LastNameTextController,
                                      keyboardType: TextInputType.name,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.white70,
                                        ),
                                        labelText: "Last Name",
                                        labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(
                                                0.9)),
                                        filled: true,
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                        fillColor: Colors.white.withOpacity(
                                            0.3),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                30.0),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "please enter Last Name";
                                        }
                                      }),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                  delay: 1,
                                  child: TextFormField(
                                    cursorColor: Colors.white,
                                    controller: _PhoneTextController,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: Colors.white70,
                                      ),
                                      labelText: "phone number",
                                      labelStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      filled: true,
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                      fillColor: Colors.white.withOpacity(0.3),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              30.0),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "please enter phone";
                                      } else
                                      if (_PhoneTextController.text.length !=
                                          10) {
                                        return "you phone number not correct";
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                  delay: 1,
                                  child: TextFormField(
                                      cursorColor: Colors.white,
                                      controller: _emailTextController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.alternate_email_outlined,
                                          color: Colors.white70,
                                        ),
                                        labelText: "Email",
                                        labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(
                                                0.9)),
                                        filled: true,
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                        fillColor: Colors.white.withOpacity(
                                            0.3),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                30.0),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "enter email";
                                        }
                                        bool emailvalid =
                                        RegExp('[a-z0-9]+@[a-z]+\.[a-z]{2,3}')
                                            .hasMatch(value);
                                        if (!emailvalid) {
                                          return "enter valid email";
                                        }
                                      }),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                    delay: 1,
                                    child: TextFormField(
                                      cursorColor: Colors.white,
                                      controller: _passwordTextController,
                                      keyboardType: TextInputType.emailAddress,
                                      obscureText: passToggle,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Colors.white70,
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              passToggle = !passToggle;
                                            });
                                          },
                                          child: Icon(passToggle
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                        ),
                                        labelText: "Password",
                                        labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(
                                                0.9)),
                                        filled: true,
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                        fillColor: Colors.white.withOpacity(
                                            0.3),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                30.0),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "please enter passowrd";
                                        } else if (_passwordTextController
                                            .text.length <
                                            6) {
                                          return "passowrd length not be less than 6 character";
                                        }
                                      },
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                    delay: 1,
                                    child: TextFormField(
                                      cursorColor: Colors.white,
                                      controller: _type,
                                      keyboardType: TextInputType.emailAddress,
                                      obscureText: passToggle,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.type_specimen,
                                          color: Colors.white70,
                                        ),
                                        labelText: "type engineering",
                                        labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(
                                                0.9)),
                                        filled: true,
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                        fillColor: Colors.white.withOpacity(
                                            0.3),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                30.0),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "please enter type engineering";
                                        }
                                      },
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                    delay: 1,
                                    child: firebaseUIButton(
                                        context, "Sign Up", () {
                                      if (_formfiled.currentState!.validate()) {
                                        FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                            email: _emailTextController.text,
                                            password: _passwordTextController.text)
                                            .then((value) {
                                          print("Created New Account");
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreeneng()));
                                        }).onError((error, stackTrace) {
                                          print("Error ${error.toString()}");
                                        });
                                          addengdetails(
                                            _selected,
                                              _FirstNameTextController.text
                                                  .trim(),
                                              _LastNameTextController.text
                                                  .trim(),

                                                  _PhoneTextController.text
                                                      .trim(),
                                              _emailTextController.text.trim(),
                                              _passwordTextController.text
                                                  .trim(),
                                              _type.text.trim(),

                                          );
                                          uploadFile();
                                      }
                                    })),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))),
      );
    }
    else {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
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
                stops: const [0.1, 0.4, 0.7, 0.9],
                colors: [
                  hexStringToColor("#3E4C59"),
                  hexStringToColor("#FFCF9F"),
                  hexStringToColor("#FFCF9F"),
                  hexStringToColor("#F2D7A6")
                ],
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    hexStringToColor("#fff").withOpacity(0.2),
                    BlendMode.dstATop),
                image: const NetworkImage(
                  'https://mir-s3-cdn-cf.behance.net/project_modules/fs/01b4bd84253993.5d56acc35e143.jpg',
                ),
              ),
            ),
            child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 5,
                        color:
                        const Color.fromARGB(255, 250, 199, 171).withOpacity(
                            0.4),
                        child: Container(
                          width: 400,
                          padding: const EdgeInsets.all(40.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Form(
                            key: _formfiled,
                            child: Column(
                              children: [
                                FadeAnimation(
                                  delay: 0.8,
                                  child: Image.asset(
                                    "assets/Images/civil-engineering.png",
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                SizedBox(height: 20,),
                                DropdownButtonFormField(
                                  value: _selected,
                                  items: _typeuser.map((e) =>
                                      DropdownMenuItem(
                                        child: Text(e), value: e,)).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selected = val as String;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.arrow_drop_down_circle,
                                    color: Colors.black54,
                                  ),
                                  style: TextStyle(color: Colors.white70),
                                  dropdownColor: Colors.black,
                                  decoration: InputDecoration(
                                    labelText: "Type User",
                                    labelStyle: TextStyle(
                                        fontSize: 30, color: Colors.white70),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white70),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.white.withOpacity(0.9)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor:  Colors.white.withOpacity(
                                    0.3),
                                      backgroundImage: _image != null
                                          ? FileImage(_image)
                                          : null,
                                      radius: 50,
                                    ),
                                    GestureDetector(onTap: () {
                                      print(_image);
                                      pickImage();
                                    }, child: Icon(Icons.add_a_photo))
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                  delay: 1,
                                  child: TextFormField(
                                      cursorColor: Colors.white,
                                      controller: _FirstNameTextController,
                                      keyboardType: TextInputType.name,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.white70,
                                        ),
                                        labelText: "First Name",
                                        labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(
                                                0.9)),
                                        filled: true,
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                        fillColor: Colors.white.withOpacity(
                                            0.3),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                30.0),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "please enter First Name";
                                        }
                                      }),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                  delay: 1,
                                  child: TextFormField(
                                      cursorColor: Colors.white,
                                      controller: _LastNameTextController,
                                      keyboardType: TextInputType.name,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.white70,
                                        ),
                                        labelText: "Last Name",
                                        labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(
                                                0.9)),
                                        filled: true,
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                        fillColor: Colors.white.withOpacity(
                                            0.3),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                30.0),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "please enter Last Name";
                                        }
                                      }),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                  delay: 1,
                                  child: TextFormField(
                                    cursorColor: Colors.white,
                                    controller: _PhoneTextController,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: Colors.white70,
                                      ),
                                      labelText: "phone number",
                                      labelStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      filled: true,
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                      fillColor: Colors.white.withOpacity(0.3),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              30.0),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "please enter phone";
                                      } else
                                      if (_PhoneTextController.text.length !=
                                          10) {
                                        return "you phone number not correct";
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                  delay: 1,
                                  child: TextFormField(
                                      cursorColor: Colors.white,
                                      controller: _emailTextController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.alternate_email_outlined,
                                          color: Colors.white70,
                                        ),
                                        labelText: "Email",
                                        labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(
                                                0.9)),
                                        filled: true,
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                        fillColor: Colors.white.withOpacity(
                                            0.3),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                30.0),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "enter email";
                                        }
                                        bool emailvalid =
                                        RegExp('[a-z0-9]+@[a-z]+\.[a-z]{2,3}')
                                            .hasMatch(value);
                                        if (!emailvalid) {
                                          return "enter valid email";
                                        }
                                      }),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                    delay: 1,
                                    child: TextFormField(
                                      cursorColor: Colors.white,
                                      controller: _passwordTextController,
                                      keyboardType: TextInputType.emailAddress,
                                      obscureText: passToggle,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Colors.white70,
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              passToggle = !passToggle;
                                            });
                                          },
                                          child: Icon(passToggle
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                        ),
                                        labelText: "Password",
                                        labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(
                                                0.9)),
                                        filled: true,
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                        fillColor: Colors.white.withOpacity(
                                            0.3),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                30.0),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "please enter passowrd";
                                        } else if (_passwordTextController
                                            .text.length <
                                            6) {
                                          return "passowrd length not be less than 6 character";
                                        }
                                      },
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                    delay: 1,
                                    child: firebaseUIButton(
                                        context, "Sign Up", () {
                                      if (_formfiled.currentState!.validate()) {
                                        FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                            email: _emailTextController.text,
                                            password:
                                            _passwordTextController.text)
                                            .then((value) {
                                          print("Created New Account");
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreencontractor()));
                                        }).onError((error, stackTrace) {
                                          print("Error ${error.toString()}");
                                        });
                                          addcontractordetails(
                                            _selected,
                                            _FirstNameTextController.text
                                                .trim(),
                                            _LastNameTextController.text.trim(),
                                                _PhoneTextController.text
                                                    .trim(),
                                            _emailTextController.text.trim(),
                                            _passwordTextController.text
                                                .trim(),
                                          );
                                          uploadFile();
                                      }
                                    })),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))),
      );
    }
  }

}
Future adduserdetails(String type,String firstname, String lastname, String phone,
    String email, String passowrd) async {
  await FirebaseFirestore.instance.collection('users').add({
    'type':type,
    'firstname': firstname,
    'lastname': lastname,
    'phone': phone,
    'email': email,
    'passowrd': passowrd,
  });
}

Future addengdetails(String type,String firstname, String lastname, String phone,
    String email, String passowrd, String type_eng) async {
  await FirebaseFirestore.instance.collection('engineering').add({
    'type':type,
    'firstname': firstname,
    'lastname': lastname,
    'phone': phone,
    'email': email,
    'passowrd': passowrd,
    'typeengineering': type_eng,
  });
}

Future addcontractordetails(String type,String firstname, String lastname, String phone,
    String email, String passowrd) async {
  await FirebaseFirestore.instance.collection('contractor').add({
    'type':type,
    'firstname': firstname,
    'lastname': lastname,
    'phone': phone,
    'email': email,
    'passowrd': passowrd,
  });
}




