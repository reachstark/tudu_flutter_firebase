// This class is not required after migration to Firebase

import 'package:flutter/material.dart';

class TaskTile extends StatefulWidget {
  final String taskName;
  final bool isChecked;
  final VoidCallback? checkbox;

  const TaskTile(
      {super.key,
      required this.taskName,
      required this.isChecked,
      this.checkbox});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.taskName,
      ),
      trailing: Checkbox(
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
          });
          widget.checkbox!();
        },
      ),
    );
  }
}
