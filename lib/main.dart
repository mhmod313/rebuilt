import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rebuilt/screens/home_screen_contractor.dart';
import 'package:rebuilt/screens/home_screen_eng.dart';
import 'package:rebuilt/screens/home_screenuser.dart';
import 'package:rebuilt/screens/signup_screen.dart';
import 'package:rebuilt/screens/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: "basic_channel",
        channelName: "Basic notifications",
        channelDescription: "offer",
      )
    ],
    debug: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var islogin = false;

  checkislogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          islogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkislogin();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed){
      if(!isAllowed)
        {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rebuilt',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: islogin != null
            ? (islogin ? ImageSplashScreen() : SignInScreen())
            : SignInScreen());
  }
}
