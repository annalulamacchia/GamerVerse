import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';  // Import the CustomBottomNavBar widget
import '../widgets/card_game.dart'; // Import ImageCardWidget
import '../widgets/videogame_results.dart';
import '../widgets/user_results.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isVideoGameSearch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isVideoGameSearch = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isVideoGameSearch ? Colors.green : Colors.grey,
                ),
                child: const Text('Search Video Games'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isVideoGameSearch = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isVideoGameSearch ? Colors.grey : Colors.green,
                ),
                child: const Text('Search Users'),
              ),
            ],
          ),
          Expanded(
            child: isVideoGameSearch ? const VideoGameResults() : const UserResults(),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,        // Set the index based on its position (e.g., 'Home' might be 1)
        isLoggedIn: false,        // Replace with actual login status (true/false)
      ),
    );
  }
}
