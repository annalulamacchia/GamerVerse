import 'package:flutter/material.dart';
import 'loginEmail_page.dart';
import '../widgets/bottom_navbar.dart';
import '../utils/colors.dart';
import 'resetPassword_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient background for an elegant look
        decoration: const BoxDecoration(
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
                const Icon(
                  Icons.videogame_asset,
                  size: 100,
                  color: AppColors.lightestGreen,
                ),
                const SizedBox(height: 20),

                // App Name
                const Text(
                  'GamerVerse',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightestGreen,
                  ),
                ),
                const SizedBox(height: 40),

                // Login with Email Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginEmailPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightestGreen,
                    foregroundColor: AppColors.darkGreen,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Continue with Email'),
                ),
                const SizedBox(height: 15),

                // Login with Google Button
                ElevatedButton(
                  onPressed: () {
                    // Implement Google sign-in functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Log-in with Google'),
                ),
                const SizedBox(height: 15),

                // Login with Facebook Button
                ElevatedButton(
                  onPressed: () {
                    // Implement Facebook sign-in functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Log-in with Facebook'),
                ),
                const SizedBox(height: 20),

                // Forgot Password Link
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                    );
                  },
                  child: const Text(
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
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1, // Set to Home index or adjust as needed
        isLoggedIn: false, // Change based on actual login status
      ),
    );
  }
}
