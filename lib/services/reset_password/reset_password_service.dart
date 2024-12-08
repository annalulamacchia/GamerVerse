import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPasswordService {
  static const String baseUrl = 'https://gamerversemobile.pythonanywhere.com'; // Replace with your Flask backend URL

  static Future<bool> resetPassword(String email, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'new_password': newPassword}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}
