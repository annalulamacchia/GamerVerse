import 'package:flutter/material.dart';
import '../widgets/card_game.dart'; // Import the ImageCardWidget

class CategorySection extends StatelessWidget {
  final String title;
  final VoidCallback? onArrowTap; // Add onArrowTap callback for arrow icon

  const CategorySection({
    super.key,
    required this.title,
    this.onArrowTap, // Accept an optional onArrowTap callback
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
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed:
                    onArrowTap ?? () {}, // Trigger onArrowTap if provided
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220, // Aumentato l'altezza per dare più spazio alle card
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4, // Numero degli elementi da visualizzare
            itemBuilder: (context, index) {
              // Usa URL di esempio o sostituisci con quelli effettivi
              String imageUrl =
                  'https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg'; // Placeholder immagine

              return Container(
                width: 180,
                // Aumentato per rendere le card più grandi
                margin: const EdgeInsets.symmetric(horizontal: 1),
                // Ridotto il padding tra le card
                child:
                    ImageCardWidget(imageUrl: imageUrl), // Usa ImageCardWidget
              );
            },
          ),
        ),
      ],
    );
  }
}
