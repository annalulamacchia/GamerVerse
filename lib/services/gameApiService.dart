import 'dart:convert';
import 'package:http/http.dart' as http;

class GameApiService {
  static const String clientId =
      '59now2vf9ty36w63um7grxsio0jivn'; // Sostituisci con il tuo Client ID
  static const String accessToken =
      'of7hm9lpfashde892p0d7zurciwugx'; // Sostituisci con il tuo Access Token

  static Future<Map<String, dynamic>?> fetchGameData(int gameId) async {
    final url = Uri.parse('https://api.igdb.com/v4/games');

    final String requestBody = '''
      fields *;
      where id = $gameId;
    ''';

    try {
      final response = await http.post(
        url,
        headers: {
          'Client-ID': clientId,
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded.isNotEmpty ? decoded[0] : null;
      } else {
        print('Errore: ${response.statusCode}');
        print('Messaggio: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Errore durante la richiesta: $e');
      return null;
    }
  }
}
