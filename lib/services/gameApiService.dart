import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';

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

  static Future<Map<String, dynamic>?> fetchCoverGame(int coverId) async {
    final url = Uri.parse('https://api.igdb.com/v4/covers');

    final String requestBody = '''
      fields *;
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
        print('Errore: ${response.statusCode}');
        print('Messaggio: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Errore durante la richiesta: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchCoverByGames(
      List<dynamic> gameIds) async {
    final url = Uri.parse('https://api.igdb.com/v4/covers');
    String gameIdsFormatted = '(${gameIds.join(',')})';

    final String requestBody = '''
      fields *;
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
        print('Errore: ${response.statusCode}');
        print('Messaggio: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Errore durante la richiesta: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchScreenshotsGame(
      int gameId) async {
    final url = Uri.parse('https://api.igdb.com/v4/screenshots');

    final String requestBody = '''
      fields *;
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
        print('Errore: ${response.statusCode}');
        print('Messaggio: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Errore durante la richiesta: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchVideosGame(int gameId) async {
    final url = Uri.parse('https://api.igdb.com/v4/game_videos');

    final String requestBody = '''
      fields *;
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
        print('Errore: ${response.statusCode}');
        print('Messaggio: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Errore durante la richiesta: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchArtworksGame(
      int gameId) async {
    final url = Uri.parse('https://api.igdb.com/v4/artworks');

    final String requestBody = '''
      fields *;
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
        print('Errore: ${response.statusCode}');
        print('Messaggio: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Errore durante la richiesta: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchCollections(
      List<dynamic> collectionIds) async {
    final url = Uri.parse('https://api.igdb.com/v4/collections');
    String collectionIdsFormatted = '(${collectionIds.join(',')})';

    final String requestBody = '''
      fields *;
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
        print('Errore: ${response.statusCode}');
        print('Messaggio: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Errore durante la richiesta: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchPlatforms(
      List<dynamic> platformsIds) async {
    final url = Uri.parse('https://api.igdb.com/v4/platforms');
    String platformsIdsFormatted = '(${platformsIds.join(',')})';

    final String requestBody = '''
      fields *;
      limit 500;
      where id = $platformsIdsFormatted; sort abbreviation asc;
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
        print('Errore: ${response.statusCode}');
        print('Messaggio: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Errore durante la richiesta: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchCompanies(
      List<dynamic> companiesIds) async {
    final url = Uri.parse('https://api.igdb.com/v4/involved_companies');
    String companiesIdsFormatted = '(${companiesIds.join(',')})';

    final String requestBody = '''
      fields *;
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
        print('Errore: ${response.statusCode}');
        print('Messaggio: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Errore durante la richiesta: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchDevelopersOrPublishers(
      List<dynamic> devOrPubIds) async {
    final url = Uri.parse('https://api.igdb.com/v4/companies');
    String devOrPubIdsFormatted = '(${devOrPubIds.join(',')})';

    final String requestBody = '''
      fields *;
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
        print('Errore: ${response.statusCode}');
        print('Messaggio: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Errore durante la richiesta: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchGenres(
      List<dynamic> genresIds) async {
    final url = Uri.parse('https://api.igdb.com/v4/genres');
    String genresIdsFormatted = '(${genresIds.join(',')})';

    final String requestBody = '''
      fields *;
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
        print('Errore: ${response.statusCode}');
        print('Messaggio: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Errore durante la richiesta: $e');
      return null;
    }
  }

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
              ? "https:${game['cover']['url']}".replaceAll('t_thumb', 't_cover_big')
              : null, // Transform thumbnail URLs if necessary
        }));
      } else {
        print('Error: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during API call: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchGameDataList() async {
    const query = '''
      fields id, name, cover.url;
      where cover != null; 
      sort popularity desc;
      limit 100;
    ''';
    return fetchGames(query);
  }

  static Future<List<Map<String, dynamic>>?> fetchPopularGames() async {
    const query = '''
      fields id, name, cover.url;
      where cover != null; 
      sort rating desc;
      limit 100;
    ''';
    return fetchGames(query);
  }

  static Future<List<Map<String, dynamic>>?> fetchReleasedThisMonthGames() async {
    // Remove the `const` from the query string so that DateTime.now() can be used.
    final query = '''
    fields id, name, cover.url;
    where cover != null & first_release_date > ${DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch ~/ 1000}; 
    sort first_release_date desc;
    limit 100;
  ''';
    return fetchGames(query);
  }

  static Future<List<Map<String, dynamic>>?> fetchUpcomingGames() async {
    // Remove the `const` from the query string so that DateTime.now() can be used.
    final query = '''
    fields id, name, cover.url;
    where cover != null & first_release_date > ${DateTime.now().millisecondsSinceEpoch ~/ 1000}; 
    sort first_release_date asc;
    limit 100;
  ''';
    return fetchGames(query);
  }

  static Future<List<Map<String, dynamic>>?> fetchGamesByName(String searchQuery) async {
    final query = '''
  fields id, name, cover.url;
  where name ~ *"$searchQuery"*;
  sort popularity desc;
  limit 30;
  ''';
    print("Generated Query: $query"); // Debugging log
    return fetchGames(query);
  }

}
