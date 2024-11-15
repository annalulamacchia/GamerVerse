// lib/pages/general_games_page.dart

import 'package:flutter/material.dart';
import '../widgets/card_game.dart'; // Import the updated ImageCardWidget
import '../widgets/bottom_navbar.dart'; // Your custom bottom navbar
import '../utils/colors.dart'; // Your color scheme

class GeneralGamesPage extends StatefulWidget {
  @override
  _GeneralGamesPageState createState() => _GeneralGamesPageState();
}

class _GeneralGamesPageState extends State<GeneralGamesPage> {
  bool showFilters = false; // Controls filter section visibility

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Games', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              setState(() {
                showFilters = !showFilters; // Toggle filters visibility
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Show filter options if `showFilters` is true
          if (showFilters)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Filter Section (can add functionality here)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Apply sorting by popularity
                        },
                        child: Text('Popularity'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Apply sorting by release date
                        },
                        child: Text('Release Date'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Apply sorting by rating
                        },
                        child: Text('Rating'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Apply sorting alphabetically
                        },
                        child: Text('Alphabetical'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Other filters (platforms, genres, etc.)
                ],
              ),
            ),
          // Game Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: gameImages.length, // Use the length of the gameImages list
              itemBuilder: (context, index) {
                // Passing each game's image URL to ImageCardWidget
                return ImageCardWidget(
                  imageUrl: gameImages[0], // Pass the URL here
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1), // Adjust index for your app structure
    );
  }
}
