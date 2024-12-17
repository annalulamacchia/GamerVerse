import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_review.dart';
import 'package:gamerverse/services/specific_game/review_service.dart';
import 'package:gamerverse/utils/colors.dart';
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 6,
      color: AppColors.lightGreenishWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con immagine del gioco e overlay per il nome del gioco
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image.network(
                  widget.gameReview.cover,
                  width: double.infinity,
                  height: 125,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/game',
                        arguments: int.parse(widget.gameReview.gameId),
                      );
                    },
                    child: Text(
                      widget.gameReview.gameName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating e user info
                Row(
                  children: [
                    // Rating
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedPacman02,
                      color: Colors.black,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.gameReview.rating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Text(
                      widget.gameReview.status,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    // Toggle menu
                    if (widget.currentUser != widget.gameReview.writerId)
                      ReportMenu(
                        userId: widget.currentUser,
                        reportedId: widget.gameReview.reviewId,
                        parentContext: context,
                        writerId: widget.gameReview.writerId,
                        type: 'Review',
                      ),
                    // Remove review
                    if (widget.currentUser == widget.gameReview.writerId)
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.black54,
                        ),
                        onPressed: () => _showDeleteConfirmation(
                            widget.gameContext,
                            widget.gameReview.reviewId,
                            widget.gameReview.gameId),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // Review Description
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(
                    widget.gameReview.description,
                    maxLines:
                        _isExpanded ? widget.gameReview.description.length : 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
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

                const SizedBox(height: 10),

                // Like and Dislike buttons
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: LikeDislikeWidget(
                    reviewId: widget.gameReview.reviewId,
                    gameId: widget.gameReview.gameId,
                    timestamp: widget.gameReview.timestamp,
                    initialLikes: widget.gameReview.likes,
                    initialDislikes: widget.gameReview.dislikes,
                    userId: widget.currentUser,
                    writerId: widget.gameReview.writerId,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
