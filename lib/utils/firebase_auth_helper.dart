// lib/utils/firebase_auth_helper.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FirebaseAuthHelper {

  // Exchanges a Firebase custom token for an ID token.
  static Future<String?> exchangeCustomTokenForIdToken(String customToken) async {
    try {
      // Sign in with the custom token
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCustomToken(customToken);

      // Retrieve the ID token from the signed-in user
      String? idToken = await userCredential.user?.getIdToken();
      return idToken;
    } catch (e) {
      print('Error exchanging custom token: $e');
      return null;
    }
  }

  //save inside SharedPreferences IDtoken (not custom token), uid and expiration time
  static Future<void> saveTokenAndUid(String token, String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final expirationTime = DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch;

    await prefs.setString('auth_token', token);
    await prefs.setString('user_uid', uid);
    await prefs.setInt('token_expiration_time', expirationTime);
  }

  static Future<bool> checkTokenValidity() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the saved token and expiration time
    final token = prefs.getString('auth_token');
    final expirationTime = prefs.getInt('token_expiration_time');

    if (token != null && token.isNotEmpty && expirationTime != null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      // Check if the token has expired
      if (currentTime > expirationTime) {
        // Token has expired, remove it from SharedPreferences
        await prefs.remove('auth_token');
        await prefs.remove('token_expiration_time');
        await prefs.remove('user_uid');

        print('Token expired and removed.');
        return false;

      } else {
        // Token is valid, proceed with the API call to verify it
        final response = await http.post(
          Uri.parse('https://gamerversemobile.pythonanywhere.com/check_token'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          // If the token is valid, reset the expiration time (e.g., 1 hour from now)
          final newExpirationTime = DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch;

          await prefs.setInt('token_expiration_time', newExpirationTime);  // Set new expiration time

          print("Token is valid. Expiration time reset.");
          return true;
        } else {
          print("Token is invalid.");
          return false;
        }
      }
    } else {
      print("No token found or token is empty.");
      return false;
    }
  }
}
