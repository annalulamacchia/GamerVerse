import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:gamerverse/models/game_review.dart';
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

  //function to get the review of a user for a specific game
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

  //function to calculate the average user rating
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

  //function to get all the reviews of a specific game
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

  //function to get the latest review of a specific game
  static Future<Review?> getLatestReview({required String gameId}) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://gamerversemobile.pythonanywhere.com/get_latest_review'),
        body: json.encode({'gameId': gameId}),
        headers: {'Content-Type': 'application/json'},
      );

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

  //function to get all the reviews for a specific game without description
  static Future<List<Review>> fetchReviewsByStatus(
      {required String gameId}) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://gamerversemobile.pythonanywhere.com/get_reviews_status'),
        body: json.encode({'gameId': gameId}),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);

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

  //function to update like and dislike of a review
  static Future<void> updateLikeDislike(
      {required String? userId,
      required String gameId,
      required String reviewId,
      required String action,
      required String? writerId}) async {
    final url = Uri.parse(
        'https://gamerversemobile.pythonanywhere.com/update_like_dislike');
    try {
      final response = await http.post(url,
          body: json.encode({
            'userId': userId,
            'gameId': gameId,
            'reviewId': reviewId,
            'action': action,
            'writerId': writerId
          }),
          headers: {'Content-Type': 'application/json'});

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

  //function to remove a review
  static Future<bool> removeReview(
      {required String? reviewId, required String? gameId}) async {
    final url =
        Uri.parse('https://gamerversemobile.pythonanywhere.com/remove_review');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'reviewId': reviewId,
          'gameId': gameId,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        if (kDebugMode) {
          print('Failed to remove review: ${response.body}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error while removing review: $e');
      }
      return false;
    }
  }

  //function to get all the reviews of a user
  static Future<List<GameReview>> getReviewsByUserId(
      {required String userId}) async {
    final Uri url = Uri.parse(
        'https://gamerversemobile.pythonanywhere.com/get_reviews_by_user');

    final Map<String, dynamic> body = {
      'userId': userId,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['reviews'] != null) {
          List<dynamic> reviewsList = responseData['reviews'];

          return reviewsList.map<GameReview>((dynamic reviewEntry) {
            final reviewMap = reviewEntry.values.first;
            return GameReview.fromJson(reviewMap);
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
}
