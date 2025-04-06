import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // For formatting the time

class TopSearchBar extends StatefulWidget {
  const TopSearchBar({super.key});

  @override
  State<TopSearchBar> createState() => _TopSearchBarState();
}

class _TopSearchBarState extends State<TopSearchBar> {
  bool showNotification = false;

  String getCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
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
                    setState(() {
                      showNotification = !showNotification;
                    });
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
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: showNotification ? 90 : 0,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xFFFF5252),
              borderRadius: BorderRadius.circular(16),
            ),
            child: showNotification 
                ? Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage('assets/profile_pic1.png'),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                "S.O.S Emergency",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Asthma attack",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                getCurrentTime(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
