import 'package:flutter/material.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/services/reset_password/reset_password_service.dart';

class NewPasswordPage extends StatefulWidget {
  final String email; // Add email as a final field

  const NewPasswordPage(
      {super.key, required this.email}); // Update constructor to accept email

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();
  bool isLoading = false;

  Future<void> handleChangePassword() async {
    setState(() {
      isLoading = true;
    });

    final newPassword = newPasswordController.text.trim();
    final repeatPassword = repeatPasswordController.text.trim();

    if (newPassword.isEmpty ||
        repeatPassword.isEmpty ||
        newPassword != repeatPassword) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match or are empty.')),
        );
      });
      setState(() {
        isLoading = false;
      });
      return;
    }

    final success =
        await ResetPasswordService.resetPassword(widget.email, newPassword);
    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to reset password. Please try again.')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        title:
            const Text('Reset Password', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.veryDarkGreen,
        iconTheme: const IconThemeData(color: Colors.white),
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
            isLoading
                ? const CircularProgressIndicator(color: Colors.teal)
                : ElevatedButton(
                    onPressed: handleChangePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mediumGreen,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Change Password',
                        style: TextStyle(color: AppColors.lightestGreen)),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}
