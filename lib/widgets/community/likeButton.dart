import 'package:flutter/material.dart';
import 'package:gamerverse/services/Community/post_service.dart';

class LikeButton extends StatefulWidget {
  final String postId;
  final String currentUser;
  final int initialLikeCount;
  final List<dynamic> initialLikedUsers;

  const LikeButton({
    super.key,
    required this.postId,
    required this.currentUser,
    required this.initialLikeCount,
    required this.initialLikedUsers,
  });

  @override
  LikeButtonState createState() => LikeButtonState();
}

class LikeButtonState extends State<LikeButton> {
  late int likeCount;
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    likeCount = widget.initialLikeCount;
    isLiked = widget.initialLikedUsers.contains(widget.currentUser);
  }

  Future<void> _toggleLike() async {
    // Chiamata al servizio per cambiare lo stato del like
    if(widget.currentUser!='') {
      final result = await PostService.toggleLike(
          widget.postId, widget.currentUser, isLiked);

      if (result['success']) {
        setState(() {
          isLiked = !isLiked;
          likeCount += isLiked ? 1 : -1;
        });
      } else {
        // Gestire errori di rete
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update like: ${result['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
            color: isLiked ? Colors.black : Colors.grey,
          ),
          onPressed: _toggleLike,
        ),
        Text(
          '$likeCount',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
