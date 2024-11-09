import 'package:flutter/material.dart';
import '../utils/colors.dart';
import './newPassword_page.dart';
import './login_page.dart';
import '../widgets/bottom_navbar.dart'; // Import your custom Bottom NavBar

class ResetPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final List<String> securityQuestions = [
    'What is your mother\'s maiden name?',
    'What was the name of your first pet?',
    'What is your favorite book?',
  ];
  String selectedQuestion = '';

  @override
  Widget build(BuildContext context) {
    selectedQuestion = securityQuestions[0]; // Default selected question

    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: TextStyle(color: Colors.white), // White title color
        ),
        backgroundColor: AppColors.darkGreen,
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
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                labelStyle: TextStyle(color: AppColors.lightestGreen),
                fillColor: AppColors.veryDarkGreen,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              style: TextStyle(color: AppColors.lightestGreen),
            ),
            SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedQuestion,
              items: securityQuestions.map((String question) {
                return DropdownMenuItem<String>(
                  value: question,
                  child: Text(question, style: TextStyle(color: AppColors.lightestGreen)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                selectedQuestion = newValue!;
              },
              decoration: InputDecoration(
                labelText: 'Reset Password Question',
                labelStyle: TextStyle(color: AppColors.lightestGreen),
                fillColor: AppColors.veryDarkGreen,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              dropdownColor: AppColors.veryDarkGreen,
            ),
            SizedBox(height: 15),
            TextField(
              controller: answerController,
              decoration: InputDecoration(
                labelText: 'Reset Password Answer',
                labelStyle: TextStyle(color: AppColors.lightestGreen),
                fillColor: AppColors.veryDarkGreen,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              style: TextStyle(color: AppColors.lightestGreen),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewPasswordPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mediumGreen,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text('Reset', style: TextStyle(color: AppColors.lightestGreen)),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Remembered Password? Login', style: TextStyle(color: AppColors.lightGreen)),
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
