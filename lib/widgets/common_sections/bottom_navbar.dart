import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isLoggedIn;

  //final String username;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    this.isLoggedIn = false,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == 1) {
      // Navigate to Home page
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 0) {
      if (isLoggedIn) {
        // Navigate to Community page if logged in
        Navigator.pushReplacementNamed(context, '/community');
      } else {
        // Redirect to SignUp page if not logged in
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else if (index == 2) {
      if (isLoggedIn) {
        // Navigate to Profile page if logged in
        Navigator.pushReplacementNamed(context, '/profile');
      } else {
        // Redirect to Login page if not logged in
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
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
        BottomNavigationBarItem(
          icon: Icon(Icons.report),
          label: 'Reports',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.black38,
      onTap: (index) => _onItemTapped(context, index),
    );
  }
}
