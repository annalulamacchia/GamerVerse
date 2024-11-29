import 'dart:convert';
import 'package:gamerverse/models/game.dart';
import 'package:http/http.dart' as http;

class PlayingTimeService {
  static Future<double?> getAveragePlayingTime({
    required Game? game,
  }) async {
    if (game == null) {
      print('Game or Game ID is null.');
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
      print(response.body);

      if (response.statusCode == 200) {
        print('Get average playing time successfully!');

        // Parse the response body as JSON
        final data = json.decode(response.body);

        // Extract the average time (assuming the key is 'averageTime')
        if (data != null) {
          return data['averageTime'];
        } else {
          print('Response does not contain a valid "averageTime".');
          return 0;
        }
      } else {
        print(
            'Failed to get average playing time. Status code: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error occurred while getting average playing time: $e');
      return 0;
    }
  }

  static Future<double?> getPlayingTime({
    required Game? game,
    required String? userId,
  }) async {
    if (game == null) {
      print('Game or Game ID is null.');
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
        print('Get average playing time successfully!');

        // Parse the response body as JSON
        final data = json.decode(response.body);

        // Extract the average time (assuming the key is 'averageTime')
        if (data != null) {
          return data['averageTime'];
        } else {
          print('Response does not contain a valid "averageTime".');
          return null;
        }
      } else {
        print(
            'Failed to get average playing time. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while getting average playing time: $e');
      return null;
    }
  }

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

    print(response.body);
    if (response.statusCode == 200) {
      print('Set Playing Time successfully!');
      return true;
    } else {
      print('Failed to set Playing Time');
      return false;
    }
  }
}
