import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // To save the token locally
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication

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
        //print('Custom token received: $customToken');

        // Exchange the custom token for an ID token
        final String? idToken = await _exchangeCustomTokenForIdToken(customToken);
        if (idToken != null) {
          // Save the ID token locally
          await _saveToken(idToken);
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

  // Exchange custom token for ID token using Firebase Authentication
  Future<String?> _exchangeCustomTokenForIdToken(String customToken) async {
    try {
      // Sign in to Firebase with the custom token
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCustomToken(customToken);

      // Retrieve the ID token
      String? idToken = await userCredential.user?.getIdToken();
      //print('ID token received: $idToken');
      return idToken;
    } catch (e) {
      print('Error exchanging custom token: $e');
      return null;
    }
  }

  // Save the ID token to SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    // Get the current time in milliseconds
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    // Set an expiration duration (e.g., 1 hour = 3600000 milliseconds)
    final expirationDuration = Duration(hours: 1); // Change to your desired duration
    final expirationTime = currentTime + expirationDuration.inMilliseconds;

    // Save both the token and the expiration time
    await prefs.setString('auth_token', token);
    await prefs.setInt('token_expiration_time', expirationTime);

    print('Auth token and expiration time saved locally.');
  }

}
