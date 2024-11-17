import 'package:firebase_auth/firebase_auth.dart';
import 'package:rebuilt/core/Fade_Animation.dart';
import 'package:rebuilt/reusable_widgets/reusable_widget.dart';
import 'signin_screen.dart';
import 'package:rebuilt/utils/utils.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailTextController = TextEditingController();
  final _form=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("#3E4C59"),
                hexStringToColor("#FFCF9F"),
                hexStringToColor("#FFCF9F"),
                hexStringToColor("#F2D7A6")
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                        delay: 0.8,
                        child: Image.asset(
                          "assets/Images/civil-engineering.png",
                          width: 100,
                          height: 100,
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
                            color: Colors.white.withOpacity(0.9)),
                        filled: true,
                        floatingLabelBehavior:
                        FloatingLabelBehavior.never,
                        fillColor: Colors.white.withOpacity(0.3),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none)),
                      ),
                      validator: (value){
                        if (value!.isEmpty) {
                          return "enter email";
                        }
                        bool emailvalid =
                        RegExp('[a-z0-9]+@[a-z]+\.[a-z]{2,3}')
                            .hasMatch(value);
                        if (!emailvalid) {
                          return "enter valid email";
                        }
                      },
                    ),
                  ),
                      const SizedBox(
                        height: 20,
                      ),
                     FadeAnimation(delay: 1, child:firebaseUIButton(context, "Reset Password", () {
                       if(_form.currentState!.validate()){
                         FirebaseAuth.instance
                             .sendPasswordResetEmail(email: _emailTextController.text)
                             .then((value) => Navigator.of(context).pop());
                       }
                     }) )
                    ],
                  ),
                ),
              ))),
    );
  }
}