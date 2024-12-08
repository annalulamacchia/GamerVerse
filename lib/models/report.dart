class AdditionalUserInfo {
  final String username;
  final String name;
  final String profilePicture;
  final int followers;
  final int followed;
  final int numberGames;

  AdditionalUserInfo({
    required this.username,
    required this.name,
    required this.profilePicture,
    required this.followers,
    required this.followed,
    required this.numberGames,
  });

  // Factory method per creare AdditionalInfo dal JSON
  factory AdditionalUserInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalUserInfo(
      username: json['username'],
      name: json['name'],
      profilePicture: json['profile_picture'],
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
  final String username;
  final int numberLikes;
  final int numberComments;
  final String timestamp;
  final String profilePicture;
  final String gameCover;

  AdditionalPostInfo(
      {required this.description,
      required this.writerId,
      required this.gameId,
      required this.gameName,
      required this.username,
      required this.numberLikes,
      required this.numberComments,
      required this.timestamp,
      required this.profilePicture,
      required this.gameCover});

  // Factory method per creare AdditionalInfo dal JSON
  factory AdditionalPostInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalPostInfo(
      description: json['description'],
      writerId: json['writer_id'],
      gameId: json['game_id'],
      gameName: json['game_name'],
      username: json['username'],
      numberLikes: json['likes'],
      numberComments: json['comments'],
      timestamp: json['timestamp'],
      profilePicture: json['profile_picture'],
      gameCover: json['game_cover'],
    );
  }
}

class AdditionalReviewInfo {
  final String username;
  final String gameName;
  final int numberLikes;
  final int numberDislikes;
  final int rating;
  final String timestamp;
  final String gameStatus;
  final String profilePicture;
  final String gameCover;
  final String gameId;
  final String writerId;
  final String description;

  AdditionalReviewInfo(
      {required this.username,
      required this.gameName,
      required this.numberLikes,
      required this.numberDislikes,
      required this.rating,
      required this.timestamp,
      required this.gameStatus,
      required this.profilePicture,
      required this.gameCover,
      required this.gameId,
      required this.writerId,
      required this.description});

  // Factory method per creare AdditionalReviewInfo dal JSON
  factory AdditionalReviewInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalReviewInfo(
        username: json['username'],
        gameName: json['game_name'],
        numberLikes: json['likes'],
        numberDislikes: json['dislikes'],
        rating: json['rating'],
        timestamp: json['timestamp'],
        gameStatus: json['status'],
        profilePicture: json['profile_picture'],
        gameCover: json['game_cover'],
        gameId: json['game_id'],
        writerId: json['writer_id'],
        description: json['description']);
  }
}

class Report {
  final String reportId;
  final String reporterId;
  final String reportedId;
  final String reason;
  final String type;
  final AdditionalUserInfo? additionalUserInfo;
  final AdditionalPostInfo? additionalPostInfo;
  final AdditionalReviewInfo? additionalReviewInfo;

  Report(
      {required this.reportId,
      required this.reporterId,
      required this.reportedId,
      required this.reason,
      required this.type,
      this.additionalUserInfo,
      this.additionalPostInfo,
      this.additionalReviewInfo});

  // Factory method per creare Report dal JSON
  factory Report.fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'User') {
      return Report(
        reportId: json['report_id'],
        reporterId: json['reporter_id'],
        reportedId: json['reported_id'],
        reason: json['reason'],
        type: json['type'],
        additionalUserInfo:
            AdditionalUserInfo.fromJson(json['additional_info']),
      );
    } else if (json['type'] == 'Post') {
      return Report(
        reportId: json['report_id'],
        reporterId: json['reporter_id'],
        reportedId: json['reported_id'],
        reason: json['reason'],
        type: json['type'],
        additionalPostInfo:
            AdditionalPostInfo.fromJson(json['additional_info']),
      );
    } else {
      return Report(
        reportId: json['report_id'],
        reporterId: json['reporter_id'],
        reportedId: json['reported_id'],
        reason: json['reason'],
        type: json['type'],
        additionalReviewInfo:
            AdditionalReviewInfo.fromJson(json['additional_info']),
      );
    }
  }
}
