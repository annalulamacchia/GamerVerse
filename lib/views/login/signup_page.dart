import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart'; // Import the navbar
import 'package:gamerverse/services/signup_service.dart';
import 'dart:io';
import '../../utils/colors.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Controllers for form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();
  final TextEditingController _resetAnswerController = TextEditingController();

  String? _selectedQuestion;

  final SignupService _signupService = SignupService();

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _handleSignup() async {
    final email = _emailController.text;
    final username = _usernameController.text;
    final name = _nameController.text;
    final password = _passwordController.text;
    final repeatPassword = _repeatPasswordController.text;
    final resetAnswer = _resetAnswerController.text;

    if (password != repeatPassword) {
      _showError("Passwords do not match.");
      return;
    }

    if (_selectedQuestion == null) {
      _showError("Please select a reset password question.");
      return;
    }

    String? profilePictureUrl;
    if (_selectedImage != null) {
      profilePictureUrl = await _signupService.uploadImage(_selectedImage!);
      if (profilePictureUrl == null) {
        _showError("Failed to upload the profile picture. Please try again.");
        return;
      }
    }

    final result = await _signupService.registerUser(
      email: email,
      username: username,
      name: name,
      password: password,
      question: _selectedQuestion!,
      answer: resetAnswer,
      profilePictureUrl: profilePictureUrl ?? "",
    );

    if (result != null) {
      _showError(result);
    } else {
      Navigator.pushNamed(context, '/home');
    }
  }


  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        title: const Text(
          'GamerVerse',
          style: TextStyle(color: AppColors.lightestGreen),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Navigate to login
                },
                child: const Text(
                  "Already Subscribed? Log-in",
                  style: TextStyle(
                    color: AppColors.lightestGreen,
                    decoration: TextDecoration.underline,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.videogame_asset,
                    size: 60,
                    color: AppColors.lightestGreen,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Signup',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightestGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImageFromCamera,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.lightestGreen,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : null,
                  child: _selectedImage == null
                      ? const Icon(
                    Icons.add,
                    color: AppColors.darkGreen,
                    size: 32,
                  )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField('E-mail', _emailController, false),
              const SizedBox(height: 10),
              _buildTextField('Username', _usernameController, false),
              const SizedBox(height: 10),
              _buildTextField('Name', _nameController, false),
              const SizedBox(height: 10),
              _buildTextField('Password', _passwordController, true),
              const SizedBox(height: 10),
              _buildTextField('Repeat Password', _repeatPasswordController, true),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightGreen,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                dropdownColor: AppColors.lightGreen,
                items: const [
                  'What is your pet’s name?',
                  'What is your favorite color?',
                  'Where were you born?'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedQuestion = value;
                  });
                },
                hint: const Text(
                  'Reset Password Question',
                  style: TextStyle(color: AppColors.darkGreen),
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField('Reset Password Answer', _resetAnswerController, false),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightestGreen,
                  foregroundColor: AppColors.darkGreen,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Sign-up'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2), // Pass currentIndex here
    );
  }

  Widget _buildTextField(
      String hintText, TextEditingController controller, bool obscureText) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: AppColors.lightGreen,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
