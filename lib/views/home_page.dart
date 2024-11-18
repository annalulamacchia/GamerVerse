import 'package:flutter/material.dart';
import '../widgets/category_section.dart';
import '../widgets/bottom_navbar.dart';
import 'all_games_page.dart'; // Import AllGamesPage
import 'search_page.dart'; // Import SearchPage
import 'popular_games_page.dart'; // Import PopularGamesPage
import 'released_this_month_page.dart'; // Import ReleasedThisMonthPage
import 'upcoming_games_page.dart'; // Import UpcomingGamesPage

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
          // "All Games" category with navigation to AllGamesPage on arrow tap
          CategorySection(
            title: 'All Games',
            onArrowTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllGamesPage(),
                ),
              );
            },
          ),
          // "Popular Games" category with navigation to PopularGamesPage on arrow tap
          CategorySection(
            title: 'Popular Games',
            onArrowTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PopularGamesPage(),
                ),
              );
            },
          ),
          // "Released This Month" category with navigation to ReleasedThisMonthPage on arrow tap
          CategorySection(
            title: 'Released this Month',
            onArrowTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReleasedThisMonthPage(),
                ),
              );
            },
          ),
          // "Upcoming Games" category with navigation to UpcomingGamesPage on arrow tap
          CategorySection(
            title: 'Upcoming Games',
            onArrowTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpcomingGamesPage(),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,       // Highlight 'Home' by default
        isLoggedIn: false,      // Replace with actual login status
      ),
    );
  }
}
