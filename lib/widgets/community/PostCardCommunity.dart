import 'package:flutter/material.dart';
import 'package:gamerverse/services/Get_user_info.dart';
import 'package:gamerverse/services/specific_game/get_game_service.dart';

class PostCard extends StatelessWidget {
  final String userId;
  final String gameId;
  final String content;
  final String imageUrl;
  final String timestamp;
  final int likeCount;
  final int commentCount;
  final VoidCallback onLikePressed;
  final VoidCallback onCommentPressed;
  final VoidCallback onReportUserPressed;
  final VoidCallback onReportPostPressed;

  const PostCard({
    super.key,
    required this.userId,
    required this.gameId,
    required this.content,
    required this.imageUrl,
    required this.timestamp,
    required this.likeCount,
    required this.commentCount,
    required this.onLikePressed,
    required this.onCommentPressed,
    required this.onReportUserPressed,
    required this.onReportPostPressed,
  });

  Future<Map> fetchPostDetails() async {
    Map<String, dynamic>? userData;
    Map<String, dynamic>? gameData;
    final responseUser = await UserProfileService.getUserByUid(); // Recupera informazioni utente
    final responseGame = await GameService.getGamebyId(gameId); // Recupera informazioni gioco

    if (responseUser['success']) {
        userData = responseUser['data'];
        // Popola i controller con i dati dell'utente
    }
    if (responseGame['success']) {
      gameData = responseGame['data'];
      // Popola i controller con i dati dell'utente
    }
    return {
      "author": userData?["username"] ?? "Unknown User",
      "gameName": gameData?["name"] ?? "Unknown Game",
      "cover": gameData?["cover"] ?? "",
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: fetchPostDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading post details"));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("No post details available"));
        } else {
          final author = snapshot.data!["author"];
          final gameName = snapshot.data!["gameName"];
          final cover = snapshot.data!["cover"];

          return Stack(
            children: [
              Card(
                color: const Color(0xfff0f9f1),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Riga superiore con cover, titolo e autore
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Cover del gioco
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: NetworkImage(cover),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Titolo del gioco e autore
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  gameName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Author: $author',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Descrizione
                      Text(
                        content,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Footer con timestamp, like e commenti
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            timestamp,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.thumb_up, color: Colors.grey[700]),
                                onPressed: onLikePressed,
                              ),
                              Text(
                                "$likeCount",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                icon: Icon(Icons.comment, color: Colors.grey[700]),
                                onPressed: onCommentPressed,
                              ),
                              Text(
                                "$commentCount",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.grey, size: 35),
                  onSelected: (value) {
                    if (value == 'reportUser') {
                      onReportUserPressed();
                    } else if (value == 'reportPost') {
                      onReportPostPressed();
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'reportUser',
                        child: Text("Report User"),
                      ),
                      const PopupMenuItem<String>(
                        value: 'reportPost',
                        child: Text("Report Post"),
                      ),
                    ];
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

}
