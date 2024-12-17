import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/common_sections/card_game.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final VoidCallback? onArrowTap;
  final List<Map<String, dynamic>>? games;

  const CategorySection({
    super.key,
    required this.title,
    this.onArrowTap,
    this.games,
  });

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
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: onArrowTap ?? () {},
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: games?.length ?? 0,
            itemBuilder: (context, index) {
              final game = games![index];
              final imageUrl = game['coverUrl'] ?? '';

              return Container(
                width: 180,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: ImageCardWidget(
                  imageUrl: imageUrl,
                  gameId: game['id'],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
