import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gamerverse/utils/firebase_auth_helper.dart';

class LoginWithEmailService {
  static const String _baseUrl = "https://gamerversemobile.pythonanywhere.com";

  static Future<Map<String, dynamic>> loginWithEmail(String email, String password) async {
    try {
      final url = Uri.parse("$_baseUrl/login");
      final body = jsonEncode({'email': email, 'password': password});

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if(data['success'] == 'False'){//account is blocked
          return {
            'success': false,
            'message': 'User is blocked.',
          };
        }
        final customToken = data['token'];
        final uid = data['uid'];

        final String? idToken = await FirebaseAuthHelper.exchangeCustomTokenForIdToken(customToken);

        if (idToken == null) {
          return {
            'success': false,
            'message': 'Failed to retrieve ID token. Please try again later.',
          };
        }

        await FirebaseAuthHelper.saveTokenAndUid(idToken, uid);

        return {
          'success': true,
          'message': 'Login successful',
          'token': idToken,
          'uid': uid,
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['error'] ?? 'An error occurred during login.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to connect to the server. Please try again later.',
      };
    }
  }

}
