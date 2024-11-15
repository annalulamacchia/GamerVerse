import 'package:flutter/material.dart';
import 'package:gamerverse/views/profile/profile_page.dart';
import 'package:gamerverse/widgets/specific_game/like_dislike_button.dart';
import 'package:gamerverse/widgets/report.dart';
import 'package:hugeicons/hugeicons.dart';

class SingleReview extends StatelessWidget {
  final String username;
  final double rating;
  final String comment;
  final String avatarUrl;
  final int likes;
  final int dislikes;

  const SingleReview({
    super.key,
    required this.username,
    required this.rating,
    required this.comment,
    required this.avatarUrl,
    required this.likes,
    required this.dislikes
  });

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
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
              // Avatar
              CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
                radius: 20,
              ),
              const SizedBox(width: 15),

              // Username
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    child: Text(
                      username,
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

              // Toggle menu
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Report') {
                    _showReport(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'Report',
                    child: Text('Report Review'),
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
          const SizedBox(height: 10),

          // Review
          Text(
            comment,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),

          // Like and Dislike buttons
          const LikeDislikeWidget(timestamp: '10'),
        ],
      ),
    );
  }
}
