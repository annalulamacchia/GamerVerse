class Comment {
  final String commentId;
  final String writerId;
  final String description;
  final String father;
  final String username;
  final String profilePicture;
  final String timestamp;

  // Costruttore
  Comment(
      {required this.commentId,
      required this.writerId,
      required this.description,
      required this.father,
      required this.username,
      required this.profilePicture,
      required this.timestamp});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id'] ?? '',
      writerId: json['writer_id'] ?? '',
      description: json['description'] ?? '',
      father: json['father'] ?? '0',
      username: json['username'] ?? 'Unknown',
      profilePicture: json['profile_picture'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}
