import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationPopUp extends StatefulWidget {
  final Function onTap;
  const NotificationPopUp({super.key, required this.onTap});

  @override
  State<NotificationPopUp> createState() => _NotificationPopUpState();
}

class _NotificationPopUpState extends State<NotificationPopUp> {

  String getCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      height: true ? 90 : 0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFFFF5252),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              // Fix this
              onTap: () => widget.onTap(),
              child: Row(
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
              ),
            ),
          )
    );
  }
}