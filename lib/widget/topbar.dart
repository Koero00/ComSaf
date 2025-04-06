import 'package:flutter/material.dart';
import 'package:helpin/widget/notification.dart';
import 'package:intl/intl.dart';  // For formatting the time

class TopSearchBar extends StatefulWidget {
  final Function onTap;


  const TopSearchBar({super.key, required this.onTap});

  @override
  State<TopSearchBar> createState() => _TopSearchBarState();
}

class _TopSearchBarState extends State<TopSearchBar> {
  bool showNotification = false;
  final List<Widget> notificationWidgets = [];

  String getCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }

  void addNotificationManual()
  {
    setState(() {
      notificationWidgets.add(
        NotificationPopUp(onTap: widget.onTap),
      );
    });
  }

  void addNotification(){
    setState(() {
      notificationWidgets.add(
        NotificationPopUp(onTap: widget.onTap),
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
                    // setState(() {
                    //   showNotification = !showNotification;
                    // });

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
            spacing: 5,
            children: notificationWidgets,
          )
        ],
      ),
    );
  }
}
