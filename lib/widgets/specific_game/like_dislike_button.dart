import 'package:flutter/material.dart';
import 'package:gamerverse/services/specific_game/review_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class LikeDislikeWidget extends StatefulWidget {
  final String reviewId;
  final String gameId;
  final String timestamp;
  final Map<String, dynamic> initialLikes;
  final Map<String, dynamic> initialDislikes;
  final String? userId;
  final String? writerId;

  const LikeDislikeWidget(
      {super.key,
      required this.reviewId,
      required this.gameId,
      required this.timestamp,
      required this.initialLikes,
      required this.initialDislikes,
      required this.userId,
      required this.writerId});

  @override
  LikeDislikeWidgetState createState() => LikeDislikeWidgetState();
}

class LikeDislikeWidgetState extends State<LikeDislikeWidget> {
  bool isLiked = false;
  bool isDisliked = false;
  int likes = 0;
  int dislikes = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    likes = widget.initialLikes.length;
    dislikes = widget.initialDislikes.length;
    if (widget.initialLikes.containsKey(widget.userId)) {
      isLiked = true;
    }
    if (widget.initialDislikes.containsKey(widget.userId)) {
      isDisliked = true;
    }
    isLoading = false;
  }

  void _toLoginForLikeDislike() {
    Navigator.pushNamed(context, '/login');
    isLoading = false;
  }

  // Funzione per alternare like
  void _toggleLike() {
    setState(() {
      if (!isLiked) {
        likes += 1;
        if (isDisliked) {
          dislikes -= 1;
          isDisliked = false;
        }
        ReviewService.updateLikeDislike(
            gameId: widget.gameId,
            reviewId: widget.reviewId,
            action: 'like',
            userId: widget.userId,
            writerId: widget.writerId);
      } else {
        likes -= 1;
        ReviewService.updateLikeDislike(
            gameId: widget.gameId,
            reviewId: widget.reviewId,
            action: 'remove_like',
            userId: widget.userId,
            writerId: widget.writerId);
      }
      isLiked = !isLiked;
    });
  }

  // Funzione per alternare dislike
  void _toggleDislike() {
    setState(() {
      if (!isDisliked) {
        dislikes += 1;
        if (isLiked) {
          likes -= 1;
          isLiked = false;
        }
        ReviewService.updateLikeDislike(
            gameId: widget.gameId,
            reviewId: widget.reviewId,
            action: 'dislike',
            userId: widget.userId,
            writerId: widget.writerId);
      } else {
        dislikes -= 1;
        ReviewService.updateLikeDislike(
            gameId: widget.gameId,
            reviewId: widget.reviewId,
            action: 'remove_dislike',
            userId: widget.userId,
            writerId: widget.writerId);
      }
      isDisliked = !isDisliked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Timestamp
        Text(
          widget.timestamp != ""
              ? timeago.format(DateTime.parse(widget.timestamp))
              : "",
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const Spacer(),

        // Like Button
        IconButton(
          icon: Icon(
            isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
            color: isLiked ? Colors.black : Colors.black54,
          ),
          onPressed:
              widget.userId != null ? _toggleLike : _toLoginForLikeDislike,
        ),
        Text(likes.toString()),
        const SizedBox(width: 10),

        // Dislike Button
        IconButton(
          icon: Icon(
            isDisliked ? Icons.thumb_down : Icons.thumb_down_alt_outlined,
            color: isDisliked ? Colors.black : Colors.black54,
          ),
          onPressed:
              widget.userId != null ? _toggleDislike : _toLoginForLikeDislike,
        ),
        Text(dislikes.toString()),
      ],
    );
  }
}
