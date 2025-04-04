import 'package:flutter/material.dart';

class AidCard extends StatefulWidget {
  final int stepCounter;
  final String aidDescrip;
  const AidCard({required this.stepCounter, required this.aidDescrip, super.key});

  @override
  State<AidCard> createState() => _AidCardState();
}

class _AidCardState extends State<AidCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.9,
      // height: MediaQuery.sizeOf(context).height * 0.18, 
      decoration: BoxDecoration(
        color: Color.fromRGBO(233, 233, 233, 1),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 156, 156, 156),
            spreadRadius: 0.4,
            blurRadius: 2,
            offset: Offset(0, 4)
          )
        ]
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
            padding: EdgeInsets.all(15), 
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Step: ${widget.stepCounter}", style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 6),
                  Text(widget.aidDescrip, softWrap: true,)
                ],
              ),
            )
          )
          // Image
        ],
      ),
    );
  }
}