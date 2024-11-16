// lib/widgets/custom_bottom_nav_bar.dart

import 'package:flutter/material.dart';
import '../views/home_page.dart';
//import '../views/community_page.dart';
import '../views/profile/profile_page.dart';
import '../views/login_page.dart';
import '../views/community/community_page.dart';


class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isLoggedIn;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    this.isLoggedIn = false,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == 1) {
      // Navigate to Home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 0) {
      if (isLoggedIn) {
        // Navigate to Community page if logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CommunityPage()),
        );
      } else {
        // Redirect to SignUp page if not logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } else if (index == 2) {
      if (isLoggedIn) {
        // Navigate to Profile page if logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      } else {
        // Redirect to Login page if not logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
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
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      onTap: (index) => _onItemTapped(context, index),
    );
  }
}
