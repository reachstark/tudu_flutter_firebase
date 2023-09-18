import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_flutter/screens/task_list.dart';
import 'package:todolist_flutter/models/task_state_manager.dart';

class ToDoBackground extends StatelessWidget {
  const ToDoBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: TaskList(
            taskStateManager:
                Provider.of<TaskStateManager>(context, listen: false)),
      ),
    );
  }
}
