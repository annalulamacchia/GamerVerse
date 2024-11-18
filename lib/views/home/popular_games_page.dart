import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/common_sections/card_game.dart'; // Import the updated ImageCardWidget
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart'; // Your custom bottom navbar

class PopularGamesPage extends StatefulWidget {
  const PopularGamesPage({super.key});

  @override
  _PopularGamesPage createState() => _PopularGamesPage();
}

class _PopularGamesPage extends State<PopularGamesPage> {
  // Example list of game image URLs (replace with actual game URLs)
  final List<String> gameImages = [
    'https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg',
    'https://via.placeholder.com/400x200?text=Game+2',
    'https://via.placeholder.com/400x200?text=Game+3',
    'https://via.placeholder.com/400x200?text=Game+4',
    'https://via.placeholder.com/400x200?text=Game+5',
    'https://via.placeholder.com/400x200?text=Game+6',
    'https://via.placeholder.com/400x200?text=Game+7',
    'https://via.placeholder.com/400x200?text=Game+8',
  ];

  // Show filters popup towards the top
  void _showFilterPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow more flexible height control
      backgroundColor: Colors.transparent, // Make the background transparent
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5, // Start at half the screen height
          minChildSize: 0.3, // Minimum height of the sheet
          maxChildSize: 0.7, // Maximum height of the sheet
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag indicator
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Filters Section
                  const Text(
                    'Order By:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      FilterChip(
                        label: const Text('Popularity'),
                        onSelected: (value) {
                          // Handle sorting by popularity
                        },
                      ),
                      FilterChip(
                        label: const Text('Release Date'),
                        onSelected: (value) {
                          // Handle sorting by release date
                        },
                      ),
                      FilterChip(
                        label: const Text('Rating'),
                        onSelected: (value) {
                          // Handle sorting by rating
                        },
                      ),
                      FilterChip(
                        label: const Text('Alphabetical'),
                        onSelected: (value) {
                          // Handle sorting alphabetically
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    'Filter By:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  // Platform Filters
                  const Text('Platform:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 10,
                    children: [
                      FilterChip(
                        label: const Text('PS4'),
                        onSelected: (value) {
                          // Handle PS4 filter
                        },
                      ),
                      FilterChip(
                        label: const Text('PC'),
                        onSelected: (value) {
                          // Handle PC filter
                        },
                      ),
                      FilterChip(
                        label: const Text('Xbox'),
                        onSelected: (value) {
                          // Handle Xbox filter
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Genre Filters
                  const Text('Genres:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 10,
                    children: [
                      FilterChip(
                        label: const Text('RPG'),
                        onSelected: (value) {
                          // Handle RPG filter
                        },
                      ),
                      FilterChip(
                        label: const Text('Action'),
                        onSelected: (value) {
                          // Handle Action filter
                        },
                      ),
                      FilterChip(
                        label: const Text('Strategy'),
                        onSelected: (value) {
                          // Handle Strategy filter
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Popular Games', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: _showFilterPopup, // Show filter popup on click
          ),
        ],
      ),
      body: Column(
        children: [
          // Game Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: gameImages.length,
              // Use the length of the gameImages list
              itemBuilder: (context, index) {
                // Passing each game's image URL to ImageCardWidget
                return ImageCardWidget(
                  imageUrl: gameImages[index], // Pass the URL here
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
          currentIndex: 1), // Adjust index for your app structure
    );
  }
}
