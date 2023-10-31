import 'package:flutter/material.dart';

Widget CustomButton(
  String text,
  function, {
  double padding = 25,
  Color color = Colors.deepPurple,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 25.0),
    child: GestureDetector(
      onTap: function,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    ),
  );
}
