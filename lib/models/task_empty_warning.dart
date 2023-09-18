import 'package:flutter/material.dart';
import 'package:todolist_flutter/appTheme.dart';

class EmptyNameAlert extends StatelessWidget {
  const EmptyNameAlert({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          CircleAvatar(
            child: Icon(
              Icons.warning,
              color: Colors.orange,
            ),
          ),
          SizedBox(width: 10),
          Text('Warning', style: appSubTitleStyle),
        ],
      ),
      content:
          const Text('Task name cannot be empty!', style: warningTextStyle),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
