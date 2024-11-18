import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/category_section.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';

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
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // "All Games" category with navigation to AllGamesPage on arrow tap
          CategorySection(
            title: 'All Games',
            onArrowTap: () {
              Navigator.pushNamed(context, '/allGames');
            },
          ),
          // "Popular Games" category with navigation to PopularGamesPage on arrow tap
          CategorySection(
            title: 'Popular Games',
            onArrowTap: () {
              Navigator.pushNamed(context, '/popularGames');
            },
          ),
          // "Released This Month" category with navigation to ReleasedThisMonthPage on arrow tap
          CategorySection(
            title: 'Released this Month',
            onArrowTap: () {
              Navigator.pushNamed(context, '/releasedGames');
            },
          ),
          // "Upcoming Games" category with navigation to UpcomingGamesPage on arrow tap
          CategorySection(
            title: 'Upcoming Games',
            onArrowTap: () {
              Navigator.pushNamed(context, '/upcomingGames');
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1, // Highlight 'Home' by default
        isLoggedIn: false, // Replace with actual login status
      ),
    );
  }
}
