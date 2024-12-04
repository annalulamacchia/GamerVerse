import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_profile.dart';
import 'package:gamerverse/widgets/profile_or_users/posts/post_user_game.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:intl/intl.dart';

class SpecificUserGame extends StatelessWidget {
  final GameProfile game;

  const SpecificUserGame({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        backgroundColor: const Color(0xff163832),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(game.gameName, style: const TextStyle(color: Colors.white)),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/game',
                  arguments: int.parse(game.gameId));
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //More button on the AppBar
                  Text(
                    'More',
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Game Image
            Container(
              height: 200,
              color: Colors.grey[300],
              child: Image.network(
                game.cover,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),

            // Game Status and Timestamp
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (game.status != '')
                    Text(
                      '${game.status[0].toUpperCase() + game.status.substring(1).toLowerCase()} since: ${DateFormat('d MMMM yyyy').format(DateTime.parse(game.timestamp).toLocal())}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (game.status == '')
                    Text(
                      'Liked since: ${DateFormat('d MMMM yyyy').format(DateTime.parse(game.timestamp).toLocal())}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, thickness: 1),

            // More Details
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/game',
                    arguments: int.parse(game.gameId));
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'More Details on the Game',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Icon(Icons.keyboard_arrow_right,
                        color: Colors.white, size: 25),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            //Post section
            ...List.generate(5, (index) {
              return const UserPost(
                username: 'Username',
                commentText:
                    'Ciaooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo',
                likeCount: 11,
                commentCount: 12,
                avatarUrl:
                    'https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg',
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 2,
      ),
    );
  }
}
