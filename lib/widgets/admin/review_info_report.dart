import 'package:flutter/material.dart';
import 'package:gamerverse/views/other_user_profile/user_profile_page.dart';
import 'package:gamerverse/views/specific_game/specific_game.dart';
import 'package:hugeicons/hugeicons.dart';

class ReviewInfoReport extends StatelessWidget {
  final String username;
  final double rating;
  final String comment;
  final String gameUrl;
  final int likes;
  final int dislikes;
  final int timestamp;

  const ReviewInfoReport(
      {super.key,
      required this.username,
      required this.rating,
      required this.comment,
      required this.gameUrl,
      required this.likes,
      required this.dislikes,
      required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff1c463f),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Game Image, username and rating
          Row(
            children: [
              //Game Image
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SpecificGame()),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    gameUrl,
                    width: 50,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Username
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserProfilePage(),
                        ),
                      );
                    },
                    child: Text(
                      username,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),

                  // Rating
                  Row(
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedPacman02,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        rating.toString(),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),

              //Status of the game
              const Text(
                'Playing', // Display timestamp
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Review
          Text(
            comment,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          const SizedBox(height: 15),

          // Like and Dislike
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Timestamp
              Text(
                '$timestamp hours ago', // Display timestamp
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
              const Spacer(),

              //Likes
              const Icon(Icons.thumb_up_outlined, color: Colors.white54),
              const SizedBox(width: 2.5),
              Text(likes.toString(),
                  style: const TextStyle(color: Colors.white54)),
              const SizedBox(width: 15),

              //Dislikes
              const Icon(Icons.thumb_down_outlined, color: Colors.white54),
              const SizedBox(width: 2.5),
              Text(dislikes.toString(),
                  style: const TextStyle(color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
