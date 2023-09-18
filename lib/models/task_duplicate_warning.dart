import 'package:flutter/material.dart';

import '../appTheme.dart';

class DuplicateNameAlert extends StatelessWidget {
  const DuplicateNameAlert({
    super.key,
  });

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
      content: const Text('Task name already exists!', style: warningTextStyle),
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
