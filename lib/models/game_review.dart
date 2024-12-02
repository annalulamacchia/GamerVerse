class GameReview {
  final String reviewId;
  final String writerId;
  final String gameId;
  final String gameName;
  final String description;
  final int rating;
  final Map<String, bool> likes;
  final Map<String, bool> dislikes;
  final String timestamp;
  final String cover;
  final String status;

  GameReview(
      {required this.reviewId,
      required this.writerId,
      required this.gameId,
      required this.gameName,
      required this.description,
      required this.rating,
      required this.likes,
      required this.dislikes,
      required this.timestamp,
      required this.cover,
      required this.status});

  // Factory constructor per creare un oggetto GameReview da un JSON
  factory GameReview.fromJson(Map<String, dynamic> json) {
    return GameReview(
        reviewId: json['review_id'],
        writerId: json['writer_id'],
        gameId: json['game_id'],
        gameName: json['game_name'],
        description: json['description'],
        rating: json['rating'],
        likes: Map<String, bool>.from(json['likes'] ?? {}),
        dislikes: Map<String, bool>.from(json['dislikes'] ?? {}),
        timestamp: json['timestamp'],
        cover: json['cover'],
        status: json['status']);
  }
}
