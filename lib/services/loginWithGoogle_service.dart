import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // to read token from local storage
import 'package:gamerverse/utils/firebase_auth_helper.dart';

class LoginWithGoogleService {
  static const String _baseUrl = 'https://gamerversemobile.pythonanywhere.com';

  static Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      // Ensure Firebase is initialized
      await Firebase.initializeApp();

      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Sign out to ensure fresh sign-in
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

      // Google Sign-In
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return {'success': false, 'message': 'Google sign-in was canceled.'};
      }

      // Get Google credentials
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      if (googleAuth.idToken == null) {
        return {'success': false, 'message': 'Failed to retrieve Google ID Token.'};
      }

      // Sign in with Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential firebaseUserCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Ensure the user object is not null
      final User? user = firebaseUserCredential.user;
      if (user == null) {
        throw Exception("Firebase user is null. Authentication failed.");
      }

      // Get Firebase token
      final String? firebaseToken = await user.getIdToken();

      if (firebaseToken == null || firebaseToken.isEmpty) {
        return {'success': false, 'message': 'Failed to retrieve Firebase ID Token.'};
      }

      // Send Firebase token to Flask server
      final response = await http.post(
        Uri.parse('$_baseUrl/login-with-google'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idToken': firebaseToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {

          final String? idToken = await FirebaseAuthHelper.exchangeCustomTokenForIdToken(data['token']);

          FirebaseAuthHelper.saveTokenAndUid(idToken!,data['uid']);

          return {'success': true, 'message': 'Login successful!', 'data': data};
        } else {
          return {'success': false, 'message': data['message']};
        }
      } else {
        return {'success': false, 'message': 'Server error: ${response.statusCode}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
}

