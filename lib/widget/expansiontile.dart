import 'package:flutter/material.dart';
import 'package:helpin/widget/aidcard.dart';

class CusExpansiontile extends StatefulWidget {
  final String title;
  final List<Widget> child;

  const CusExpansiontile({super.key, required this.title, required this.child});

  @override
  State<CusExpansiontile> createState() => _CusExpansiontileState();
}

class _CusExpansiontileState extends State<CusExpansiontile> {
  bool _expanded = false;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Color.fromRGBO(55, 57, 79, 1),
              
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: _expanded ? Radius.circular(0) : Radius.circular(6),
                bottomRight: _expanded ? Radius.circular(0) : Radius.circular(10)
              )
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(color: Colors.white, )
                ),
                Icon(
                  _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),

        _expanded ? Container(
          // height: MediaQuery.sizeOf(context).height * 0.2,
          width: double.infinity,
          // color: Color.fromARGB(255, 255, 255, 255),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Color.fromRGBO(55, 57, 79, 1), width: 2),
              right: BorderSide(color: Color.fromRGBO(55, 57, 79, 1), width: 2),
              bottom: BorderSide(color: Color.fromRGBO(55, 57, 79, 1), width: 2),
              top: BorderSide.none,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)
            )
          ),
          child: Column(
            spacing: 20,
            children: widget.child ,
          ),
        )
        :
        Container(),

      ],
    );
  }
}