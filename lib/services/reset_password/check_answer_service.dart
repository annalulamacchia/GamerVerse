import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckAnswerService {
  static const String baseUrl = 'https://gamerversemobile.pythonanywhere.com'; // Replace with your Flask backend URL

  static Future<bool> checkAnswer(String email, String question, String answer) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/check-answer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'question': question, 'answer': answer}),
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
