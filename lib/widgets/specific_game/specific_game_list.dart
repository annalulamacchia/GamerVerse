import 'package:flutter/material.dart';

class SpecificGameList extends StatelessWidget {
  final List<String> list;
  final String title;

  const SpecificGameList({super.key, required this.title, required this.list});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
        children: [
          //Fixed Text
          TextSpan(
            text: '$title:  ',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white38),
          ),

          // Dynamic Text
          for (var elem in list)
            TextSpan(
              text: '$elem    ',
            ),
        ],
      ),
    );
  }
}
