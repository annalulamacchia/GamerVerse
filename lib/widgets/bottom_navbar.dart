// lib/widgets/custom_bottom_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:gamerverse/views/user_profile_page.dart';
import '../views/home_page.dart';
//import '../views/community_page.dart';
import '../views/profile_page.dart';
import '../views/login_page.dart';


class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isLoggedIn;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    this.isLoggedIn = false,
  }) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    if (index == 1) {
      // Navigate to Home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 0) {
      if (isLoggedIn) {
        // Navigate to Community page if logged in
        //Navigator.pushReplacement(
          //context,
          //MaterialPageRoute(builder: (context) => CommunityPage()),
        //);
      } else {
        // Redirect to SignUp page if not logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } else if (index == 2) {
      if (isLoggedIn) {
        // Navigate to Profile page if logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      } else {
        // Redirect to Login page if not logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
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
