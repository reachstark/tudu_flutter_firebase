import 'package:flutter/material.dart';

class TaskTextField extends StatelessWidget {
  TaskTextField({
    this.hintText,
    this.prefixIcon,
    this.fillColor,
    this.color,
    required this.controller,
    required bool autoFocus,
  });
  final String? hintText;
  final Icon? prefixIcon;
  final Color? fillColor;
  final Color? color;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: fillColor,
          hintText: hintText,
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
