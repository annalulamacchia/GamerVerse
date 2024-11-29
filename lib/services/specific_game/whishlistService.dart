import 'dart:convert';
import 'package:gamerverse/models/game.dart';
import 'package:gamerverse/models/user.dart';
import 'package:http/http.dart' as http;

class WishlistService {
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

    print(response.body);

    if (response.statusCode == 200) {
      print('Game added to wishlist successfully!');
    } else {
      print('Failed to add game to wishlist');
    }
  }

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
      print('Game removed from wishlist successfully!');
    } else {
      print('Failed to remove game from wishlist');
    }
  }

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
      return data['found'];
    } else {
      print('Failed to get game from wishlist');
      return null;
    }
  }

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
          return (data['users'] as List).map((userJson) {
            return User.fromJson(userJson);
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
