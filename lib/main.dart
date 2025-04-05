import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:helpin/nav/navbar.dart';
import 'package:firebase_core/firebase_core.dart';

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


  runZonedGuarded(() async {
    await Firebase.initializeApp();
    runApp(MainApp());
  }, (error, stackTrace) {
    print('Firebase Init Error: $error');
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: CusNavigationBar()
      ),
    );
  }
}
