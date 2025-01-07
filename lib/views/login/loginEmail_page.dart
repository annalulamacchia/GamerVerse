import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/services/login/loginWithEmail_service.dart';

class LoginEmailPage extends StatefulWidget {
  final String currentPage;

  const LoginEmailPage({super.key, required this.currentPage});

  @override
  LoginEmailPageState createState() => LoginEmailPageState();
}

class LoginEmailPageState extends State<LoginEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Email and password cannot be empty.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final response =
        await LoginWithEmailService.loginWithEmail(email, password);

    setState(() {
      _isLoading = false;
    });

    if (response['success']) {
      _showMessage('Login successful!');
      if (widget.currentPage == 'Login') {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (widget.currentPage == 'Community') {
        Navigator.pushReplacementNamed(context, '/community');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
        Navigator.pushReplacementNamed(context, '/game', arguments: int.parse(widget.currentPage));
      }
    } else {
      _showMessage(response['message']);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Login',
          style: TextStyle(color: AppColors.lightestGreen),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 25,
              ),
              child: IntrinsicHeight(
                child: Container(
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
                          Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: const TextSelectionThemeData(
                                  selectionHandleColor: AppColors.mediumGreen,
                                  cursorColor: AppColors.mediumGreen,
                                  selectionColor: AppColors.mediumGreen),
                            ),
                            //Text Area
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'E-mail',
                                filled: true,
                                fillColor: AppColors.lightGreen,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.mediumGreen),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: const TextSelectionThemeData(
                                  selectionHandleColor: AppColors.mediumGreen,
                                  cursorColor: AppColors.mediumGreen,
                                  selectionColor: AppColors.mediumGreen),
                            ),
                            //Text Area
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                filled: true,
                                fillColor: AppColors.lightGreen,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.mediumGreen),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lightestGreen,
                              foregroundColor: AppColors.darkGreen,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.darkGreen),
                                  )
                                : const Text('Log-in'),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Text(
                              "Not subscribed? Sign-up",
                              style: TextStyle(
                                color: AppColors.lightestGreen,
                                decoration: TextDecoration.underline,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              // Navigate to the reset-password page
                              Navigator.pushNamed(context, '/resetPassword');
                            },
                            child: const Text(
                              "Forgot your password? Reset here",
                              style: TextStyle(
                                color: AppColors.lightestGreen,
                                decoration: TextDecoration.underline,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 2,
      ),
    );
  }
}
