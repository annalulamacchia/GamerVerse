class User {
  final String userId;
  final String? profilePicture;
  final String username;

  User({
    required this.userId,
    required this.profilePicture,
    required this.username,
  });

  //create the User model from a JSON result
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['userId'],
        profilePicture: json['profile_picture'],
        username: json['username']);
  }
}
