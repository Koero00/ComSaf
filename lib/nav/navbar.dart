import 'package:flutter/material.dart';
import 'package:helpin/screens/home.dart';
import 'package:helpin/widget/notificationclass.dart';

class CusNavigationBar extends StatefulWidget {
  const CusNavigationBar({super.key});

  @override
  State<CusNavigationBar> createState() => _CusNavigationBarState();
}

class _CusNavigationBarState extends State<CusNavigationBar> {
  bool isSOSActive = false;
  bool isSafe = false;
  bool isCrisisAverted = false;
  final NotificationFB notificationFB = NotificationFB();



  void toggleSOS(bool activate, bool safe, bool crisisAverted) async {

    // Testing the notifications
    await notificationFB.sendLocationNotification(senderId: "EvqKjsoXV1YaMxUydjZ2gcYkzlz2", receiverId: "QK1vFRHO92U3JU2IN0BgV8WGRyl2", lat: 5, lon: 2);
    

    setState(() {
      isSOSActive = activate;
      isSafe = safe;
      isCrisisAverted = crisisAverted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreen(
        toggleSOS: toggleSOS, 
        isSOSActive: isSOSActive, 
        isSafe: isSafe,
        isCrisisAverted: isCrisisAverted,
      ),
      floatingActionButton: SizedBox(
        height: 130,
        width: 130,
        child: FloatingActionButton(
          onPressed: () {
            if (!isSOSActive) {
              // Initially activate SOS
              toggleSOS(true, false, false);
            } else if (isSOSActive && !isSafe) {
              // When Cancel is clicked during countdown, deactivate SOS completely
              toggleSOS(false, false, false);
            } else if (isSOSActive && isSafe && !isCrisisAverted) {
              // When SAFE button is clicked after countdown reached 0,
              // mark crisis as averted
              toggleSOS(true, false, true);
            } else if (isSOSActive && isCrisisAverted) {
              // When "Close" is clicked, completely deactivate SOS
              toggleSOS(false, false, false);
            }
          },
          backgroundColor: isCrisisAverted
              ? Colors.grey // Neutral color when "Close" is active
              : (isSafe && !isCrisisAverted ? Color(0xFF20E036) : Color.fromRGBO(237, 57, 57, 5)),
          shape: CircleBorder(),
          elevation: 10,
          child: Text(
            isCrisisAverted
                ? 'Close' // Show Close button when crisis averted
                : (isSafe && !isCrisisAverted ? 'SAFE' : (isSOSActive ? 'Cancel' : 'SOS')),
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
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width * 0.06),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {}, 
                icon: Icon(Icons.home_filled), 
                iconSize: 40, 
                color: Colors.white
              ),
              IconButton(
                onPressed: () {}, 
                icon: Icon(Icons.person), 
                iconSize: 40, 
                color: Colors.white
              ),
            ],
          ),
        ),
      ),
    );
  }
}
