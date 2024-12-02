import 'package:flutter/material.dart';
import 'package:gamerverse/models/review.dart';
import 'package:gamerverse/services/specific_game/review_service.dart';
import 'package:gamerverse/widgets/common_sections/dialog_helper.dart';
import 'package:gamerverse/widgets/common_sections/report_user.dart';
import 'package:gamerverse/widgets/specific_game/like_dislike_button.dart';
import 'package:gamerverse/widgets/common_sections/report.dart';
import 'package:hugeicons/hugeicons.dart';

class SingleReview extends StatelessWidget {
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

  //function to show bottom pop up for report review
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

  //function to show bottom pop up for report user
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
        color: const Color(0xfff0f9f1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar, username, rating, and toggle
          Row(
            children: [
              // Avatar
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                backgroundImage: review?.writerPicture != ''
                    ? NetworkImage(review!.writerPicture)
                    : null,
                radius: 20,
                child: review?.writerPicture != ''
                    ? null
                    : Icon(Icons.person, color: Colors.grey[700], size: 30),
              ),
              const SizedBox(width: 15),

              // Username
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/userProfile');
                    },
                    child: Text(
                      review!.writerUsername,
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
                        review!.rating.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Text(
                review!.status,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),

              // Toggle menu
              if (userId != null && userId != review?.writerId)
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
              if (userId != null && userId == review?.writerId && review?.reviewId != null)
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  onPressed: () => _showDeleteConfirmation(
                      gameContext, review?.reviewId, review?.gameId),
                ),
              if (userId == null || review?.reviewId == null)
                SizedBox(
                  width: 20,
                )
            ],
          ),
          const SizedBox(height: 10),

          // Review
          Text(
            review!.description,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),

          // Like and Dislike buttons
          LikeDislikeWidget(
              timestamp: review!.timestamp,
              initialLikes: review!.likes,
              initialDislikes: review!.dislikes,
              reviewId: review?.reviewId ?? '',
              gameId: review!.gameId,
              userId: userId,
              writerId: review?.writerId),
        ],
      ),
    );
  }
}
