import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

NumberFormat formatter = new NumberFormat("##,##,##,###");

List<Widget> BigNumberWidget(IconData icon, Color color, String bigNumber, String title) {
  bigNumber = formatter.format(int.parse(bigNumber));

  return [
    Text(
      bigNumber,
      style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: color),
      textAlign: TextAlign.center,
    ),
    Row(
      children: <Widget>[
        Icon(
          icon,
          color: color,
        ),
        Text(" " + title, style: TextStyle(color: color))
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ),
  ];
}
