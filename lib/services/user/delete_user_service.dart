import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeleteUserService {
  static const String _baseUrl = "https://gamerversemobile.pythonanywhere.com";

  static Future<Map<String, dynamic>> deleteUser(String uid) async {
    try {
      final url = Uri.parse("$_baseUrl/delete-account");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"uid": uid}),
      );
      print(response.body);
      if (response.statusCode == 200) {

        final prefs = await SharedPreferences.getInstance();

        await prefs.remove('auth_token');
        await prefs.remove('user_uid');
        await prefs.remove('token_expiration_time');

        return json.decode(response.body);
      } else {

        return {"success": false, "message": "Failed to delete user"};
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
