import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gamerverse/utils/firebase_auth_helper.dart';

class SignupService {
  final String apiUrl =
      'https://gamerversemobile.pythonanywhere.com/register'; // Replace with your Flask API URL
  final String imgbbApiUrl = 'https://api.imgbb.com/1/upload';
  final String imgbbApiKey =
      'ce85b3ddd83772dbecd1556c90f86d3e'; // Replace with your ImgBB API key

  Future<String?> uploadImage(File imageFile) async {
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('$imgbbApiUrl?key=$imgbbApiKey'));
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final decodedResponse = json.decode(responseData.body);
        return decodedResponse['data']
            ['url']; // The public URL of the uploaded image
      } else {
        return null; // Error handling: null if the upload fails
      }
    } catch (e) {
      return null;
    }
  }

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
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': utf8.decode(email.codeUnits),
          'username': utf8.decode(username.codeUnits),
          'name': utf8.decode(name.codeUnits),
          'password': password,
          'question': question,
          'answer': utf8.decode(answer.codeUnits),
          'profile_picture': profilePictureUrl,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final String customToken = responseData['token'];
        final String uid = responseData["uid"];

        // Exchange the custom token for an ID token
        final String? idToken =
            await FirebaseAuthHelper.exchangeCustomTokenForIdToken(customToken);
        if (idToken != null) {
          await FirebaseAuthHelper.saveTokenAndUid(idToken, uid);
          return null; // Success
        } else {
          return 'Failed to exchange custom token for ID token.';
        }
      } else {
        return response.body;
      }
    } catch (e) {
      return '$e';
    }
  }
}
