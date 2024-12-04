import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_profile.dart';
import 'package:gamerverse/widgets/profile_or_users/games/user_card_game.dart';

class AllGamesUserPage extends StatelessWidget {
  final List<GameProfile> games;

  const AllGamesUserPage({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        title: const Text(
          'All Games',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff163832),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 0.8,
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            return Container(
              width: 180,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: ImageCardProfileWidget(game: games[index]),
            );
          },
        ),
      ),
    );
  }
}
