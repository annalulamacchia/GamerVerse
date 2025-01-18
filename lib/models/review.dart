class Review {
  final String? reviewId;
  final String? writerId;
  final double rating;
  final String description;
  final String timestamp;
  final String writerUsername;
  final String writerPicture;
  final String status;
  final Map<String, dynamic> likes;
  final Map<String, dynamic> dislikes;
  final String gameId;

  Review(
      {required this.reviewId,
      required this.writerId,
      required this.likes,
      required this.dislikes,
      required this.rating,
      required this.description,
      required this.timestamp,
      required this.writerUsername,
      required this.writerPicture,
      required this.status,
      required this.gameId});

  //create the Review model from a JSON result
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      gameId: json['game_id'],
      reviewId: json['review_id'],
      writerId: json['writer_id'],
      rating: json['rating']?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      timestamp: json['timestamp'] ?? '',
      writerUsername: json['writer_username'] ?? '',
      writerPicture: json['writer_picture'] ?? '',
      status: json['status'] ?? 'Not in wishlist',
      likes: json['likes'] ?? {},
      dislikes: json['dislikes'] ?? {},
    );
  }
}
