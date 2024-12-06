import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FriendService {
  static const String _baseUrl = "https://gamerversemobile.pythonanywhere.com";

  /// Aggiunge un amico dato il suo userId.
  static Future<Map<String, dynamic>> addFriend({required String userId}) async {
    try {
      // Recupera il token di autenticazione
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('auth_token');
      final String? UID = prefs.getString('user_uid');

      if (authToken == null) {
        return {
          'success': false,
          'message': 'No authentication token found. Please log in again.',
        };
      }

      // Costruisci l'URL per la richiesta
      final url = Uri.parse("$_baseUrl/add-friend");
      final body = jsonEncode({'friendId': userId,'userId':UID});

      // Effettua la richiesta POST
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Gestisci la risposta
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Friend added successfully.',
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['error'] ?? 'Failed to add friend.',
        };
      }
    } catch (e) {
      print('Error connecting to the server: $e');
      return {
        'success': false,
        'message': 'Failed to connect to the server. Please try again later.',
      };
    }
  }

  static Future<Map<String, dynamic>> removeFriend({required String userId}) async {
    try {
      // Recupera il token di autenticazione
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('auth_token');
      final String? UID = prefs.getString('user_uid');

      if (authToken == null) {
        return {
          'success': false,
          'message': 'No authentication token found. Please log in again.',
        };
      }

      // Costruisci l'URL per la richiesta
      final url = Uri.parse("$_baseUrl/remove-friend");
      final body = jsonEncode({'friendId': userId, 'userId': UID});

      // Effettua la richiesta POST
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Gestisci la risposta
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Friend removed successfully.',
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['error'] ?? 'Failed to remove friend.',
        };
      }
    } catch (e) {
      print('Error connecting to the server: $e');
      return {
        'success': false,
        'message': 'Failed to connect to the server. Please try again later.',
      };
    }
  }


}
