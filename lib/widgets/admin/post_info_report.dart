import 'package:flutter/material.dart';

class PostInfoReport extends StatelessWidget {
  final String username;
  final String gameName;
  final String comment;
  final String gameUrl;
  final int likes;
  final int numberComments;
  final int timestamp;

  const PostInfoReport(
      {super.key,
      required this.username,
      required this.gameName,
      required this.comment,
      required this.gameUrl,
      required this.likes,
      required this.numberComments,
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
          //Game Image, game name and username
          Row(
            children: [
              //Game Image
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/game');
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

              //Game Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/game');
                    },
                    child: Text(
                      gameName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),

                  //Username
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/userProfile');
                    },
                    child: Row(
                      children: [
                        Text(
                          'Author: $username',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 15),

          //Post
          Text(
            comment,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          const SizedBox(height: 15),

          // Like and Comments
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

              //Comments
              const Icon(Icons.comment_outlined, color: Colors.white54),
              const SizedBox(width: 2.5),
              Text(numberComments.toString(),
                  style: const TextStyle(color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
