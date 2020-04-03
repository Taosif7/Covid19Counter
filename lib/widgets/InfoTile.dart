import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

NumberFormat formatter = new NumberFormat("##,##,##,###");

Widget InfoTile(IconData icon, String data, String info) {
  if (data == "null") data = "0";
  data = formatter.format(int.parse(data));
  return ListTile(
      leading: Icon(icon), title: Text(data), trailing: Text(info), contentPadding: EdgeInsets.symmetric(horizontal: 50));
}
