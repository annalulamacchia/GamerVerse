import 'package:flutter/material.dart';
import 'package:gamerverse/services/login/loginWithGoogle_service.dart'; // Ensure this matches your service location
import 'package:gamerverse/utils/colors.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For displaying messages
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart'; // Ensure this is the correct import for your BottomNavBar

class LoginPage extends StatelessWidget {
  final String currentPage;

  const LoginPage({super.key, required this.currentPage});

  Future<void> _handleGoogleLogin(BuildContext context) async {
    try {
      // Trigger the Google login service
      final result = await LoginWithGoogleService.loginWithGoogle();

      if (result['success']) {
        // Navigate to '/home' if login is successful
        if (currentPage == 'Login') {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (currentPage == 'Community') {
          Navigator.pushReplacementNamed(context, '/home');
          Navigator.pushReplacementNamed(context, '/community');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
          Navigator.pushReplacementNamed(context, '/game', arguments: int.parse(currentPage));
        }
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
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        title: const Text(
          'Login',
          style: TextStyle(color: AppColors.lightestGreen),
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
                Image.asset(
                  'assets/gamerverse.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/emailLogin',
                        arguments: currentPage);
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
                        Navigator.pushNamed(context, '/signup',
                            arguments: currentPage);
                      },
                      child: const Text(
                        'Sign-up',
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
        currentIndex: 2, // Set to Home index or adjust as needed
      ),
    );
  }
}
