import 'package:flutter/material.dart';

class ComingSoonCard extends StatelessWidget {
  final String relaseDate;

  const ComingSoonCard({
    super.key,
    required this.relaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            color: const Color(0xff3e6259),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Coming soon on $relaseDate',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
