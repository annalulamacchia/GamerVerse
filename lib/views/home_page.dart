// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import '../widgets/category_section.dart';
import '../widgets/bottom_navbar.dart';
import 'general_games_page.dart'; // Import GeneralGamesPage
import 'search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // "All Games" category with navigation to GeneralGamesPage on arrow tap
          CategorySection(
            title: 'All Games',
            onArrowTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GeneralGamesPage(),
                ),
              );
            },
          ),
          // Other categories without navigation on arrow tap
          const CategorySection(title: 'Popular Games'),
          const CategorySection(title: 'Released this Month'),
          const CategorySection(title: 'Upcoming Games'),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,       // Highlight 'Home' by default
        isLoggedIn: false,      // Replace with actual login status
      ),
    );
  }
}
