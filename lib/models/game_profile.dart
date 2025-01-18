class GameProfile {
  final String gameId;
  final String gameName;
  final int criticsRating;
  final String cover;
  final String status;
  final bool liked;
  final String timestamp;

  GameProfile(
      {required this.gameId,
      required this.gameName,
      required this.criticsRating,
      required this.cover,
      required this.status,
      required this.liked,
      required this.timestamp});

  //create the GameProfile model from a JSON result
  factory GameProfile.fromJson(Map<String, dynamic> json) {
    return GameProfile(
        gameId: json['gameId'],
        gameName: json['name'],
        criticsRating: json['criticsRating'],
        liked: json['liked'],
        timestamp: json['timestamp'],
        cover: json['cover'],
        status: json['status']);
  }
}
