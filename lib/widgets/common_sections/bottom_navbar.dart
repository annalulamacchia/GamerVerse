import 'package:flutter/material.dart';
import 'package:gamerverse/services/report_service.dart';

// to read token from local storage
import 'package:gamerverse/utils/firebase_auth_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  bool isLoggedIn = false;
  bool isAdmin = false;
  String userId = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final loggedIn = await FirebaseAuthHelper.checkTokenValidity();
    setState(() {
      isLoggedIn = loggedIn; // Update the state with the result
    });
    if (isLoggedIn) {
      final prefs = await SharedPreferences.getInstance();
      final String uid = prefs.getString('user_uid')!;
      setState(() {
        userId = uid;
      });
      final admin = await ReportService.isAdmin(userId: userId);
      setState(() {
        isAdmin = admin;
      });
    }
  }

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
    } else if (isAdmin && index == 3) {
      Navigator.pushReplacementNamed(context, '/admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = <BottomNavigationBarItem>[
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
      if (isAdmin)
        BottomNavigationBarItem(
          icon: Icon(Icons.report),
          label: 'Reports',
        ),
    ];

    final validIndex = widget.currentIndex < items.length
        ? widget.currentIndex
        : 2;

    return BottomNavigationBar(
      items: items,
      currentIndex: validIndex,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.black38,
      onTap: (index) => _onItemTapped(context, index),
    );
  }
}
