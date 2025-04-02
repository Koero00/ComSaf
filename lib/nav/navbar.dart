import 'package:flutter/material.dart';
import 'package:helpin/screens/home.dart';

class CusNavigationBar extends StatelessWidget {
  const CusNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: HomeScreen(),
      ),

      floatingActionButton: SizedBox(
        height: 130,
        width: 130,
        child: FloatingActionButton(
          onPressed: (){}, 
          backgroundColor:Color.fromRGBO(237, 57, 57, 5),
          shape: CircleBorder(),
          elevation: 10,
          child: Text('SOS', style: 
            TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 30,
              color: Colors.white
            ),
          ),
          
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 8,
            color: const Color.fromARGB(255, 55, 57, 79),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.home_filled), iconSize: 40, color: Colors.white,),
                  IconButton(onPressed: (){}, icon: Icon(Icons.person), iconSize: 40, color: Colors.white), 
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}