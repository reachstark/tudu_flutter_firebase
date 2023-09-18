import 'package:flutter/material.dart';
import 'package:todolist_flutter/models/task_state_manager.dart';
import '../models/task_addNew.dart';
import '../models/todo_background.dart';
import '../models/todo_header.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const AddNewTask(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToDoHeader(taskStateManager: TaskStateManager()),
          const ToDoBackground(),
        ],
      ),
    );
  }
}
