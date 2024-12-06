import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_review.dart';
import 'package:gamerverse/services/specific_game/review_service.dart';
import 'package:gamerverse/widgets/common_sections/dialog_helper.dart';
import 'package:gamerverse/widgets/common_sections/report_menu.dart';
import 'package:gamerverse/widgets/specific_game/like_dislike_button.dart';
import 'package:hugeicons/hugeicons.dart';

class GameReviewCard extends StatefulWidget {
  final GameReview gameReview;
  final BuildContext gameContext;
  final VoidCallback onReviewRemoved;
  final String? currentUser;

  const GameReviewCard({
    super.key,
    required this.gameReview,
    required this.gameContext,
    required this.onReviewRemoved,
    required this.currentUser,
  });

  @override
  GameReviewCardState createState() => GameReviewCardState();
}

class GameReviewCardState extends State<GameReviewCard> {
  bool _isExpanded = false;

  //function to show the dialog to remove the review
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
          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 17.5),
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
                // Game Image, username and rating
                Row(
                  children: [
                    //Game Image
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/game',
                            arguments: int.parse(widget.gameReview.gameId));
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.gameReview.cover),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    //Game Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/game',
                                arguments: int.parse(widget.gameReview.gameId));
                          },
                          child: Container(
                            width: 175,
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              widget.gameReview.gameName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: null,
                              softWrap: true,
                            ),
                          ),
                        ),

                        //Rating
                        Row(
                          children: [
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedPacman02,
                              color: Colors.black,
                              size: 20.0,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.gameReview.rating.toString(),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                //Review
                Text(
                  widget.gameReview.description,
                  maxLines:
                      _isExpanded ? widget.gameReview.description.length : 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),

                // View More / View Less
                if (widget.gameReview.description.length > 100)
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
                  reviewId: widget.gameReview.reviewId,
                  gameId: widget.gameReview.gameId,
                  timestamp: widget.gameReview.timestamp,
                  initialLikes: widget.gameReview.likes,
                  initialDislikes: widget.gameReview.dislikes,
                  userId: widget.currentUser,
                  writerId: widget.gameReview.writerId,
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
              //Status
              Text(
                widget.gameReview.status,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              //Toggle menu
              if (widget.currentUser != widget.gameReview.writerId)
                ReportMenu(
                    userId: widget.currentUser,
                    reportedId: widget.gameReview.writerId,
                    parentContext: context,
                    type: 'Review'),

              //remove review
              if (widget.currentUser == widget.gameReview.writerId)
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedDelete02,
                    color: Colors.black,
                    size: 20.0,
                  ),
                  onPressed: () => _showDeleteConfirmation(widget.gameContext,
                      widget.gameReview.reviewId, widget.gameReview.gameId),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
