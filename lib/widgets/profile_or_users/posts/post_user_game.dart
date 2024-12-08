import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/common_sections/report_menu.dart';
import 'package:hugeicons/hugeicons.dart';

class UserPost extends StatefulWidget {
  final String username;
  final String commentText;
  final int likeCount;
  final int commentCount;
  final String avatarUrl;
  final String writerId;
  final String currentUser;
  final String postId;

  const UserPost({
    super.key,
    required this.username,
    required this.commentText,
    required this.likeCount,
    required this.commentCount,
    required this.avatarUrl,
    required this.writerId,
    required this.currentUser,
    required this.postId,
  });

  @override
  UserPostState createState() => UserPostState();
}

class UserPostState extends State<UserPost> {
  bool isLiked = false;
  late int currentLikeCount;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    currentLikeCount = widget.likeCount;
  }

  //function to handle liked and not liked
  void _toggleLike() {
    setState(() {
      if (isLiked) {
        currentLikeCount--;
      } else {
        currentLikeCount++;
      }
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          color: const Color(0xfff0f9f1),
          margin: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar, username, and timestamp
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.avatarUrl),
                      radius: 20,
                    ),
                    const SizedBox(width: 8),

                    // Username and timestamp
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigate to a new page when the text is tapped
                              Navigator.pushNamed(context, '/userProfile');
                            },
                            child: Container(
                              width: 250,
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                widget.username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                maxLines: null,
                                softWrap: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '2 hours ago',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                //Post
                Text(
                  widget.commentText,
                  maxLines: _isExpanded ? widget.commentText.length : 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),

                // View More / View Less
                if (widget.commentText.toUpperCase().length > 74)
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
                const SizedBox(height: 12),

                // Likes and Comments
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Comments
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/comments');
                      },
                      icon: const Icon(
                        Icons.comment_outlined,
                        size: 18,
                        color: Colors.black54,
                      ),
                      label: Text(
                        widget.commentCount.toString(),
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),

                    // Likes
                    TextButton.icon(
                      onPressed: _toggleLike,
                      icon: Icon(
                        isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                        size: 18,
                        color: isLiked ? Colors.black : Colors.black54,
                      ),
                      label: Text(
                        currentLikeCount.toString(),
                        style: TextStyle(
                          color: isLiked ? Colors.black : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 15,
          child: Row(
            children: [
              // Toggle menu
              if (widget.currentUser != widget.writerId)
                ReportMenu(
                    userId: widget.currentUser,
                    reportedId: widget.writerId,
                    parentContext: context,
                    writerId: widget.writerId,
                    type: 'Post'),
              //remove review
              if (widget.currentUser == widget.writerId)
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedDelete02,
                    color: Colors.black54,
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
