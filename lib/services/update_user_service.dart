import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateUserService {
  static Future<Map<String, dynamic>> updateUser(Map<String, dynamic> userData) async {
    final url = Uri.parse('https://yourapi.com/update_user'); // Sostituisci con il tuo endpoint

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return {'success': true};
    } else {
      return {'success': false, 'message': 'Failed to update user'};
    }
  }
}
