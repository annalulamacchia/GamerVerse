import 'package:flutter/material.dart';

class LikeDislikeWidget extends StatefulWidget {
  final String timestamp;

  const LikeDislikeWidget({super.key, required this.timestamp});

  @override
  LikeDislikeWidgetState createState() => LikeDislikeWidgetState();
}

class LikeDislikeWidgetState extends State<LikeDislikeWidget> {
  bool isLiked = false;
  bool isDisliked = false;
  int likes = 0;
  int dislikes = 0;

  //function to alternate like and dislike
  void _toggleLike() {
    setState(() {
      if (!isLiked) {
        likes += 1;
        if (isDisliked) {
          dislikes -= 1;
          isDisliked = false;
        }
      } else {
        likes -= 1;
      }
      isLiked = !isLiked;
    });
  }

  //function to alternate dislike and like
  void _toggleDislike() {
    setState(() {
      if (!isDisliked) {
        dislikes += 1;
        if (isLiked) {
          likes -= 1;
          isLiked = false;
        }
      } else {
        dislikes -= 1;
      }
      isDisliked = !isDisliked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //Timestamp
        Text(
          '${widget.timestamp} hours ago', // Display timestamp
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const Spacer(),

        //Like Button
        const SizedBox(height: 10),
        IconButton(
          icon: Icon(
            isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
            color: isLiked ? Colors.black : Colors.black54,
          ),
          onPressed: _toggleLike,
        ),
        Text(likes.toString()),
        const SizedBox(width: 10),

        //Dislike Button
        IconButton(
          icon: Icon(
            isDisliked ? Icons.thumb_down : Icons.thumb_down_alt_outlined,
            color: isDisliked ? Colors.black : Colors.black54,
          ),
          onPressed: _toggleDislike,
        ),
        Text(dislikes.toString()),
      ],
    );
  }
}
