import 'package:flutter/material.dart';
import 'package:todolist_flutter/models/task_state_manager.dart';
import '../appTheme.dart';

class ToDoHeader extends StatefulWidget {
  final TaskStateManager taskStateManager;

  ToDoHeader({
    Key? key,
    required this.taskStateManager,
  }) : super(key: key);

  @override
  State<ToDoHeader> createState() => _ToDoHeaderState();
}

class _ToDoHeaderState extends State<ToDoHeader> {
  bool _showCompletedOnly = false;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.list_rounded);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 50,
            left: 30,
            right: 30,
            bottom: 20,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Image(
                  image: AssetImage('assets/images/app_logo.png'),
                  width: 70,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'TuDu',
                style: appTitleStyle,
              ),
              Text('a simple to-do list', style: appSubTitleStyle),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Switch(
                // Switch between icons
                thumbIcon: thumbIcon,
                // Switch between true or false
                value: _showCompletedOnly,
                onChanged: (bool? value) {
                  setState(() {
                    _showCompletedOnly = value!;
                    widget.taskStateManager
                        .setShowCompletedTasks(_showCompletedOnly);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
