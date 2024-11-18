import 'package:flutter/material.dart';

class AllgamesPage extends StatelessWidget {
  final List<String> imageUrls;

  const AllgamesPage({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        title: const Text(
          'All Images',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff163832),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Due colonne per la griglia
          crossAxisSpacing: 3.0, // Spazio tra le colonne
          mainAxisSpacing: 5.0, // Spazio tra le righe
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  (progress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                        child: Icon(Icons.broken_image,
                            size: 40, color: Colors.grey));
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
