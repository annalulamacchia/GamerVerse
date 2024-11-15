import 'package:flutter/material.dart';
import 'package:gamerverse/views/specific_game/specific_game.dart';

class CategorySection extends StatelessWidget {
  final String title;

  const CategorySection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SpecificGame(),
                    ),
                  );
                },
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.all(8),
                  color: Colors.grey[300],
                  child: Center(child: Text('Image ${index + 1}')),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
