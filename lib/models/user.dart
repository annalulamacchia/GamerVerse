class User {
  final String userId;
  final String? profilePicture;
  final String username;

  User({
    required this.userId,
    required this.profilePicture,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['userId'],
        profilePicture: json['profile_picture'],
        username: json['username']);
  }
}
