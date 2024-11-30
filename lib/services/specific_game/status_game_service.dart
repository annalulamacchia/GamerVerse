import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:gamerverse/models/game.dart';
import 'package:gamerverse/models/userReview.dart';
import 'package:http/http.dart' as http;

class StatusGameService {
  //function to set the Playing status on a specific game
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

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Set Playing status successfully!');
      }
    } else {
      if (kDebugMode) {
        print('Failed to set Playing status');
      }
    }
  }

  //function to set the Completed status on a specific game
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

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Set Completed status successfully!');
      }
    } else {
      if (kDebugMode) {
        print('Failed to set Completed status');
      }
    }
  }

  //function to remove the Playing status on a specific game
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

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Remove Playing status successfully!');
      }
    } else {
      if (kDebugMode) {
        print('Failed to remove Playing status');
      }
    }
  }

  //function to remove the Completed status on a specific game
  static Future<void> removeCompleted({
    required String? userId,
    required Game? game,
  }) async {
    final url = Uri.parse(
        'https://gamerversemobile.pythonanywhere.com/remove_completed');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'gameId': game!.id,
      }),
    );
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Remove Completed status successfully!');
      }
    } else {
      if (kDebugMode) {
        print('Failed to remove Completed status');
      }
    }
  }

  //function to get the status of a specific game
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
      if (kDebugMode) {
        print('Success to get game status from wishlist');
      }
      return decoded;
    } else {
      if (kDebugMode) {
        print('Failed to get game status from wishlist');
      }
      return null;
    }
  }

  //function to get all the users that are currently playing or have completed a specific game
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['users'] != null) {
          if (kDebugMode) {
            print('Success to load users with status game');
          }
          return (data['users'] as List).map((userJson) {
            return UserReview.fromJson(userJson);
          }).toList();
        } else {
          if (kDebugMode) {
            print('Failed to load users with status game');
          }
          return [];
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return [];
    }
  }
}
