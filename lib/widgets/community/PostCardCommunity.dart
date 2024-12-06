import 'package:flutter/material.dart';
import 'package:gamerverse/services/user/Get_user_info.dart';
import 'package:gamerverse/services/specific_game/get_game_service.dart';
import 'package:gamerverse/widgets/common_sections/report_menu.dart';
import 'package:hugeicons/hugeicons.dart';

class PostCard extends StatefulWidget {
  final String postId;
  final String userId;
  final String gameId;
  final String content;
  final String imageUrl;
  final String timestamp;
  final int likeCount;
  final int commentCount;
  final VoidCallback onLikePressed;
  final String? currentUser;

  const PostCard(
      {super.key,
      required this.userId,
      required this.gameId,
      required this.content,
      required this.imageUrl,
      required this.timestamp,
      required this.likeCount,
      required this.commentCount,
      required this.onLikePressed,
      required this.postId,
      required this.currentUser});

  @override
  PostCardState createState() => PostCardState();
}

class PostCardState extends State<PostCard> {
  bool _isExpanded = false;

  Future<Map> fetchPostDetails() async {
    Map<String, dynamic>? userData;
    Map<String, dynamic>? gameData;
    final responseUser =
        await UserProfileService.getUserByUid(); // Recupera informazioni utente
    final responseGame = await GameService.getGamebyId(
        widget.gameId); // Recupera informazioni gioco

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
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
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
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/game',
                                        arguments: int.parse(widget.gameId));
                                  },
                                  child: Container(
                                    width: 240,
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      gameName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: null,
                                      softWrap: true,
                                    ),
                                  ),
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
                        widget.content,
                        maxLines: _isExpanded ? widget.content.length : 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),

                      // View More / View Less
                      if (widget.content.toUpperCase().length > 74)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Text(
                            _isExpanded ? 'View Less' : 'View More',
                            style: const TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 15),
                      // Footer con timestamp, like e commenti
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.timestamp,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.thumb_up,
                                    color: Colors.grey[700]),
                                onPressed: widget.onLikePressed,
                              ),
                              Text(
                                "${widget.likeCount}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                icon: Icon(Icons.comment,
                                    color: Colors.grey[700]),
                                onPressed: null,
                              ),
                              Text(
                                "${widget.commentCount}",
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
                child: Row(
                  children: [
                    //Toggle menu
                    if (widget.currentUser != widget.userId)
                      ReportMenu(
                          userId: widget.currentUser,
                          reportedId: widget.postId,
                          parentContext: context,
                          type: 'Post'),

                    //remove review
                    if (widget.currentUser == widget.userId)
                      IconButton(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedDelete02,
                          color: Colors.black,
                          size: 20.0,
                        ),
                        onPressed: () => {},
                      ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
