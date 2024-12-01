import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/common_sections/report_user.dart';
import 'package:gamerverse/widgets/specific_game/like_dislike_button.dart';
import 'package:gamerverse/widgets/common_sections/report.dart';
import 'package:hugeicons/hugeicons.dart';

class GameReviewCard extends StatelessWidget {
  final String gameName;
  final double rating;
  final String comment;
  final String gameUrl;
  final int likes;
  final int dislikes;

  const GameReviewCard(
      {super.key,
      required this.gameName,
      required this.rating,
      required this.comment,
      required this.gameUrl,
      required this.likes,
      required this.dislikes});

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
              Container(
                width: 40, // Width of the rectangle
                height: 40, // Height of the rectangle
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(gameUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
              const SizedBox(width: 15),

              // Username
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: Text(
                      gameName,
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
                        rating.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              const Text(
                'Playing', // Display timestamp
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              // Toggle menu
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
            ],
          ),
          const SizedBox(height: 10),

          // Review
          Text(
            comment,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),

          // Like and Dislike buttons
          const LikeDislikeWidget(timestamp: '10', likes: 0, dislikes: 0),
        ],
      ),
    );
  }
}
