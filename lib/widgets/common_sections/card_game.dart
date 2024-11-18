import 'package:flutter/material.dart';

class ImageCardWidget extends StatelessWidget {
  final String imageUrl;

  const ImageCardWidget({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to SpecificGame page when the card is tapped
        Navigator.pushNamed(context, '/game');
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        elevation: 10, // Shadow for depth
        margin: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            imageUrl,
            height: 200, // Fixed height for the image
            width: double.infinity, // Make image take up full width of the card
            fit: BoxFit.cover, // Ensure the image scales properly
          ),
        ),
      ),
    );
  }
}
