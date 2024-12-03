import 'package:flutter/material.dart';

class GameListSection extends StatelessWidget {
  const GameListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildGameSection(
            context, 'Wishlist', ['Image URL 1', 'Image URL 2', 'Image URL 3']),
        _buildGameSection(
            context, 'Playing', ['Image URL 4', 'Image URL 5', 'Image URL 6']),
        _buildGameSection(context, 'Completed',
            ['Image URL 7', 'Image URL 8', 'Image URL 9']),
      ],
    );
  }

  Widget _buildGameSection(
      BuildContext context, String title, List<String> imageUrls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_right, size: 40),
                onPressed: () {
                  Navigator.pushNamed(context, '/userAllGames',
                      arguments: ['Image URL 1', 'Image URL 2', 'Image URL 3']);
                },
              ),
            ],
          ),
        ),
        // Rimuovi Expanded e lascia che il ListView occupi lo spazio all'interno del SizedBox
        SizedBox(
          height: 150,  // Imposta l'altezza fissa per la sezione
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/game');
                },
                child: buildGameCard(imageUrls[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildGameCard(String imageUrl) {
    return Card(
      margin: const EdgeInsets.only(left: 15.0, right: 5, bottom: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 110,
        height: 150,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image);
          },
        ),
      ),
    );
  }
}
