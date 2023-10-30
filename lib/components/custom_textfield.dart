import 'package:flutter/material.dart';

Widget CustomTextField(TextEditingController controller, String hint,
    {TextInputType inputType = TextInputType.text,
    bool hideText = false,
    double hEdgeInset = 25,
    double vEdgeInset = 25,
    onChanged = null}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: hEdgeInset),
    child: TextField(
      controller: controller,
      keyboardType: inputType,
      obscureText: hideText,
      onChanged: onChanged,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hint,
        fillColor: Colors.grey[200],
        filled: true,
      ),
    ),
  );
}
