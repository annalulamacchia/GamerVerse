import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:gamerverse/models/comment.dart';
import 'package:gamerverse/models/game_post.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostService {
  static const String _baseUrl =
      "https://gamerversemobile.pythonanywhere.com"; // Usa l'URL del tuo backend

  // Funzione per creare un post
  static Future<Map<String, dynamic>> sendPost(
      String description, String gameId) async {
    try {
      final url = Uri.parse(
          "$_baseUrl/create-post"); // La rotta per la creazione del post
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString(
          'user_uid'); // Ottieni l'ID utente salvato localmente (se disponibile)

      if (userId == null) {
        return {"success": false, "message": "User not authenticated"};
      }

      // Ottieni il timestamp corrente dal client
      String timestamp = DateTime.now()
          .toIso8601String(); // Ottenere data/ora corrente in formato ISO 8601

      // Costruisci il corpo della richiesta
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "writer_id": userId, // L'ID dell'utente
          "game_id": gameId, // L'ID del gioco
          "description": utf8.decode(description.codeUnits), // La descrizione del post
          "father": "0", // Se è un post principale
          "timestamp": timestamp, // Aggiungi il timestamp generato dal client
        }),
      );

      print(response.body);

      // Gestione della risposta del server
      if (response.statusCode == 200) {
        return {"success": true, "message": "Success to create post"}; // Risposta corretta
      } else {
        return {"success": false, "message": "Failed to create post"};
      }
    } catch (e) {
      // Gestione degli errori
      return {"success": false, "message": e.toString()};
    }
  }

  // Funzione per recuperare i post con ID facoltativo
  static Future<Map<String, dynamic>> GetPosts(bool isCommunity,
      [String? inputUserId]) async {
    try {
      final url =
          Uri.parse("$_baseUrl/get-posts"); // La rotta per ottenere i post
      final prefs = await SharedPreferences.getInstance();
      final String? loggedInUserId =
          prefs.getString('user_uid'); // Ottieni l'ID utente salvato localmente

      if (loggedInUserId == null && inputUserId == null) {
        return {"success": false, "message": "User not authenticated"};
      }

      // Determina quale ID utente utilizzare
      final userIdToUse = inputUserId ?? loggedInUserId;

      // Costruisci il corpo della richiesta
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "user_id": userIdToUse, // Usa l'ID specificato o quello loggato
          "isCommunity": isCommunity,
        }),
      );

      // Gestione della risposta del server
      if (response.statusCode == 200) {
        return json.decode(response.body); // Risposta corretta
      } else {
        return {"success": false, "message": "Failed to visualize post"};
      }
    } catch (e) {
      // Gestione degli errori
      return {"success": false, "message": e.toString()};
    }
  }

  static Future<bool> addComment(
      {required String postId,
      required String userId,
      required String comment}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/add_comment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'postId': postId,
          'userId': userId,
          'comment': utf8.decode(comment.codeUnits),
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (kDebugMode) {
          print('Comment added successfully');
        }
        return responseBody['success'] == true;
      } else {
        if (kDebugMode) {
          print('Failed to add comment: ${response.reasonPhrase}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return false;
    }
  }

  static Future<List<Comment>> getComments(String postId) async {
    final url = Uri.parse('$_baseUrl/get_comments');

    final Map<String, dynamic> requestBody = {
      'post_id': postId,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody['comments'] != null) {
          List<Comment> comments = [];
          for (var commentData in responseBody['comments']) {
            comments.add(Comment.fromJson(commentData));
          }

          if (kDebugMode) {
            print('Success in getting comments');
          }

          return comments;
        } else {
          if (kDebugMode) {
            print('No comments found');
          }
          return [];
        }
      } else {
        if (kDebugMode) {
          print('Failed to load comments');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching comments: $e');
      }
      return [];
    }
  }

  static Future<bool> removeComment({required String commentId}) async {
    final url = Uri.parse('$_baseUrl/delete_comment');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'commentId': commentId}),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Success in deleting the comment');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('Failed in deleting the comment');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
      return false;
    }
  }

  static Future<Map<String, dynamic>> toggleLike(
      String postId, String userId, bool isLiked) async {
    try {
      final url = Uri.parse("$_baseUrl/toggle-like");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "postId": postId,
          "userId": userId,
          "action": isLiked ? "unlike" : "like",
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Risposta corretta
      } else {
        return {"success": false, "message": "Failed to update like"};
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  static Future<bool> deletePost(String postId) async {
    final url = Uri.parse('$_baseUrl/delete_post');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'postId': postId}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          if (kDebugMode) {
            print('Post deleted successfully');
          }
          return true;
        } else {
          if (kDebugMode) {
            print('Failed to delete post: ${responseBody['message']}');
          }
          return false;
        }
      } else {
        if (kDebugMode) {
          print('Failed to delete post: ${response.reasonPhrase}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting post: $e');
      }
      return false;
    }
  }

  static Future<List<GamePost>> getPostsByGame(
      {required String userId, required String gameId}) async {
    final url = Uri.parse('$_baseUrl/get_posts_by_game');
    try {
      // Creazione della richiesta
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": userId,
          "gameId": gameId,
        }),
      );

      // Verifica dello stato della risposta
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['posts'] != null) {
          if (kDebugMode) {
            print('Success in loading post by game');
          }
          return (data['posts'] as List)
              .map((post) => GamePost.fromJson(post))
              .toList();
        } else {
          if (kDebugMode) {
            print('Failed loading posts by game');
          }
          return [];
        }
      } else {
        if (kDebugMode) {
          print('Failed to load posts: ${response.body}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching posts: $e');
      }
      return [];
    }
  }
}
