import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LogoutService {
  static const String _baseUrl = "https://gamerversemobile.pythonanywhere.com";

  // Logout method
  static Future<Map<String, dynamic>> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      
      // Call the /logout API to invalidate the session
      final url = Uri.parse("$_baseUrl/logout");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': prefs.getString('user_uid'),'token':prefs.getString('auth_token')}), // Ensure the body is in the correct format
      );

      if (response.statusCode == 200) {
        // Remove the saved data
        await prefs.remove('auth_token');
        await prefs.remove('user_uid');
        await prefs.remove('token_expiration_time');

        return {
          'success': true,
          'message': 'Logout successful',
        };
      } else {
        // Server error while logging out
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['error'] ?? 'An error occurred while logging out.',
        };
      }
    } catch (e) {
      // Network or server error
      return {
        'success': false,
        'message': 'Failed to connect to the server. Please try again later.',
      };
    } finally {
      // Always redirect to the login screen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
