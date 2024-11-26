import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Logout {
  // Logout method
  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_uid');
    await prefs.remove('token_expiration_time');
    // Optionally, make a request to the server to invalidate the session here

    // Redirect to login screen
    Navigator.pushReplacementNamed(context, '/login');
  }
}