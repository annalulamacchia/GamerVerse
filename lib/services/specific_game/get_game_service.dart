import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GameService{
  static const String _baseUrl = "https://gamerversemobile.pythonanywhere.com";

  /// Fetch user profile information by user ID.
  /// Accepts an optional parameter for user ID, if not provided it fetches from SharedPreferences.
  static Future<Map<String, dynamic>> getGamebyId(String gameId) async {
    try {

      if (gameId == null) {
        return {
          'success': false,
          'message': 'No authentication token or user ID found. Please log in again.',
        };
      }

      // Costruisci l'URL per la richiesta
      final url = Uri.parse("$_baseUrl/game-get-info");
      final body = jsonEncode({'gameId': gameId});

      // Effettua la richiesta POST
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Log the raw response

      // Gestisci la risposta
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Verifica se i campi principali sono nulli
        final gameData = data['data'] ?? {};

        // Gestione dei valori nulli per ciascun campo
        final String? idApi = gameData['id_api']; // Può essere null o stringa
        final String gameName = gameData['name'] ?? 'Unknown Game';
        final String coverImage = gameData['cover'] ?? 'No cover available';
        final double criticRating = gameData['rating']?.toDouble() ?? 0.0;

        final Map<String, dynamic>? reviews = gameData['reviews'];
        if (reviews != null) {
          reviews.forEach((reviewId, reviewData) {
            final String writerId = reviewData['writer_id'] ?? 'Unknown Writer';
            final String reviewDescription = reviewData['description'] ?? 'No description provided';
            final double reviewRating = reviewData['rating']?.toDouble() ?? 0.0;
            final int likes = reviewData['likes'] ?? 0;
            final int dislikes = reviewData['dislikes'] ?? 0;

            // Usa questi dati per visualizzare o elaborare le recensioni
          });
        } else {
          // Nessuna recensione trovata
        }
        return {
          'success': true,
          'message': 'User profile retrieved successfully',
          'data': {
            'id_api': idApi, // Può essere null
            'name': gameName,
            'cover': coverImage,
            'rating': criticRating,
            'reviews': reviews?.map((reviewId, reviewData) {
              return MapEntry(reviewId, {
                'writer_id': reviewData['writer_id'] ?? 'Unknown Writer',
                'description': reviewData['description'] ?? 'No description provided',
                'rating': reviewData['rating']?.toDouble() ?? 0.0,
                'likes': reviewData['likes'] ?? 0,
                'dislikes': reviewData['dislikes'] ?? 0,
              });
            }),
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
