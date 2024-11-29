import 'dart:convert';
import 'package:gamerverse/models/game.dart';
import 'package:gamerverse/models/userReview.dart';
import 'package:http/http.dart' as http;

class StatusGameService {
  static Future<void> setPlaying({
    required String? userId,
    required Game? game,
  }) async {
    final url =
        Uri.parse('https://gamerversemobile.pythonanywhere.com/set_playing');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'gameId': game!.id,
        'gameName': game.name,
        'gameCover': game.cover,
        'criticsRating': game.criticsRating,
      }),
    );

    print(response.body);
    if (response.statusCode == 200) {
      print('Set Playing status successfully!');
    } else {
      print('Failed to set Playing status');
    }
  }

  static Future<void> setCompleted({
    required String? userId,
    required Game? game,
  }) async {
    final url =
    Uri.parse('https://gamerversemobile.pythonanywhere.com/set_completed');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'gameId': game!.id,
        'gameName': game.name,
        'gameCover': game.cover,
        'criticsRating': game.criticsRating,
      }),
    );

    print(response.body);
    if (response.statusCode == 200) {
      print('Set Completed status successfully!');
    } else {
      print('Failed to set Completed status');
    }
  }

  static Future<void> removePlaying({
    required String? userId,
    required Game? game,
  }) async {
    final url =
    Uri.parse('https://gamerversemobile.pythonanywhere.com/remove_playing');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'gameId': game!.id,
      }),
    );

    print(response.body);
    if (response.statusCode == 200) {
      print('Remove Playing status successfully!');
    } else {
      print('Failed to remove Playing status');
    }
  }

  static Future<void> removeCompleted({
    required String? userId,
    required Game? game,
  }) async {
    final url =
    Uri.parse('https://gamerversemobile.pythonanywhere.com/remove_completed');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'gameId': game!.id,
      }),
    );

    print(response.body);
    if (response.statusCode == 200) {
      print('Remove Completed status successfully!');
    } else {
      print('Failed to remove Completed status');
    }
  }

  static Future<Map<String, dynamic>?> getGameStatus({
    required String? userId,
    required Game? game,
  }) async {
    final url = Uri.parse(
        'https://gamerversemobile.pythonanywhere.com/get_status_game');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'gameId': game!.id,
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded;
    } else {
      print('Failed to get game status from wishlist');
      return null;
    }
  }

  static Future<List<UserReview>?> getUsersByStatusGame(String gameId) async {
    final String url =
        'https://gamerversemobile.pythonanywhere.com/get_users_by_status_game';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'gameId': gameId,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['users'] != null) {
          return (data['users'] as List).map((userJson) {
            return UserReview.fromJson(userJson);
          }).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
