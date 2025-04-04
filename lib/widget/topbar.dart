import 'package:flutter/material.dart';

class TopSearchBar extends StatefulWidget {
  const TopSearchBar({super.key});

  @override
  State<TopSearchBar> createState() => _TopSearchBarState();
}

class _TopSearchBarState extends State<TopSearchBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // Flexible for screen
                  width: MediaQuery.sizeOf(context).width * 0.50,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 177, 177, 177),
                        blurRadius: 10,
                        offset: Offset(0,5)
                      )
                    ]
                  ),
                  
                  child: Row(
                    children: [
                      Icon(Icons.search, color: const Color.fromARGB(255, 55, 57, 79),),
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
                ElevatedButton(
                  onPressed: (){

                  }, 
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                    elevation: 12,
                    shadowColor: Color.fromARGB(255, 177, 177, 177),
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: Color.fromARGB(255, 55, 57, 79),
                    size: 28,
                    ),
                )
              ],
            ),   
          ),
        );
  }
}