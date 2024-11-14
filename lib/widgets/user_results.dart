import 'package:flutter/material.dart';

class UserResults extends StatelessWidget {
  const UserResults({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text((index + 1).toString()),
          ),
          title: Text('Username ${index + 1}'),
        );
      },
    );
  }
}
