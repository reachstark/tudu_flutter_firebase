import 'package:flutter/material.dart';
import '../appTheme.dart';

class NotFoundList extends StatelessWidget {
  const NotFoundList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 150,
            width: 150,
            child: Image(
              image: AssetImage('assets/images/notfound.png'),
            ),
          ),
          Text(
            'No tasks found. Try adding one.',
            style: notFoundStyle,
          ),
        ],
      ),
    );
  }
}
