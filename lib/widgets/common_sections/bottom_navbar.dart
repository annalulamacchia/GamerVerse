import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // to read token from local storage

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

  @override
  void initState() {
    super.initState();
    _checkTokenValidity();
  }

  //every time the bottom_navbar is initialized, the token is verified
  // and if it correct and the expiration_time > current_time,
  // the expiration time is reset to 1 hour.
  //After 1 hour without initializing the bottom_navbar
  // (so after 1 hour without clicking the bottom_navbar), the token
  // will expired and isLogged set to False


  Future<void> _checkTokenValidity() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the saved token and expiration time
    final token = prefs.getString('auth_token');
    final expirationTime = prefs.getInt('token_expiration_time');

    //print("Token: $token");
    print("Expiration Time: $expirationTime");

    if (token != null && token.isNotEmpty && expirationTime != null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      // Check if the token has expired
      if (currentTime > expirationTime) {
        // Token has expired, remove it from SharedPreferences
        await prefs.remove('auth_token');
        await prefs.remove('token_expiration_time');

        setState(() {
          isLoggedIn = false; // Mark as not logged in if token has expired
        });

        print('Token expired and removed.');
      } else {
        // Token is valid, proceed with the API call to verify it
        final response = await http.post(
          Uri.parse('https://gamerversemobile.pythonanywhere.com/check_token'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          // If the token is valid, reset the expiration time (e.g., 1 hour from now)
          final newExpirationTime = DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch;

          await prefs.setInt('token_expiration_time', newExpirationTime);  // Set new expiration time
          setState(() {
            isLoggedIn = true;
          });
          print("Token is valid. Expiration time reset.");
        } else {
          setState(() {
            isLoggedIn = false;
          });
          print("Token is invalid.");
        }
      }
    } else {
      setState(() {
        isLoggedIn = false;
      });
      print("No token found or token is empty.");
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
      currentIndex: widget.currentIndex,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.black38,
      onTap: (index) => _onItemTapped(context, index),
    );
  }
}
