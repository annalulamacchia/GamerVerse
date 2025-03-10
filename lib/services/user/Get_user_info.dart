import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileService {
  static const String _baseUrl = "https://gamerversemobile.pythonanywhere.com";

  /// Fetch user profile information by user ID.
  /// If no user ID is provided, it will fetch the user ID from SharedPreferences.
  static Future<Map<String, dynamic>> getUserByUid([String? userId]) async {
    try {
      // Recupera il token di autenticazione
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('auth_token');

      // Recupera userId da SharedPreferences se non viene passato
      userId ??= prefs.getString('user_uid');

      // Costruisci l'URL per la richiesta
      final url = Uri.parse("$_baseUrl/user-get-info");
      final body = jsonEncode({'uid': userId});

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
      print('Response body: ${response.body}'); // Log the raw response

      // Gestisci la risposta
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Verifica se i campi principali sono nulli
        final profileData = data['data'] ?? {};

        // Gestione dei valori nulli per ciascun campo
        final String? profilePicture = profileData['profile_picture']; // Può essere null o stringa
        print(profilePicture);
        final String name = profileData['name'] ?? 'Unknown';
        final String surname = profileData['surname'] ?? ' ';
        final String email = profileData['email'] ?? 'No email provided';
        final String question = profileData['question'] ?? 'No security question set';
        final String username = profileData['username'] ?? 'No username provided';
        final bool isAdmin = profileData['isAdmin'] ?? false;
        final bool accountDisabled = profileData['account_disabled'] ?? false;
        final int counterReports = profileData['counter_reports'] ?? 0;
        final String position = profileData['position'] ?? 'No position provided';

        // Gestione followers e followed come liste di ID
        final List<dynamic> followers = profileData['followers'] ?? [];
        final List<dynamic> followed = profileData['followed'] ?? [];
        final int games = profileData['games'] ?? 0;

        return {
          'success': true,
          'message': 'User profile retrieved successfully',
          'data': {
            'profile_picture': profilePicture, // Può essere null
            'name': name,
            'surname': surname,
            'email': email,
            'question': question,
            'username': username,
            'isAdmin': isAdmin,
            'account_disabled': accountDisabled,
            'counter_reports': counterReports,
            'position': position,
            'followers': followers, // Lista di follower (ID utenti)
            'followed': followed,   // Lista di followings (ID utenti)
            'games': games,
          },
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['error'] ?? 'Failed to fetch user profile.',
        };
      }
    } catch (e) {
      print('Error connecting to the server: $e');  // Log the error message
      return {
        'success': false,
        'message': 'Failed to connect to the server. Please try again later.',
      };
    }
  }
}
