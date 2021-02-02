import 'package:flutter/material.dart';

class CardExample extends StatelessWidget {
  const CardExample({
    Key key,
    this.color = Colors.indigo,
    this.text = "Card Example",
  }) : super(key: key);
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      width: 320,

      // Warning: hard-coding values like this is a bad practice
      padding: EdgeInsets.all(38.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          width: 7.0,
          color: Colors.transparent.withOpacity(0.3),
        ),
      ),

      child: Text(
        text,
        style: TextStyle(
          fontSize: 36.0,
          // color: Colors.white,
          color: Colors.white.withOpacity(0.8),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
