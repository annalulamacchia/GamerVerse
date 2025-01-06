import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPasswordService {
  static const String baseUrl = 'https://gamerversemobile.pythonanywhere.com'; // Replace with your Flask backend URL

  static Future<Map<String, dynamic>>  resetPassword(String email, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'new_password': newPassword}),
      );

      if (response.statusCode == 200) {
        return {'success': 'true', 'message': response.body};
      } else {
        print(response.body);
        return {'success': 'false', 'message': response.body};
      }
    } catch (e) {
      print('$e');
      return {'success': false, 'message': '$e'};
    }
  }
}
