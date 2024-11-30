import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

class GameApiService {
  static const String clientId = '59now2vf9ty36w63um7grxsio0jivn';
  static const String accessToken = 'of7hm9lpfashde892p0d7zurciwugx';

  //function to get the information of a specific game
  static Future<Map<String, dynamic>?> fetchGameData(int gameId) async {
    final url = Uri.parse('https://api.igdb.com/v4/games');

    final String requestBody = '''
      fields cover, similar_games, id, name, aggregated_rating, first_release_date, collections, storyline, summary, videos, artworks, screenshots, involved_companies, genres, platforms;
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
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
          print('Message: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during the request: $e');
      }
      return null;
    }
  }

  //function to get the cover of a specific game
  static Future<Map<String, dynamic>?> fetchCoverGame(int coverId) async {
    final url = Uri.parse('https://api.igdb.com/v4/covers');

    final String requestBody = '''
      fields url, image_id, id;
      where id = $coverId;
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
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
          print('Message: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during the request: $e');
      }
      return null;
    }
  }

  //function to get the cover of some list of games
  static Future<List<Map<String, dynamic>>?> fetchCoverByGames(
      List<dynamic> gameIds) async {
    final url = Uri.parse('https://api.igdb.com/v4/covers');
    String gameIdsFormatted = '(${gameIds.join(',')})';

    final String requestBody = '''
      fields url, id, image_id, game;
      limit 500;
      where game = $gameIdsFormatted; sort game asc;
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
        if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        }
        return [decoded];
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
          print('Message: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during the request: $e');
      }
      return null;
    }
  }

  //function to get the screenshots of a game
  static Future<List<Map<String, dynamic>>?> fetchScreenshotsGame(
      int gameId) async {
    final url = Uri.parse('https://api.igdb.com/v4/screenshots');

    final String requestBody = '''
      fields id, image_id, game;
      where game = $gameId;
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
        if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        }
        return [decoded];
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
          print('Message: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during the request: $e');
      }
      return null;
    }
  }

  //function to get the videos of a specific game
  static Future<List<Map<String, dynamic>>?> fetchVideosGame(int gameId) async {
    final url = Uri.parse('https://api.igdb.com/v4/game_videos');

    final String requestBody = '''
      fields id, video_id, game;
      where game = $gameId;
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
        if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        }
        return [decoded];
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
          print('Message: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during the request: $e');
      }
      return null;
    }
  }

  //function to get the artworks of a specific game
  static Future<List<Map<String, dynamic>>?> fetchArtworksGame(
      int gameId) async {
    final url = Uri.parse('https://api.igdb.com/v4/artworks');

    final String requestBody = '''
      fields id, image_id, game;
      where game = $gameId;
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
        if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        }
        return [decoded];
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
          print('Message: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during the request: $e');
      }
      return null;
    }
  }

  //function to get the games of a collection or series of a specific game
  static Future<List<Map<String, dynamic>>?> fetchCollections(
      List<dynamic> collectionIds) async {
    final url = Uri.parse('https://api.igdb.com/v4/collections');
    String collectionIdsFormatted = '(${collectionIds.join(',')})';

    final String requestBody = '''
      fields name, games, id;
      limit 500;
      where id = $collectionIdsFormatted; sort name asc;
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
        if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        }
        return [decoded];
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
          print('Message: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during the request: $e');
      }
      return null;
    }
  }

  //function to get platforms of a specific game
  static Future<List<Map<String, dynamic>>?> fetchPlatforms(
      List<dynamic> platformsIds) async {
    final url = Uri.parse('https://api.igdb.com/v4/platforms');
    String platformsIdsFormatted = '(${platformsIds.join(',')})';

    final String requestBody = '''
      fields id, abbreviation, name;
      limit 500;
      where id = $platformsIdsFormatted; sort name asc;
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
        if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        }
        return [decoded];
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
          print('Message: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during the request: $e');
      }
      return null;
    }
  }

  //function to get the involved companies of a specific game
  static Future<List<Map<String, dynamic>>?> fetchCompanies(
      List<dynamic> companiesIds) async {
    final url = Uri.parse('https://api.igdb.com/v4/involved_companies');
    String companiesIdsFormatted = '(${companiesIds.join(',')})';

    final String requestBody = '''
      fields id, company, developer, publisher;
      limit 500;
      where id = $companiesIdsFormatted;
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
        if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        }
        return [decoded];
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
          print('Message: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during the request: $e');
      }
      return null;
    }
  }

  //function to get developers or publishers of a specific game
  static Future<List<Map<String, dynamic>>?> fetchDevelopersOrPublishers(
      List<dynamic> devOrPubIds) async {
    final url = Uri.parse('https://api.igdb.com/v4/companies');
    String devOrPubIdsFormatted = '(${devOrPubIds.join(',')})';

    final String requestBody = '''
      fields id, name, published, developed;
      limit 500;
      where id = $devOrPubIdsFormatted; sort name asc;
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
        if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        }
        return [decoded];
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
          print('Message: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during the request: $e');
      }
      return null;
    }
  }

  //function to get the genres of a specific game
  static Future<List<Map<String, dynamic>>?> fetchGenres(
      List<dynamic> genresIds) async {
    final url = Uri.parse('https://api.igdb.com/v4/genres');
    String genresIdsFormatted = '(${genresIds.join(',')})';

    final String requestBody = '''
      fields id, name;
      limit 500;
      where id = $genresIdsFormatted; sort name asc;
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
        if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        }
        return [decoded];
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
          print('Message: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during the request: $e');
      }
      return null;
    }
  }

  //function to get useful games details for the homepage
  static Future<List<Map<String, dynamic>>?> fetchGames(String query) async {
    final url = Uri.parse('https://api.igdb.com/v4/games');

    try {
      final response = await http.post(
        url,
        headers: {
          'Client-ID': clientId,
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
        body: query,
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(decoded.map((game) => {
              'id': game['id'],
              'name': game['name'],
              'coverUrl': game['cover']?['url'] != null
                  ? "https:${game['cover']['url']}"
                      .replaceAll('t_thumb', 't_cover_big')
                  : null, // Transform thumbnail URLs if necessary
            }));
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
          print('Message: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during API call: $e');
      }
      return null;
    }
  }

  //function to get all games
  static Future<List<Map<String, dynamic>>?> fetchGameDataList() async {
    const query = '''
      fields id, name, cover.url;
      where cover != null; 
      sort popularity desc;
      limit 10;
    ''';
    return fetchGames(query);
  }

  //function to get popular games
  static Future<List<Map<String, dynamic>>?> fetchPopularGames() async {
    const query = '''
      fields id, name, cover.url;
      where cover != null; 
      sort rating desc;
      limit 10;
    ''';
    return fetchGames(query);
  }

  //function to get games released this mont
  static Future<List<Map<String, dynamic>>?>
      fetchReleasedThisMonthGames() async {
    final query = '''
    fields id, name, cover.url;
    where cover != null & first_release_date > ${DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch ~/ 1000}; 
    sort first_release_date desc;
    limit 10;
  ''';
    return fetchGames(query);
  }

  //function to get the upcoming games
  static Future<List<Map<String, dynamic>>?> fetchUpcomingGames() async {
    final query = '''
    fields id, name, cover.url;
    where cover != null & first_release_date > ${DateTime.now().millisecondsSinceEpoch ~/ 1000}; 
    sort first_release_date asc;
    limit 10;
  ''';
    return fetchGames(query);
  }
}
