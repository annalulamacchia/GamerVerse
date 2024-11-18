import 'package:flutter/material.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart'; // Import your custom Bottom NavBar

class NewPasswordPage extends StatelessWidget {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  NewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.white), // White title color
        ),
        backgroundColor: AppColors.veryDarkGreen,
        iconTheme: const IconThemeData(color: Colors.white), // White icon color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videogame_asset,
                size: 60, color: AppColors.lightestGreen),
            const SizedBox(height: 20),
            const Text(
              'Reset Password',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightestGreen),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle: const TextStyle(color: AppColors.lightestGreen),
                fillColor: AppColors.veryDarkGreen,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
              obscureText: true,
              style: const TextStyle(color: AppColors.lightestGreen),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: repeatPasswordController,
              decoration: InputDecoration(
                labelText: 'Repeat Password',
                labelStyle: const TextStyle(color: AppColors.lightestGreen),
                fillColor: AppColors.veryDarkGreen,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
              obscureText: true,
              style: const TextStyle(color: AppColors.lightestGreen),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (newPasswordController.text ==
                    repeatPasswordController.text) {
                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Passwords do not match',
                            style: TextStyle(color: AppColors.lightestGreen))),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mediumGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Change Password',
                  style: TextStyle(color: AppColors.lightestGreen)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
        isLoggedIn: false,
      ),
    );
  }
}
