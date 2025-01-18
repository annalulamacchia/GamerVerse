import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';

class ResetPasswordService {
  static const String baseUrl = 'https://gamerversemobile.pythonanywhere.com';

  static Future<Map<String, dynamic>> resetPassword(String email, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'new_password': newPassword}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.body};
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}

class NewPasswordPage extends StatefulWidget {
  final String email;

  const NewPasswordPage({super.key, required this.email});

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();
  bool isLoading = false;

  bool isPasswordSecure(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*()\-=+[\]{}|;:,.<>?/`~]')); // At least one special character
    final isLongEnough = password.length >= 10;

    return hasUppercase && hasDigit && hasSpecialChar && isLongEnough;
  }

  Future<void> handleChangePassword() async {
    setState(() {
      isLoading = true;
    });

    final newPassword = newPasswordController.text.trim();
    final repeatPassword = repeatPasswordController.text.trim();

    if (newPassword.isEmpty || repeatPassword.isEmpty || newPassword != repeatPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match or are empty.')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (!isPasswordSecure(newPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 10 characters long, include at least one number, one uppercase letter, and one special character.')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final response = await ResetPasswordService.resetPassword(widget.email, newPassword);
    setState(() {
      isLoading = false;
    });

    if (response['success'] == true) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        title: const Text('Reset Password', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.darkGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/gamerverse.png',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle: const TextStyle(color: AppColors.darkGreen),
                fillColor: AppColors.lightGreen,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: repeatPasswordController,
              decoration: InputDecoration(
                labelText: 'Repeat Password',
                labelStyle: const TextStyle(color: AppColors.darkGreen),
                fillColor: AppColors.lightGreen,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator(color: Colors.teal)
                : ElevatedButton(
              onPressed: handleChangePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mediumGreen,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text(
                'Change Password',
                style: TextStyle(color: AppColors.lightestGreen),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}
