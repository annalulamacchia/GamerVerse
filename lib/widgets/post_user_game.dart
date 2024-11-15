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

  //function to like and unlike a post
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        color: const Color(0xfff0f9f1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //Avatar, username and toggle report
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [

                        //Avatar
                        CircleAvatar(
                          radius: 22.5,
                          backgroundColor: Colors.grey[300],
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 8),

                        //Username
                        Text(
                          widget.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  //Toggle report
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
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                  ),
                ],
              ),

              //Post
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  widget.commentText,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),

              const SizedBox(height: 8),

              //Likes and comment
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Likes
                      IconButton(
                        icon: Icon(
                          isLiked
                              ? Icons.thumb_up
                              : Icons.thumb_up_alt_outlined,
                          color: isLiked ? Colors.black : Colors.black54,
                        ),
                        onPressed: _toggleLike,
                      ),
                      Text(currentLikeCount.toString()),
                      const SizedBox(width: 16),

                      //Comments
                      IconButton(
                        icon: const Icon(Icons.comment_outlined),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentsPage(),
                            ),
                          );
                        },
                      ),
                      Text(widget.commentCount.toString()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
