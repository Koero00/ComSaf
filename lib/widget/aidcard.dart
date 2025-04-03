import 'package:flutter/material.dart';

class AidCard extends StatefulWidget {
  final int stepCounter = 0;
  final String description = "";
  const AidCard({required stepCounter, required description, super.key});

  @override
  State<AidCard> createState() => _AidCardState();
}

class _AidCardState extends State<AidCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.9,
      height: MediaQuery.sizeOf(context).height * 0.18, 
      decoration: BoxDecoration(
        color: Color.fromRGBO(233, 233, 233, 1),
        borderRadius: BorderRadius.circular(6)
      ),
      child: Row(
        children: [
          SizedBox(width: 10,),
          Column(
            children: [
              Text("Step: ${widget.stepCounter}"),
              Text(widget.description)
            ],
          ),
          // Image
        ],
      ),
    );
  }
}