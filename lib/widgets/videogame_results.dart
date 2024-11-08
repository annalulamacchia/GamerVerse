import 'package:flutter/material.dart';

class VideoGameResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(8),
          color: Colors.grey[300],
          child: Center(child: Text('Game ${index + 1}')),
        );
      },
    );
  }
}
