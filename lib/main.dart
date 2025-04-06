import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:helpin/nav/navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:helpin/widget/notificationclass.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  if(kIsWeb){
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDuoW6i41swB5Yx-AgzwJg0bBjhJ4dkssA",
        authDomain: "helpin-f61b5.firebaseapp.com",
        projectId: "helpin-f61b5",
        storageBucket: "helpin-f61b5.firebasestorage.app",
        messagingSenderId: "1008998888109",
        appId: "1:1008998888109:web:88dffedee927b54f6a8c24",
        measurementId: "G-JJ7T0JRM5F"
      )
    );
  }
  else {
    await Firebase.initializeApp();
  }
  
  Future<void> setupFirebaseMsg() async {
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  }

  final userCred = await FirebaseAuth.instance.signInAnonymously();
  // I want to pass this to the navbar 
  String? uid = userCred.user?.uid;

  await NotificationFB().saveFcmToken(uid!);
  await setupFirebaseMsg();


  runApp(MainApp(uid: uid,));
}

class MainApp extends StatefulWidget {
final String? uid;

  MainApp({super.key, required this.uid});

  @override
  State<MainApp> createState() => _MainAppState();
}
class _MainAppState extends State<MainApp>{

  @override 
  void initState(){
    super.initState();
    NotificationFB().setupFcmHandlers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CusNavigationBar(userid: widget.uid,)
      ),
    );
  }
}
