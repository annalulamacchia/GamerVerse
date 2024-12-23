import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';

class GameApiService {
  static const String clientId = '59now2vf9ty36w63um7grxsio0jivn';
  static const String accessToken = 'of7hm9lpfashde892p0d7zurciwugx';

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
                  ? "https:${game['cover']['url']}"
                      .replaceAll('t_thumb', 't_cover_big')
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

  static Future<List<Map<String, dynamic>>?> fetchGameDataList(
      {int offset = 0}) async {
    final query = '''
    fields id, name, cover.url;
    where cover != null; 
    sort name asc;
    limit 100;
    offset $offset;
  ''';
    return fetchGames(query);
  }

  static Future<List<Map<String, dynamic>>?> fetchPopularGames(
      {int offset = 0}) async {
    final query = '''
    fields id, name, cover.url;
    where cover != null; 
    sort popularity desc;
    limit 100;
    offset $offset;
  ''';
    return fetchGames(query);
  }

  static Future<List<Map<String, dynamic>>?> fetchReleasedThisMonthGames(
      {int offset = 0}) async {
    final thirtyDaysAgo = DateTime.now()
            .subtract(const Duration(days: 30))
            .millisecondsSinceEpoch ~/
        1000;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final query = '''
    fields id, name, cover.url, first_release_date;
    where cover != null & first_release_date > $thirtyDaysAgo & first_release_date < $now; 
    sort first_release_date asc;
    limit 100;
    offset $offset;
  ''';
    return fetchGames(query); // Your existing method to make API calls
  }

  static Future<List<Map<String, dynamic>>?> fetchUpcomingGames(
      {int offset = 0}) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final query = '''
    fields id, name, cover.url, first_release_date;
    where cover != null & first_release_date > $now; 
    sort first_release_date asc;
    limit 100;
    offset $offset;
  ''';
    return fetchGames(query); // Your existing method to make API calls
  }

  static Future<List<Map<String, dynamic>>?> fetchGamesByName(
      String searchQuery) async {
    final query = '''
  fields id, name, cover.url;
  where name ~ *"$searchQuery"*;
  sort popularity desc;
  limit 30;
  ''';
    print("Generated Query: $query"); // Debugging log
    return fetchGames(query);
  }

  static Future<List<Map<String, dynamic>>> fetchFilteredGames({
    String? orderBy,
    String? platform,
    String? genre,
    int limit = 10,
    int offset = 0,
    String? page,
  }) async {
    const platformMap = {
      'PS4': '48',
      'Xbox One': '49',
      'PC': '6',
    };

    const genreMap = {
      'Action': '4',
      'Adventure': '5',
      'RPG': '12',
      'Shooter': '11',
    };

    final platformId = platform != null ? platformMap[platform] : null;
    final genreId = genre != null ? genreMap[genre] : null;

    // Handle sorting logic
    var sortClause = orderBy != null
        ? {
              'Alphabetical': 'sort name asc;',
              'Popularity':
                  'sort popularity desc;', // Fixed order for Popularity
              'Rating': 'sort rating desc;',
            }[orderBy] ??
            ''
        : '';

    if (sortClause == '' &&
        (page == 'UPCOMING' || page == 'RELEASED_THIS_MONTH')) {
      sortClause += 'sort first_release_date asc;';
    }

    // Build the where clause conditionally
    List<String> whereConditions = [];
    if (platformId != null) whereConditions.add('platforms = $platformId');
    if (genreId != null) whereConditions.add('genres = $genreId');

    // Add date filtering for specific pages
    if (page == 'RELEASED_THIS_MONTH') {
      final thirtyDaysAgo = DateTime.now()
              .subtract(const Duration(days: 30))
              .millisecondsSinceEpoch ~/
          1000;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      whereConditions.add('first_release_date > $thirtyDaysAgo');
      whereConditions.add('first_release_date < $now');
    } else if (page == 'UPCOMING') {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      whereConditions.add('first_release_date > $now');
    }

    final whereClause = whereConditions.isNotEmpty
        ? 'where ${whereConditions.join(' & ')};'
        : '';

    try {
      final String url = 'https://api.igdb.com/v4/games';
      final headers = {
        'Client-ID': clientId,
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      };

      // Prepare the request body
      final String body = '''
      fields id,name,cover.url,genres,platforms,rating;
      $whereClause
      $sortClause
      limit $limit;
      offset $offset;
    ''';

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.where((game) {
          return game['cover'] != null && game['cover']['url'] != null;
        }).map((game) {
          return {
            'id': game['id'],
            'name': game['name'],
            'coverUrl': game['cover']?['url'] != null
                ? "https:${game['cover']['url']}"
                    .replaceAll('t_thumb', 't_cover_big')
                : null,
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch games: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching games: $e');
    }
  }
}
