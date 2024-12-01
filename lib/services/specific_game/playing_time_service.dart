import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:gamerverse/models/game.dart';
import 'package:http/http.dart' as http;

class PlayingTimeService {
  //function to get the Average Playing Time of a specific game
  static Future<double?> getAveragePlayingTime({
    required Game? game,
  }) async {
    if (game == null) {
      if (kDebugMode) {
        print('Game or Game ID is null.');
      }
      return null;
    }

    final url = Uri.parse(
        'https://gamerversemobile.pythonanywhere.com/get_average_playing_time');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'gameId': game.id,
        }),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Get average playing time successfully!');
        }

        final data = json.decode(response.body);
        if (data != null) {
          return data['averageTime'];
        } else {
          if (kDebugMode) {
            print('Response does not contain a valid "averageTime".');
          }
          return 0;
        }
      } else {
        if (kDebugMode) {
          print(
              'Failed to get average playing time. Status code: ${response.statusCode}');
        }
        return 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred while getting average playing time: $e');
      }
      return 0;
    }
  }

  //function to get the Playing Time inserted by the current user on a specific game
  static Future<double?> getPlayingTime({
    required Game? game,
    required String? userId,
  }) async {
    if (game == null) {
      if (kDebugMode) {
        print('Game or Game ID is null.');
      }
      return null;
    }

    final url = Uri.parse(
        'https://gamerversemobile.pythonanywhere.com/get_playing_time');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'gameId': game.id,
        }),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Get playing time successfully!');
        }

        final data = json.decode(response.body);
        return data['playing_time'].toDouble();
      } else {
        if (kDebugMode) {
          print(
              'Failed to get playing time. Status code: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred while getting playing time: $e');
      }
      return null;
    }
  }

  //function to set the Playing Time on a specific game
  static Future<bool> setPlayingTime(
      {required String? userId,
      required Game? game,
      required double playingTime}) async {
    final url = Uri.parse(
        'https://gamerversemobile.pythonanywhere.com/set_playing_time');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
          {'userId': userId, 'gameId': game!.id, 'playingTime': playingTime}),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Set Playing Time successfully!');
      }
      return true;
    } else {
      if (kDebugMode) {
        print('Failed to set Playing Time');
      }
      return false;
    }
  }
}
