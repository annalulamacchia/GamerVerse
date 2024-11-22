import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String gameName;
  final String author;
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
    Key? key,
    required this.gameName,
    required this.author,
    required this.content,
    required this.imageUrl,
    required this.timestamp,
    required this.likeCount,
    required this.commentCount,
    required this.onLikePressed,
    required this.onCommentPressed,
    required this.onReportUserPressed,
    required this.onReportPostPressed,
  }) : super(key: key);

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Immagine del gioco a sinistra
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            gameName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Author: $author',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            content,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
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
}
