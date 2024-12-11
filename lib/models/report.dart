class AdditionalUserInfo {
  final String name;
  final int followers;
  final int followed;
  final int numberGames;

  AdditionalUserInfo({
    required this.name,
    required this.followers,
    required this.followed,
    required this.numberGames,
  });

  // Factory method per creare AdditionalInfo dal JSON
  factory AdditionalUserInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalUserInfo(
      name: json['name'],
      followers: json['followers'],
      followed: json['followed'],
      numberGames: json['number_games'],
    );
  }
}

class AdditionalPostInfo {
  final String description;
  final String writerId;
  final String gameId;
  final String gameName;
  final int numberLikes;
  final int numberComments;
  final String timestamp;
  final String father;

  AdditionalPostInfo(
      {required this.description,
      required this.writerId,
      required this.gameId,
      required this.gameName,
      required this.numberLikes,
      required this.numberComments,
      required this.timestamp,
      required this.father});

  // Factory method per creare AdditionalInfo dal JSON
  factory AdditionalPostInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalPostInfo(
        description: json['description'],
        writerId: json['writer_id'],
        gameId: json['game_id'],
        gameName: json['game_name'],
        numberLikes: json['likes'],
        numberComments: json['comments'],
        timestamp: json['timestamp'],
        father: json['father']);
  }
}

class AdditionalReviewInfo {
  final String gameName;
  final int numberLikes;
  final int numberDislikes;
  final int rating;
  final String timestamp;
  final String gameStatus;
  final String gameId;
  final String writerId;
  final String description;
  final String status;

  AdditionalReviewInfo(
      {required this.gameName,
      required this.numberLikes,
      required this.numberDislikes,
      required this.rating,
      required this.timestamp,
      required this.gameStatus,
      required this.gameId,
      required this.writerId,
      required this.description,
      required this.status});

  // Factory method per creare AdditionalReviewInfo dal JSON
  factory AdditionalReviewInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalReviewInfo(
        gameName: json['game_name'],
        numberLikes: json['likes'],
        numberDislikes: json['dislikes'],
        rating: json['rating'],
        timestamp: json['timestamp'],
        gameStatus: json['status'],
        gameId: json['game_id'],
        writerId: json['writer_id'],
        description: json['description'],
        status: json['status']);
  }
}

class Report {
  final String reportId;
  final String reporterId;
  final String reportedId;
  final String reason;
  final String type;
  final String username;
  final String profilePicture;
  final String? gameCover;
  final int counter;

  Report(
      {required this.reportId,
      required this.reporterId,
      required this.reportedId,
      required this.reason,
      required this.type,
      required this.username,
      required this.profilePicture,
      required this.gameCover,
      required this.counter});

  // Factory method per creare Report dal JSON
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
        reportId: json['report_id'],
        reporterId: json['reporter_id'],
        reportedId: json['reported_id'],
        reason: json['reason'],
        type: json['type'],
        username: json['username'],
        gameCover: json['game_cover'],
        profilePicture: json['profile_picture'],
        counter: json['counter']);
  }
}
