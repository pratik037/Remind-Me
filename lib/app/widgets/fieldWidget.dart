import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  const Field({Key key, @required this.name, @required this.controller})
      : super(key: key);
  final String name;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    Color col = Colors.blue[300];
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: controller.text,
            labelText: name,
            labelStyle: TextStyle(color: col),
            focusColor: col,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: col, width: 2.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: col, width: 2.0))),
      ),
    );
  }
}
