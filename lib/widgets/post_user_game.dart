import 'package:flutter/material.dart';
import 'package:gamerverse/views/common_sections/comment_page.dart';
import 'package:gamerverse/widgets/report.dart';

class UserPost extends StatefulWidget {
  final String username;
  final String commentText;
  final int likeCount;
  final int commentCount;

  const UserPost({
    super.key,
    required this.username,
    required this.commentText,
    required this.likeCount,
    required this.commentCount,
  });

  @override
  UserPostState createState() => UserPostState();
}

class UserPostState extends State<UserPost> {
  bool isLiked = false;
  late int currentLikeCount;

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

  //function to show bottom pop up for report
  void _showReport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const ReportWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xfff0f9f1),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar, username, and timestamp
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 8),

                    // Username and timestamp
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
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

                    // Toggle for report
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Report') {
                          _showReport(context);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'Report',
                          child: Text('Report Post'),
                        ),
                        const PopupMenuItem(
                          value: 'Report',
                          child: Text('Report User'),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Post content (text)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    widget.commentText,
                    style: const TextStyle(color: Colors.black87),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentsPage(),
                          ),
                        );
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
      ],
    );
  }
}
