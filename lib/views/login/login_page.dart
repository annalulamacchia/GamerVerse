import 'package:flutter/material.dart';
import 'package:gamerverse/services/login/loginWithGoogle_service.dart'; // Ensure this matches your service location
import 'package:gamerverse/utils/colors.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For displaying messages
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart'; // Ensure this is the correct import for your BottomNavBar

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _handleGoogleLogin(BuildContext context) async {
    try {
      // Trigger the Google login service
      final result = await LoginWithGoogleService.loginWithGoogle();

      if (result['success']) {
        // Navigate to '/home' if login is successful
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error message if login failed
        Fluttertoast.showToast(
          msg: result['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      // Handle any unexpected errors
      Fluttertoast.showToast(
        msg: 'An unexpected error occurred. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        backgroundColor: const Color(0xff163832),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                const Icon(
                  Icons.videogame_asset,
                  size: 100,
                  color: AppColors.lightestGreen,
                ),
                const SizedBox(height: 20),
                const Text(
                  'GamerVerse',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightestGreen,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/emailLogin');
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
                ElevatedButton(
                  onPressed: () => _handleGoogleLogin(context),
                  // Call the handler
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
                const SizedBox(height: 20), // Add some spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to the signup page
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: AppColors.lightestGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // Bottom navigation bar
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1, // Set to Home index or adjust as needed
      ),
    );
  }
}
