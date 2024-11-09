import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/bottom_navbar.dart';
import '../utils/colors.dart';
import 'dart:io';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? _selectedImage; // To hold the selected image file
  final ImagePicker _picker = ImagePicker();

  // Method to handle image picking from the camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Update state with the selected image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        title: Text(
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
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Navigate to login
                },
                child: Text(
                  "Already Subscribed? Log-in",
                  style: TextStyle(
                    color: AppColors.lightestGreen,
                    decoration: TextDecoration.underline,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Icon and "Signup" text in a row
              Row(
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
              SizedBox(height: 20),

              // CircleAvatar with camera functionality
              GestureDetector(
                onTap: _pickImageFromCamera, // Open camera on tap
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.lightestGreen,
                  backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                  child: _selectedImage == null
                      ? Icon(
                    Icons.add,
                    color: AppColors.darkGreen,
                    size: 32,
                  )
                      : null,
                ),
              ),

              SizedBox(height: 20),
              _buildTextField('E-mail', false, context),
              SizedBox(height: 10),
              _buildTextField('Username', false, context),
              SizedBox(height: 10),
              _buildTextField('Name', false, context),
              SizedBox(height: 10),
              _buildTextField('Password', true, context),
              SizedBox(height: 10),
              _buildTextField('Repeat Password', true, context),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightGreen,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                dropdownColor: AppColors.lightGreen,
                items: <String>[
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
                  // Handle selection
                },
                hint: Text(
                  'Reset Password Question',
                  style: TextStyle(color: AppColors.darkGreen),
                ),
              ),
              SizedBox(height: 10),
              _buildTextField('Reset Password Answer', false, context),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle signup action here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightestGreen,
                  foregroundColor: AppColors.darkGreen,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Sign-up'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        isLoggedIn: false,
      ),
    );
  }

  // Helper method to build consistent text fields
  Widget _buildTextField(String hintText, bool obscureText, BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: AppColors.lightGreen,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
