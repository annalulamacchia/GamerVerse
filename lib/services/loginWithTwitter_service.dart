/*

import 'package:flutter/material.dart';
import 'package:twitter_login/twitter_login.dart'; // Twitter login package
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginWithTwitterService {
  static const String _baseUrl = 'https://gamerversemobile.pythonanywhere.com';

  static Future<Map<String, dynamic>> loginWithTwitter() async {
    try {
      final twitterLogin = TwitterLogin(
        apiKey: 'lE6ogDLuZDp2AzFOOqxGKQo6h',
        apiSecretKey: 'rVJZnRftRPl9BpH2Tk655I30REKiZjv3sxqavx8BGUwOtHn720',
        redirectURI: 'https://gamerverse-6fc6f.firebaseapp.com/__/auth/handler',
      );

      final authResult = await twitterLogin.login();

      if (authResult.status == TwitterLoginStatus.loggedIn) {
        final accessToken = authResult.authToken;
        final accessTokenSecret = authResult.authTokenSecret;

        final response = await http.post(
          Uri.parse('$_baseUrl/login-with-twitter'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'accessToken': accessToken,
            'accessTokenSecret': accessTokenSecret,
          }),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['success']) {
            // Proceed with user data, save token, navigate to home, etc.
            return {'success': true, 'message': 'Login successful!', 'data': data};
          } else {
            return {'success': false, 'message': data['error']};
          }
        } else {
          return {'success': false, 'message': 'Server error: ${response.statusCode}'};
        }
      } else if (authResult.status == TwitterLoginStatus.cancelledByUser) {
        return {'success': false, 'message': 'Login cancelled by user'};
      } else {
        return {'success': false, 'message': 'Twitter login error: ${authResult.errorMessage}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
}
*/
