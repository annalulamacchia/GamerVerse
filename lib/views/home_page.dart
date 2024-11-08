import 'package:flutter/material.dart';
import '../widgets/category_section.dart';
import 'search_page.dart';  // Updated path

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
                MaterialPageRoute(builder: (context) => SearchPage()),  // Updated name
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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
