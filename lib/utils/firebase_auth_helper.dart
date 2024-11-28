// lib/utils/firebase_auth_helper.dart
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthHelper {
  /// Exchanges a Firebase custom token for an ID token.
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
}
