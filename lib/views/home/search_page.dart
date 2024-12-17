import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/home/videogame_results.dart';
import 'package:gamerverse/widgets/home/user_results.dart';
import 'package:gamerverse/utils/colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isVideoGameSearch = true;
  String searchQuery = "";

  void handleSearch(String query) {
    if (query.trim().isEmpty) return; // Avoid empty search queries
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.darkGreen, // Background color for the app bar
        title: const Text(
          'Search',
          style: TextStyle(
            fontWeight: FontWeight.w600, // Elegant text style
            fontSize: 22,
            color: Colors.white, // White color for contrast
          ),
        ),
        centerTitle: true, // Center the title for a modern feel
      ),
      backgroundColor: AppColors.lightGreen, // Set the background color of the entire page
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: TextField(
                onSubmitted: handleSearch,
                decoration: InputDecoration(
                  hintText: 'Search for games or users...',
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.white38,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Search Type Toggle Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space the buttons evenly
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isVideoGameSearch = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isVideoGameSearch ? Colors.green : Colors.grey, // Use backgroundColor
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Search Video Games',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Add a little space between the buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isVideoGameSearch = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isVideoGameSearch ? Colors.green : Colors.grey, // Use backgroundColor
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Search Users',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Search Results Display
            Expanded(
              child: isVideoGameSearch
                  ? VideoGameResults(searchQuery: searchQuery)
                  : UserResults(searchQuery: searchQuery),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
      ),
    );
  }
}
