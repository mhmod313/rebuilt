import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:rebuilt/core/Fade_Animation.dart';

import '../utils/utils.dart';

class feedback extends StatefulWidget {
  const feedback({Key? key}) : super(key: key);

  @override
  State<feedback> createState() => _feedbackState();
}

TextEditingController _feedbackcontroller = TextEditingController();
TextEditingController _subcontroller = TextEditingController();

class _feedbackState extends State<feedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeAnimation(delay: 0.8, child: Container(child: Icon(Icons.feedback,size: 100,color: Colors.grey,),)),
            FadeAnimation(delay: 1.1, child: Container(
              margin: EdgeInsets.all(10),
              child: TextField(
                cursorColor: Colors.black,
                controller: _subcontroller,
                maxLines: 1, // Set the maximum lines to 5
                decoration: InputDecoration(
                  hintText: 'Please enter proplem',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(width: 3, color: Colors.black)),
                  filled: true,
                  fillColor: Colors.grey[400],
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ), // Additional properties and logic for the text field
              ),
            ),),
            FadeAnimation(delay: 1.5, child:Container(
              margin: EdgeInsets.all(10),
              child: TextField(
                cursorColor: Colors.black,
                controller: _feedbackcontroller,
                maxLines: 8, // Set the maximum lines to 5
                decoration: InputDecoration(
                  hintText: 'Please enter details',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(width: 3, color: Colors.black)),
                  filled: true,
                  fillColor: Colors.grey[400],
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ), // Additional properties and logic for the text field
              ),
            ), ),
            FadeAnimation(delay: 2.3, child: ElevatedButton(
                onPressed:(){sendEmail();_feedbackcontroller.clear();_subcontroller.clear();},
                child: Text("send"))),

          ],
        ),
      ),
    );
  }

  void sendEmail() async {
    final Email email = Email(
      body: _feedbackcontroller.text,
      subject: _subcontroller.text,
      recipients: ["rebuilta824@gmail.com"],
    );
    try {
      await FlutterEmailSender.send(email);
      print('Email sent successfully!');
    } catch (e) {
      print('Error occurred while sending email: $e');
    }
  }
}
