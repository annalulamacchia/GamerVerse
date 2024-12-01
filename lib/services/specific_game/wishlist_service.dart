import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:gamerverse/models/game.dart';
import 'package:gamerverse/models/user.dart';
import 'package:http/http.dart' as http;

class WishlistService {
  //function to add a specific game on the wishlist of the current user
  static Future<void> addGameToWishlist({
    required String? userId,
    required Game? game,
  }) async {
    final url = Uri.parse(
        'https://gamerversemobile.pythonanywhere.com/add_game_to_wishlist');
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
        print('Game added to wishlist successfully!');
      }
    } else {
      if (kDebugMode) {
        print('Failed to add game to wishlist');
      }
    }
  }

  //function to remove a specific game from the wishlist of the current user
  static Future<void> removeGameFromWishlist({
    required String? userId,
    required Game? game,
  }) async {
    final url = Uri.parse(
        'https://gamerversemobile.pythonanywhere.com/remove_game_from_wishlist');
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
        print('Game removed from wishlist successfully!');
      }
    } else {
      if (kDebugMode) {
        print('Failed to remove game from wishlist');
      }
    }
  }

  //function to retrieve is a specific game is in the wishlist of the current user
  static Future<bool?> gameIsInWishlist({
    required String? userId,
    required Game? game,
  }) async {
    final url = Uri.parse(
        'https://gamerversemobile.pythonanywhere.com/game_is_in_wishlist');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'gameId': game!.id,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (kDebugMode) {
        print('Success to get game from wishlist');
      }
      return data['found'];
    } else {
      if (kDebugMode) {
        print('Failed to get game from wishlist');
      }
      return null;
    }
  }

  //function to get all users that have a specific game on their wishlist
  static Future<List<User>?> getUsersByGame(String gameId) async {
    final String url =
        'https://gamerversemobile.pythonanywhere.com/get_users_by_game';

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
            print('Success to get users that liked game');
          }
          return (data['users'] as List).map((userJson) {
            return User.fromJson(userJson);
          }).toList();
        } else {
          if (kDebugMode) {
            print('Failed to get users that liked game');
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
