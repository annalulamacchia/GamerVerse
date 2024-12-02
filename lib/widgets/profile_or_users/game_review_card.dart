import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_review.dart';
import 'package:gamerverse/services/specific_game/review_service.dart';
import 'package:gamerverse/widgets/common_sections/dialog_helper.dart';
import 'package:gamerverse/widgets/common_sections/report_user.dart';
import 'package:gamerverse/widgets/specific_game/like_dislike_button.dart';
import 'package:gamerverse/widgets/common_sections/report.dart';
import 'package:hugeicons/hugeicons.dart';

class GameReviewCard extends StatelessWidget {
  final GameReview gameReview;
  final String userId;
  final BuildContext gameContext;
  final VoidCallback onReviewRemoved;

  const GameReviewCard({
    super.key,
    required this.gameReview,
    required this.userId,
    required this.gameContext,
    required this.onReviewRemoved,
  });

  // Function to show bottom pop up for report review
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

  // Function to show bottom pop up for report user
  void _showReportUser(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const ReportUserWidget();
      },
    );
  }

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
                  _removeReview(reviewId, writerId, gameContext);
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

  void _removeReview(
      String reviewId, String? gameId, BuildContext context) async {
    print(gameId);
    final success =
        await ReviewService.removeReview(reviewId: reviewId, gameId: gameId);

    if (success) {
      DialogHelper.showSuccessDialog(context, 'Review removed succesfully!');
      onReviewRemoved();
    } else {
      DialogHelper.showErrorDialog(
          context, 'Error in removing the review. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar, username, rating, and toggle
          Row(
            children: [
              // Rectangle Avatar (Replacing CircleAvatar)
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/game',
                      arguments: int.parse(gameReview.gameId));
                },
                child: Container(
                  width: 65, // Width of the rectangle
                  height: 65, // Height of the rectangle
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(gameReview.cover),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8), // Rounded corners
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
                          arguments: int.parse(gameReview.gameId));
                    },
                    child: Text(
                      gameReview.gameName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
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
                        gameReview.rating.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Text(
                gameReview.status, // Display timestamp
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              // Toggle menu
              if (userId != gameReview.writerId)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Report_Review') {
                      _showReport(context);
                    } else if (value == 'Report_User') {
                      _showReportUser(context);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'Report_Review',
                      child: Text('Report Review'),
                    ),
                    const PopupMenuItem(
                      value: 'Report_User',
                      child: Text('Report User'),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                ),
              //remove review
              if (userId == gameReview.writerId)
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  onPressed: () => _showDeleteConfirmation(
                      gameContext, gameReview.reviewId, gameReview.gameId),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Review
          Text(
            gameReview.description,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),

          // Like and Dislike buttons
          LikeDislikeWidget(
            reviewId: gameReview.reviewId,
            gameId: gameReview.gameId,
            timestamp: gameReview.timestamp,
            initialLikes: gameReview.likes,
            initialDislikes: gameReview.dislikes,
            userId: userId,
            writerId: gameReview.writerId,
          ),
        ],
      ),
    );
  }
}
