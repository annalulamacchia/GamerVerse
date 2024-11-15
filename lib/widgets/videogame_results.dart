import 'package:flutter/material.dart';
import '../widgets/card_game.dart';  // Import the CardGame widget

class VideoGameResults extends StatelessWidget {
  const VideoGameResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example list of video games with their image URLs
    final List<Map<String, String>> videoGames = [
      {'title': 'Game 1', 'imageUrl': 'https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg'},
      {'title': 'Game 2', 'imageUrl': 'https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg'},
      {'title': 'Game 3', 'imageUrl': 'https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg'},
      {'title': 'Game 4', 'imageUrl': 'https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg'},
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Display 2 cards per row
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: videoGames.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // Add navigation to specific game or other actions
          },
          child: ImageCardWidget(
            imageUrl: videoGames[index]['imageUrl']!, // Pass the image URL or other dat
          ),
        );
      },
    );
  }
}
