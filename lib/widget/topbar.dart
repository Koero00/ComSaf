import 'package:flutter/material.dart';
import 'package:helpin/widget/notification.dart';
import 'package:intl/intl.dart';  // For formatting the time

class TopSearchBar extends StatefulWidget {
  final Function (double lon, double lat, String id) onTap;


  const TopSearchBar({super.key, required this.onTap,});

  @override
  TopSearchBarState createState() => TopSearchBarState();
}

class TopSearchBarState extends State<TopSearchBar> {
  bool showNotification = false;
  List<Widget> notificationWidgets = [];

  String getCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }


  void passInfo()
  {
    print("Ok, this function has been triggerd.");
    notificationWidgets.removeAt(0);
    widget.onTap(0,0, "");
  }

  void addNotificationManual()
  {

    print("OK, we passed the passInfo func");
    setState(() {
      notificationWidgets.add(
        NotificationPopUp(onTap: passInfo),
      );
    });
  }

  void addNotification(){
    print("Now we triggerd the addNotification function in the topbar!");
    setState(() {
      notificationWidgets.add(
        NotificationPopUp(onTap: passInfo),
      );
    });
  }


  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // Flexible for screen
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 177, 177, 177),
                        blurRadius: 10,
                        offset: Offset(0, 5)
                      )
                    ]
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: const Color.fromARGB(255, 55, 57, 79)),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Find a contact",
                            border: InputBorder.none
                          ),
                        ) 
                      ),
                    ],
                  ),
                ),
                SizedBox(width: MediaQuery.sizeOf(context).width * 0.02,),
                ElevatedButton(
                  onPressed: () {
                    addNotificationManual();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(10),
                    backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                    elevation: 12,
                    shadowColor: Color.fromARGB(255, 177, 177, 177),
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: Color.fromARGB(255, 55, 57, 79),
                    size: MediaQuery.sizeOf(context).height * 0.03,
                    ),
                )
              ],
            ),   
          ),
          
          // SOS Notification Box
          Column(
            children: notificationWidgets,
          )
        ],
      ),
    );
  }
}
