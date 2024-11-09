// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import '../widgets/category_section.dart';
import '../widgets/bottom_navbar.dart';
import 'search_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          CategorySection(title: 'All Games'),
          CategorySection(title: 'Popular Games'),
          CategorySection(title: 'Released this Month'),
          CategorySection(title: 'Upcoming Games'),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,       // Highlight 'Home' by default
        isLoggedIn: false,      // Replace with actual login status
      ),
    );
  }
}
