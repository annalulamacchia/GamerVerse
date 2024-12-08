import 'package:flutter/material.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/services/reset_password/check_answer_service.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final List<String> securityQuestions = const [
    'What is your pet’s name?',
    'What is your favorite color?',
    'Where were you born?',
  ];
  String selectedQuestion = 'What is your pet’s name?'; // Default
  bool isLoading = false;

  Future<void> handleReset() async {
    setState(() {
      isLoading = true;
    });

    final email = emailController.text.trim();
    final answer = answerController.text.trim();

    if (email.isEmpty || answer.isEmpty || selectedQuestion.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields.')),
        );
      });
      setState(() {
        isLoading = false;
      });
      return;
    }

    final success = await CheckAnswerService.checkAnswer(email, selectedQuestion, answer);
    setState(() {
      isLoading = false;
    });

    if (success) {
      // Navigate to new password page and show a success message
      Navigator.pushNamed(
        context,
        '/newPassword',
        arguments: {'email': email}, // Correctly pass email as a map
      ).then((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset successfully.')),
          );
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect answer or email. Please try again.')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        title: const Text('Reset Password', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.darkGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videogame_asset, size: 60, color: AppColors.lightestGreen),
            const SizedBox(height: 20),
            const Text(
              'Reset Password',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.lightestGreen),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                labelStyle: const TextStyle(color: AppColors.lightestGreen),
                fillColor: AppColors.veryDarkGreen,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              style: const TextStyle(color: AppColors.lightestGreen),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedQuestion,
              items: securityQuestions.map((String question) {
                return DropdownMenuItem<String>(
                  value: question,
                  child: Text(question, style: const TextStyle(color: AppColors.lightestGreen)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedQuestion = newValue ?? securityQuestions.first;
                });
              },
              decoration: InputDecoration(
                labelText: 'Reset Password Question',
                labelStyle: const TextStyle(color: AppColors.lightestGreen),
                fillColor: AppColors.veryDarkGreen,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              style: const TextStyle(color: AppColors.lightestGreen),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: handleReset,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mediumGreen,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Reset', style: TextStyle(color: AppColors.lightestGreen)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
