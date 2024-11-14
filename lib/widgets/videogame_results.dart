import 'package:flutter/material.dart';

class VideoGameResults extends StatelessWidget {
  const VideoGameResults({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(8),
          color: Colors.grey[300],
          child: Center(child: Text('Game ${index + 1}')),
        );
      },
    );
  }
}
