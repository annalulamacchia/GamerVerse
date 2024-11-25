import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final String gameName;
  final String gameImageUrl;
  final String description;
  final int likeCount;
  final int commentCount;
  final VoidCallback onCommentPressed;
  final VoidCallback onDeletePressed;

  const PostCard({
    super.key,
    required this.gameName,
    required this.gameImageUrl,
    required this.description,
    required this.likeCount,
    required this.commentCount,
    required this.onCommentPressed,
    required this.onDeletePressed,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.likeCount;
  }

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
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Immagine del gioco a sinistra
                    Image.network(
                      widget.gameImageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image,
                            color: Colors.grey[400], size: 90);
                      },
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.gameName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.description,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up, color: Colors.grey[700]),
                      onPressed: () {
                        setState(() {
                          _likeCount++;
                        });
                      },
                    ),
                    Text("$_likeCount",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: Icon(Icons.comment, color: Colors.grey[700]),
                      onPressed: widget.onCommentPressed,
                    ),
                    Text("${widget.commentCount}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.red, size: 35),
            onPressed: widget.onDeletePressed,
          ),
        ),
      ],
    );
  }
}
