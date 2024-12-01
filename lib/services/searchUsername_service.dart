import 'dart:convert';
import 'package:http/http.dart' as http;

class UserSearchService {
  static const String _url = 'https://gamerversemobile.pythonanywhere.com/search-username';

  static Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse("$_url?query=$query");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((user) => {
          "id": user["id"],
          "username": user["username"],
          "name": user["name"],
          "profile_picture": user["profile_picture"],
        }).toList();
      } else {
        throw Exception('Failed to load users: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error while searching for users: $e');
    }
  }
}
