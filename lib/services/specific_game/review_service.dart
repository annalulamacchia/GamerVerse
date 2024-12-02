import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:gamerverse/models/review.dart';
import 'package:http/http.dart' as http;

class ReviewService {
  //function to add a review for a specific game
  static Future<bool> addReview(
      {required String? userId,
      required String reviewId,
      required String gameId,
      required String timestamp,
      required String? description,
      required int rating}) async {
    final url =
        Uri.parse('https://gamerversemobile.pythonanywhere.com/add_review');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'reviewId': reviewId,
        'writerId': userId,
        'gameId': gameId,
        'description': description,
        'rating': rating,
        'timestamp': timestamp
      }),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Review added successfully!');
      }
      return true;
    } else {
      if (kDebugMode) {
        print('Failed to add review');
      }
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getReview({
    required String? writerId,
    required String gameId,
  }) async {
    try {
      final url =
          Uri.parse('https://gamerversemobile.pythonanywhere.com/get_review');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'writerId': writerId,
          'gameId': gameId,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        if (kDebugMode) {
          print("Review not found");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in getting review: $e");
      }
      return null;
    }
  }

  // Funzione per calcolare la valutazione media degli utenti
  static Future<double?> getAverageUserRating({required int gameId}) async {
    final url = Uri.parse(
        'https://gamerversemobile.pythonanywhere.com/get_average_user_rating');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'gameId': gameId}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (kDebugMode) {
          print('Success to load average rating');
        }
        return responseData['average_user_rating'];
      } else {
        if (kDebugMode) {
          print('Failed to load average rating: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      return null;
    }
  }

  static Future<List<Review>> fetchReviewsByGame(
      {required String gameId}) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://gamerversemobile.pythonanywhere.com/get_reviews_by_game'),
        body: json.encode({'gameId': gameId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['reviews'] != null) {
          List<dynamic> reviewsList = responseData['reviews'];

          return reviewsList.map<Review>((dynamic reviewEntry) {
            final reviewMap = reviewEntry.values.first;
            return Review.fromJson(reviewMap);
          }).toList();
        } else {
          if (kDebugMode) {
            print('No reviews found');
          }
          return [];
        }
      } else {
        if (kDebugMode) {
          print('Failed to load reviews: ${response.statusCode}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during fetchReviewsByGame: $e');
      }
      return [];
    }
  }

  static Future<Review?> getLatestReview({required String gameId}) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://gamerversemobile.pythonanywhere.com/get_latest_review'),
        body: json.encode({'gameId': gameId}),
        headers: {'Content-Type': 'application/json'},
      );
      if (kDebugMode) {
        print(response.body);
      }

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['latest_review'] != null) {
          Map<String, dynamic> reviewsList = responseData['latest_review'];

          if (reviewsList.isNotEmpty) {
            return Review.fromJson(reviewsList.values.first);
          } else {
            if (kDebugMode) {
              print('No reviews found');
            }
            return null;
          }
        } else {
          if (kDebugMode) {
            print('No reviews found');
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          print('Failed to load latest review: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during fetchLatestReview: $e');
      }
      return null;
    }
  }

  static Future<List<Review>> fetchReviewsByStatus(
      {required String gameId}) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://gamerversemobile.pythonanywhere.com/get_reviews_status'),
        body: json.encode({'gameId': gameId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['reviews'] != null) {
          List<dynamic> reviewsList = responseData['reviews'];

          return reviewsList.map<Review>((dynamic reviewEntry) {
            final reviewMap = reviewEntry.values.first;
            return Review.fromJson(reviewMap);
          }).toList();
        } else {
          if (kDebugMode) {
            print('No reviews found');
          }
          return [];
        }
      } else {
        if (kDebugMode) {
          print('Failed to load reviews: ${response.statusCode}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during fetchReviewsByStatus: $e');
      }
      return [];
    }
  }

  static Future<void> updateLikeDislike(
      {required String? userId,
      required String gameId,
      required String reviewId,
      required String action}) async {
    final url = Uri.parse(
        'https://gamerversemobile.pythonanywhere.com/update_like_dislike');
    try {
      final response = await http.post(url,
          body: json.encode({
            'userId': userId,
            'gameId': gameId,
            'reviewId': reviewId,
            'action': action,
          }),
          headers: {'Content-Type': 'application/json'});
      if (kDebugMode) {
        print(response.body);
      }

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (kDebugMode) {
          print('Response: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to update like/dislike');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error updating like/dislike: $error');
      }
    }
  }
}
