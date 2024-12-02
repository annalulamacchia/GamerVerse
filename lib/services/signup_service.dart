import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gamerverse/utils/firebase_auth_helper.dart';

class SignupService {
  final String apiUrl =
      'https://gamerversemobile.pythonanywhere.com/register'; // Replace with your Flask API URL

  Future<String?> registerUser({
    required String email,
    required String username,
    required String name,
    required String password,
    required String question,
    required String answer,
    required String profilePictureUrl,
  }) async {
    try {
      // Send registration data to the Flask API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'username': username,
          'name': name,
          'password': password,
          'question': question,
          'answer': answer,
          'profile_picture': profilePictureUrl,
        }),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        // Parse the response
        final responseData = json.decode(response.body);
        final String customToken = responseData['token']; // Retrieve custom token
        final String uid = responseData["uid"];

        // Exchange the custom token for an ID token
        final String? idToken = await FirebaseAuthHelper.exchangeCustomTokenForIdToken(customToken);
        if (idToken != null) {
          await FirebaseAuthHelper.saveTokenAndUid(idToken, uid);
          return null; // Success
        } else {
          return 'Failed to exchange custom token for ID token.';
        }
      } else {
        return 'Error: ${response.body}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

}
