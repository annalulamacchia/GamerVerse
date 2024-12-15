class GamePost {
  final String postId;
  final String description;
  final List<String> likes;
  final String username;
  final String profilePicture;
  final int commentsCount;
  final String timestamp;
  final String writerId;

  GamePost(
      {required this.postId,
      required this.description,
      required this.likes,
      required this.username,
      required this.profilePicture,
      required this.commentsCount,
      required this.timestamp,
      required this.writerId});

  factory GamePost.fromJson(Map<String, dynamic> json) {
    return GamePost(
        postId: json['post_id'],
        description: json['description'] ?? '',
        likes: List<String>.from(json['likes'] ?? {}),
        username: json['username'] ?? 'Unknown User',
        profilePicture: json['profile_picture'] ?? '',
        commentsCount: json['comments_count'] ?? 0,
        timestamp: json['timestamp'] ?? '',
        writerId: json['writer_id'] ?? '');
  }
}
