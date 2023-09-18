import 'package:flutter/material.dart';
import '../appTheme.dart';
import '../models/task_textfield.dart';

class TaskWidget extends StatelessWidget {
  final String hintText;
  final Color fillColor;
  final Color color;
  final Icon prefixIcon;
  final TextEditingController controller;
  final VoidCallback onPressed;

  const TaskWidget({
    Key? key,
    required this.hintText,
    required this.fillColor,
    required this.color,
    required this.prefixIcon,
    required this.controller,
    required this.onPressed,
    required bool autoFocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, bottom: 30, left: 20, right: 20),
                child: TaskTextField(
                  hintText: hintText,
                  fillColor: fillColor,
                  color: color,
                  prefixIcon: prefixIcon,
                  controller: controller,
                  autoFocus: true,
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.orangeAccent)),
                  onPressed: onPressed,
                  child: const Text(
                    actionButton,
                    style: addTaskElevatedButton,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
