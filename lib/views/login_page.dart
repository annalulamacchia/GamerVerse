import 'package:flutter/material.dart';
import 'loginEmail_page.dart'; // Ensure you have this page created as shown before.
import '../widgets/bottom_navbar.dart';
import '../utils/colors.dart'; // Custom colors based on the green theme image

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient background for an elegant look
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.darkestGreen, AppColors.veryDarkGreen],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Icon
                Icon(
                  Icons.videogame_asset, // Placeholder for app icon
                  size: 100,
                  color: AppColors.lightestGreen,
                ),
                SizedBox(height: 20),

                // App Name
                Text(
                  'GamerVerse',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightestGreen,
                  ),
                ),
                SizedBox(height: 40),

                // Login with Email Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginEmailPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightestGreen,
                    foregroundColor: AppColors.darkGreen,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Continue with Email'),
                ),
                SizedBox(height: 15),

                // Login with Google Button
                ElevatedButton(
                  onPressed: () {
                    // Implement Google sign-in functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Log-in with Google'),
                ),
                SizedBox(height: 15),

                // Login with Facebook Button
                ElevatedButton(
                  onPressed: () {
                    // Implement Facebook sign-in functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Log-in with Facebook'),
                ),
                SizedBox(height: 20),

                // Forgot Password Link
                GestureDetector(
                  onTap: () {
                    // Implement forgot password functionality or redirection here
                  },
                  child: Text(
                    "Forgot the password? Reset",
                    style: TextStyle(
                      color: AppColors.lightestGreen,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Bottom navigation bar
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1, // Set to Home index or adjust as needed
        isLoggedIn: false, // Change based on actual login status
      ),
    );
  }
}
