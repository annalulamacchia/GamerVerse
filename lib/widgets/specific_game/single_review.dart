import 'package:flutter/material.dart';
import 'package:gamerverse/models/review.dart';
import 'package:gamerverse/services/specific_game/review_service.dart';
import 'package:gamerverse/widgets/common_sections/dialog_helper.dart';
import 'package:gamerverse/widgets/common_sections/report_menu.dart';
import 'package:gamerverse/widgets/specific_game/like_dislike_button.dart';
import 'package:hugeicons/hugeicons.dart';

class SingleReview extends StatefulWidget {
  final Review? review;
  final String? userId;
  final BuildContext gameContext;
  final VoidCallback onReviewRemoved;

  const SingleReview({
    super.key,
    required this.review,
    required this.userId,
    required this.gameContext,
    required this.onReviewRemoved,
  });

  @override
  SingleReviewState createState() => SingleReviewState();
}

class SingleReviewState extends State<SingleReview> {
  bool _isExpanded = false;

  //function to show the modal to remove the review
  void _showDeleteConfirmation(
      BuildContext context, String? reviewId, String? writerId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Review'),
          content: const Text(
              'Are you sure you want to delete this review? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (reviewId != null) {
                  _removeReview(reviewId, writerId, widget.gameContext);
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  //function to remove the review
  void _removeReview(
      String reviewId, String? gameId, BuildContext context) async {
    print(gameId);
    final success =
        await ReviewService.removeReview(reviewId: reviewId, gameId: gameId);

    if (success) {
      DialogHelper.showSuccessDialog(context, 'Review removed succesfully!');
      widget.onReviewRemoved();
    } else {
      DialogHelper.showErrorDialog(
          context, 'Error in removing the review. Please try again.');
    }
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
                // Avatar, username, rating
                Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      backgroundImage: widget.review?.writerPicture != ''
                          ? NetworkImage(widget.review!.writerPicture)
                          : null,
                      radius: 20,
                      child: widget.review?.writerPicture != ''
                          ? null
                          : Icon(Icons.person,
                              color: Colors.grey[700], size: 30),
                    ),
                    const SizedBox(width: 15),

                    // Username
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (widget.userId == null ||
                                widget.review?.writerId != widget.userId) {
                              Navigator.pushNamed(
                                context,
                                '/userProfile',
                                arguments: widget.review?.writerId,
                              );
                            } else if (widget.userId != null &&
                                widget.review?.writerId == widget.userId) {
                              Navigator.pushNamed(
                                context,
                                '/profile',
                                arguments: widget.review?.writerId,
                              );
                            }
                          },
                          child: Container(
                            width: 200,
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              widget.review!.writerUsername,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: null,
                              softWrap: true,
                            ),
                          ),
                        ),

                        // Rating
                        Row(
                          children: [
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedPacman02,
                              color: Colors.black,
                              size: 20.0,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.review!.rating.toString(),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Review
                Text(
                  widget.review!.description,
                  maxLines: _isExpanded ? widget.review!.description.length : 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),

                // View More / View Less
                if (widget.review!.description.toUpperCase().length > 74)
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

                // Like and Dislike buttons
                LikeDislikeWidget(
                    timestamp: widget.review!.timestamp,
                    initialLikes: widget.review!.likes,
                    initialDislikes: widget.review!.dislikes,
                    reviewId: widget.review?.reviewId ?? '',
                    gameId: widget.review!.gameId,
                    userId: widget.userId,
                    writerId: widget.review?.writerId),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 15,
          child: Row(
            children: [
              //Status
              Text(
                widget.review!.status,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              // Toggle menu
              if (widget.userId != null &&
                  widget.userId != widget.review?.writerId &&
                  widget.review?.reviewId != null)
                ReportMenu(
                    userId: widget.userId,
                    writerId: widget.review?.writerId,
                    reportedId: widget.review?.reviewId,
                    parentContext: widget.gameContext,
                    type: 'Review'),
              //remove review
              if (widget.userId != null &&
                  widget.userId == widget.review?.writerId &&
                  widget.review?.reviewId != null)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.black54,
                  ),
                  onPressed: () => _showDeleteConfirmation(widget.gameContext,
                      widget.review?.reviewId, widget.review?.gameId),
                ),
              if ((widget.userId != null && widget.review?.reviewId == null) ||
                  widget.userId == null)
                Icon(Icons.more_vert, color: Colors.transparent, size: 35)
            ],
          ),
        ),
      ],
    );
  }
}
