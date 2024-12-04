import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdateUserService {
  static const String _baseUrl = "https://gamerversemobile.pythonanywhere.com";
  static Future<Map<String, dynamic>> updateUser(Map<String, dynamic> userData) async {
    final url = Uri.parse("$_baseUrl/update-profile");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return {'success': true};
    } else {
      print(response.statusCode);
      return {'success': false, 'message': 'Failed to update user'};
    }
  }
}
