import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/card_game.dart';

class SeriesGame extends StatelessWidget {
  const SeriesGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
          title:
              const Text('Series Game', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color(0xff163832)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 0.8,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              width: 180,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: const ImageCardWidget(
                  imageUrl:
                      'https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg'), // Usa ImageCardWidget
            );
          },
        ),
      ),
    );
  }
}
