import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        final customToken = data['token'];
        final uid = data['uid'];

        final String? idToken = await _exchangeCustomTokenForIdToken(customToken);

        if (idToken == null) {
          return {
            'success': false,
            'message': 'Failed to retrieve ID token. Please try again later.',
          };
        }

        await _saveTokenAndUid(idToken, uid);

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

  // Make this method static
  static Future<String?> _exchangeCustomTokenForIdToken(String customToken) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCustomToken(customToken);

      String? idToken = await userCredential.user?.getIdToken();
      return idToken;
    } catch (e) {
      print('Error exchanging custom token: $e');
      return null;
    }
  }

  static Future<void> _saveTokenAndUid(String token, String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final expirationTime = DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch;

    await prefs.setString('auth_token', token);
    await prefs.setString('uid', uid);
    await prefs.setInt('token_expiration_time', expirationTime);
  }


}
