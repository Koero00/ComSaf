
// navbar.dart
import 'package:flutter/material.dart';
import 'package:helpin/screens/home.dart';

class CusNavigationBar extends StatefulWidget {
  const CusNavigationBar({super.key});

  @override
  State<CusNavigationBar> createState() => _CusNavigationBarState();
}

class _CusNavigationBarState extends State<CusNavigationBar> {
  bool isSOSActive = false;

  void toggleSOS(bool activate) {
    setState(() {
      isSOSActive = activate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreen(toggleSOS: toggleSOS, isSOSActive: isSOSActive),
      floatingActionButton: SizedBox(
        height: 130,
        width: 130,
        child: FloatingActionButton(
          onPressed: () {
            if (isSOSActive) {
              toggleSOS(false);
            } else {
              toggleSOS(true);
            }
          },
          backgroundColor: Color.fromRGBO(237, 57, 57, 5),
          shape: CircleBorder(),
          elevation: 10,
          child: Text(
            isSOSActive ? 'Cancel' : 'SOS',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 30, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        color: const Color.fromARGB(255, 55, 57, 79),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.home_filled), iconSize: 40, color: Colors.white),
              IconButton(onPressed: () {}, icon: Icon(Icons.person), iconSize: 40, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
