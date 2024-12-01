import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostService {
  static const String _baseUrl = "https://gamerversemobile.pythonanywhere.com"; // Usa l'URL del tuo backend

  // Funzione per creare un post
  static Future<Map<String, dynamic>> sendPost(String description, String gameId) async {
    try {
      final url = Uri.parse("$_baseUrl/create-post"); // La rotta per la creazione del post
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_uid'); // Ottieni l'ID utente salvato localmente (se disponibile)

      if (userId == null) {
        return {"success": false, "message": "User not authenticated"};
      }

      // Ottieni il timestamp corrente dal client
      String timestamp = DateTime.now().toIso8601String(); // Ottenere data/ora corrente in formato ISO 8601

      // Costruisci il corpo della richiesta
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "writer_id": userId, // L'ID dell'utente
          "game_id": gameId, // L'ID del gioco
          "description": description, // La descrizione del post
          "father": "0", // Se è un post principale
          "timestamp": timestamp, // Aggiungi il timestamp generato dal client
        }),
      );

      print(response.body);

      // Gestione della risposta del server
      if (response.statusCode == 200) {
        return json.decode(response.body); // Risposta corretta
      } else {
        return {"success": false, "message": "Failed to create post"};
      }
    } catch (e) {
      // Gestione degli errori
      return {"success": false, "message": e.toString()};
    }
  }
  static Future<Map<String, dynamic>> GetPosts() async {
    try {
      final url = Uri.parse("$_baseUrl/get-posts"); // La rotta per la creazione del post
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_uid'); // Ottieni l'ID utente salvato localmente (se disponibile)

      if (userId == null) {
        return {"success": false, "message": "User not authenticated"};
      }

      // Costruisci il corpo della richiesta
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "user_id": userId, // L'ID dell'utente
        }),
      );

      print(response.body);

      // Gestione della risposta del server
      if (response.statusCode == 200) {
        return json.decode(response.body); // Risposta corretta
      } else {
        return {"success": false, "message": "Failed to create post"};
      }
    } catch (e) {
      // Gestione degli errori
      return {"success": false, "message": e.toString()};
    }
  }
}



