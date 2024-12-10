import 'package:flutter/material.dart';
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
  final String username; // Nuovo parametro
  final String gameName; // Nuovo parametro
  final String gameCover; // Nuovo parametro

  const PostCard({
    super.key,
    required this.postId,
    required this.userId,
    required this.gameId,
    required this.content,
    required this.imageUrl,
    required this.timestamp,
    required this.likeCount,
    required this.commentCount,
    required this.onLikePressed,
    required this.currentUser,
    required this.username,
    required this.gameName,
    required this.gameCover,
  });

  @override
  PostCardState createState() => PostCardState();
}

class PostCardState extends State<PostCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
                          image: NetworkImage(widget.gameCover),
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
                              width: 250,
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                widget.gameName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (widget.userId == widget.currentUser) {
                                Navigator.pushNamed(context, '/profile',
                                    arguments: widget.userId);
                              } else {
                                Navigator.pushNamed(context, '/userProfile',
                                    arguments: widget.userId);
                              }
                            },
                            child: Container(
                              width: 250,
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Author: ${widget.username}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
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
                  maxLines: _isExpanded ? null : 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                if (widget.content.length > 74)
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
                          icon: Icon(Icons.thumb_up, color: Colors.grey[700]),
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
                          icon: Icon(
                            Icons.comment_outlined,
                            color: Colors.grey[700],
                            size: 26,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/comments',
                              arguments: {
                                'postId': widget.postId,
                                'currentUser': widget.currentUser
                              },
                            );
                          },
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
              if (widget.currentUser != widget.userId)
                ReportMenu(
                  userId: widget.currentUser,
                  reportedId: widget.postId,
                  parentContext: context,
                  writerId: widget.userId,
                  type: 'Post',
                ),
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
}
