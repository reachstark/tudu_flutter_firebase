import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_flutter/models/task_duplicate_warning.dart';
import 'package:todolist_flutter/models/task_empty_warning.dart';
import 'package:todolist_flutter/models/task_state_manager.dart';
import '../screens/task_widget.dart';

class AddNewTask extends StatelessWidget {
  const AddNewTask({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.orangeAccent,
      onPressed: () {
        TextEditingController controller = TextEditingController();
        showModalBottomSheet(
          isScrollControlled: true,
          showDragHandle: true,
          context: context,
          builder: (context) {
            return TaskWidget(
              autoFocus: true,
              hintText: 'Add a new task...',
              fillColor: Colors.orangeAccent,
              color: Colors.white,
              prefixIcon: const Icon(
                Icons.add,
              ),
              controller: controller,
              onPressed: () {
                if (controller.text.isEmpty) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const EmptyNameAlert();
                    },
                  );
                } else if (Provider.of<TaskStateManager>(context, listen: false)
                    .tasks
                    .any((task) => task.name == controller.text)) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const DuplicateNameAlert();
                    },
                  );
                } else {
                  Provider.of<TaskStateManager>(context, listen: false)
                      .addTask(Task(id: '', name: controller.text));
                  Navigator.of(context).pop();
                }
              },
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
