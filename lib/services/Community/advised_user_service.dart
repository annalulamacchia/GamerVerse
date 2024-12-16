import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class AdvisedUsersService {
  static const String _baseUrl =
      "https://gamerversemobile.pythonanywhere.com"; // URL del backend

  // Metodo per ottenere utenti consigliati in base alla posizione

  static Future<Position> getPosition() async {
    try {
      // Ottieni la posizione dell'utente con precisione alta
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      print("Error getting location: $e");
      throw Exception("Failed to get location");
    }
  }


  static Future<List<Map<String, dynamic>>> fetchUsersByLocation(
      double latitude, double longitude) async {
    try {
      final url = Uri.parse("$_baseUrl/get-advised-users-location");
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_uid'); // ID utente salvato localmente

      if (userId == null) {
        throw Exception("User not authenticated");
      }

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "user_id": userId,
          "latitude": latitude,
          "longitude": longitude,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['success'] == true && responseBody['users'] != null) {
          return List<Map<String, dynamic>>.from(responseBody['users']);
        } else {
          return [];
        }
      } else {
        throw Exception("Failed to fetch advised users by location");
      }
    } catch (e) {
      print('Error fetching users by location: $e');
      return [];
    }
  }

  // Metodo per ottenere utenti consigliati in base ai giochi
  static Future<List<Map<String, dynamic>>> fetchUsersByGames() async {
    try {
      final url = Uri.parse("$_baseUrl/get-advised-users-games");
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_uid'); // ID utente salvato localmente

      if (userId == null) {
        throw Exception("User not authenticated");
      }

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "user_id": userId, // ID dell'utente per calcolare i consigli
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['success'] == true && responseBody['users'] != null) {
          return List<Map<String, dynamic>>.from(responseBody['users']);
        } else {
          return [];
        }
      } else {
        throw Exception("Failed to fetch advised users by games");
      }
    } catch (e) {
      print('Error fetching users by games: $e');
      return [];
    }
  }
}
