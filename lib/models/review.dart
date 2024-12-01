import 'package:timeago/timeago.dart' as timeago;

class Review {
  final double rating;
  final String description;
  final String timestamp;
  final String writerUsername;
  final String writerPicture;
  final String status;
  final int likes;
  final int dislikes;

  Review(
      {required this.likes,
      required this.dislikes,
      required this.rating,
      required this.description,
      required this.timestamp,
      required this.writerUsername,
      required this.writerPicture,
      required this.status});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating']?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      timestamp: timeago.format(DateTime.parse(json['timestamp'])),
      writerUsername: json['writer_username'] ?? '',
      writerPicture: json['writer_picture'] ?? '',
      status: json['status'] ?? 'Not in wishlist',
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
    );
  }
}
