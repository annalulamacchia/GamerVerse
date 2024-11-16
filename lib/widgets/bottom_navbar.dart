import 'package:flutter/material.dart';
import 'package:gamerverse/views/admin_report_page.dart';
import 'package:gamerverse/views/home_page.dart';
import 'package:gamerverse/views/profile/profile_page.dart';
import 'package:gamerverse/views/login_page.dart';
import 'package:gamerverse/views/community/community_page.dart';

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
          MaterialPageRoute(builder: (context) => const CommunityPage()),
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
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminReportPage()),
      );
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
