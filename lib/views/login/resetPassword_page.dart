import 'package:flutter/material.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart'; // Import your custom Bottom NavBar

class ResetPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final List<String> securityQuestions = [
    'What is your mother\'s maiden name?',
    'What was the name of your first pet?',
    'What is your favorite book?',
  ];
  String selectedQuestion = '';

  ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    selectedQuestion = securityQuestions[0]; // Default selected question

    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.white), // White title color
        ),
        backgroundColor: AppColors.darkGreen,
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
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                labelStyle: const TextStyle(color: AppColors.lightestGreen),
                fillColor: AppColors.veryDarkGreen,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
              style: const TextStyle(color: AppColors.lightestGreen),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedQuestion,
              items: securityQuestions.map((String question) {
                return DropdownMenuItem<String>(
                  value: question,
                  child: Text(question,
                      style: const TextStyle(color: AppColors.lightestGreen)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                selectedQuestion = newValue!;
              },
              decoration: InputDecoration(
                labelText: 'Reset Password Question',
                labelStyle: const TextStyle(color: AppColors.lightestGreen),
                fillColor: AppColors.veryDarkGreen,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
              dropdownColor: AppColors.veryDarkGreen,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: answerController,
              decoration: InputDecoration(
                labelText: 'Reset Password Answer',
                labelStyle: const TextStyle(color: AppColors.lightestGreen),
                fillColor: AppColors.veryDarkGreen,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
              style: const TextStyle(color: AppColors.lightestGreen),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/newPassword');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mediumGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Reset',
                  style: TextStyle(color: AppColors.lightestGreen)),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Remembered Password? Login',
                  style: TextStyle(color: AppColors.lightGreen)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
      ),
    );
  }
}
