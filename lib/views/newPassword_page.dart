import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/bottom_navbar.dart'; // Import your custom Bottom NavBar

class NewPasswordPage extends StatelessWidget {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: TextStyle(color: Colors.white), // White title color
        ),
        backgroundColor: AppColors.veryDarkGreen,
        iconTheme: IconThemeData(color: Colors.white), // White icon color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videogame_asset, size: 60, color: AppColors.lightestGreen),
            SizedBox(height: 20),
            Text(
              'Reset Password',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.lightestGreen),
            ),
            SizedBox(height: 20),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle: TextStyle(color: AppColors.lightestGreen),
                fillColor: AppColors.veryDarkGreen,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              obscureText: true,
              style: TextStyle(color: AppColors.lightestGreen),
            ),
            SizedBox(height: 15),
            TextField(
              controller: repeatPasswordController,
              decoration: InputDecoration(
                labelText: 'Repeat Password',
                labelStyle: TextStyle(color: AppColors.lightestGreen),
                fillColor: AppColors.veryDarkGreen,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              obscureText: true,
              style: TextStyle(color: AppColors.lightestGreen),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (newPasswordController.text == repeatPasswordController.text) {
                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passwords do not match', style: TextStyle(color: AppColors.lightestGreen))),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mediumGreen,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text('Change Password', style: TextStyle(color: AppColors.lightestGreen)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        isLoggedIn: false,
      ),
    );
  }
}
