class UserReview {
  final String userId;
  final String? profilePicture;
  final String username;

  UserReview({
    required this.userId,
    required this.profilePicture,
    required this.username,
  });

  factory UserReview.fromJson(Map<String, dynamic> json) {
    return UserReview(
        userId: json['userId'],
        profilePicture: json['profile_picture'],
        username: json['username']);
  }
}