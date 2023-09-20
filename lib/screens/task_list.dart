import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todolist_flutter/appTheme.dart';
import 'package:todolist_flutter/models/task_duplicate_warning.dart';
import 'package:todolist_flutter/models/task_empty_warning.dart';
import 'package:todolist_flutter/models/task_state_manager.dart';
import 'package:todolist_flutter/models/task_textfield.dart';
import 'package:todolist_flutter/screens/task_notfound.dart';
import 'task_widget.dart';

final _firestore = FirebaseFirestore.instance;

class TaskList extends StatefulWidget {
  final TaskStateManager taskStateManager;
  const TaskList({Key? key, required this.taskStateManager}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final TextEditingController _searchController = TextEditingController();
  late List<Task> _searchResults = [];

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    _searchController.addListener(_onSearchChanged);
    widget.taskStateManager.addListener(() {
      setState(() {});
    });
    _searchResults = widget.taskStateManager.tasks;
  }

  void _onSearchChanged() {
    setState(() {
      _searchResults = widget.taskStateManager.tasks
          .where((task) => task.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void removeTask(Task task) async {
    // Show a dialog asking the user if they want to remove the task.
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Task', style: appSubTitleStyle),
          content: Text(
              'Are you sure you want to remove the task "${task.name}"?',
              style: warningTextStyle),
          actions: [
            ElevatedButton(
              onPressed: () async {
                try {
                  await _firestore.collection('tasks').doc(task.id).delete();
                  Navigator.of(context).pop();
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('Remove', style: activeTaskStyle),
            ),
            TextButton(
              onPressed: () {
                // Go back.
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    widget.taskStateManager.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> updateTask(Task task) async {
    TextEditingController controller = TextEditingController();

    showModalBottomSheet<void>(
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return TaskWidget(
          autoFocus: true,
          hintText: 'Enter new task name',
          fillColor: Colors.orangeAccent,
          color: Colors.white,
          prefixIcon: const Icon(Icons.edit),
          controller: controller,
          onPressed: () async {
            if (controller.text.isEmpty) {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const EmptyNameAlert();
                },
              );
            } else if (widget.taskStateManager.tasks
                .any((task) => task.name == controller.text)) {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const DuplicateNameAlert();
                },
              );
            } else {
              _firestore
                  .collection('tasks')
                  .doc(task.id)
                  .update({'name': controller.text});
              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // The search bar :/
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
          child: TaskTextField(
            autoFocus: false,
            controller: _searchController,
            hintText: 'Search...',
            color: Colors.grey[300],
            prefixIcon: const Icon(
              Icons.search,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('tasks').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: SizedBox(
                    width: 50,
                    child: LinearProgressIndicator(),
                  ),
                );
              }
              final tasks = snapshot.data!.docs;

              // Filter the tasks based on the search text.
              final filteredTasks = tasks
                  .where((task) => task
                      .get('name')
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()))
                  .toList();

              // If the search text is not matching any task, show NotFoundList.
              if (filteredTasks.isEmpty) {
                return const NotFoundList();
              }

              // Filter the tasks based on the switch toggle. Not working currently.
              final completedTasks =
                  tasks.where((task) => task.get('isComplete')).toList();

              // Show the list of completed tasks if the switch toggle is true.
              // Currently not working. Oh well, issue for another day.
              if (widget.taskStateManager.switchToggle) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    final task = completedTasks[index];
                    final taskName = task.get('name');
                    final isComplete = task.get('isComplete');

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        color:
                            isComplete ? cardCompletedStyle : cardActiveStyle,
                        child: ListTile(
                          title: Text(taskName,
                              style: isComplete
                                  ? completedTaskStyle
                                  : activeTaskStyle),
                          trailing: Checkbox(
                            value: isComplete,
                            onChanged: (bool? value) {
                              widget.taskStateManager.toggleTaskCompletion(Task(
                                  id: task.id,
                                  name: taskName,
                                  isComplete: isComplete));
                            },
                          ),
                          onTap: () {
                            updateTask(Task(id: task.id, name: taskName));
                          },
                          onLongPress: () {
                            removeTask(Task(id: task.id, name: taskName));
                          },
                        ),
                      ),
                    );
                  },
                );
              } else {
                // Show the list of all tasks if the switch toggle is false.
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    final taskName = task.get('name');
                    final isComplete = task.get('isComplete');

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        color:
                            isComplete ? cardCompletedStyle : cardActiveStyle,
                        child: ListTile(
                          onTap: () {
                            updateTask(Task(id: task.id, name: taskName));
                          },
                          onLongPress: () {
                            removeTask(Task(id: task.id, name: taskName));
                          },
                          title: Text(taskName,
                              style: isComplete
                                  ? completedTaskStyle
                                  : activeTaskStyle),
                          trailing: Checkbox(
                            value: isComplete,
                            onChanged: (bool? value) {
                              widget.taskStateManager.toggleTaskCompletion(Task(
                                  id: task.id,
                                  name: taskName,
                                  isComplete: isComplete));
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
