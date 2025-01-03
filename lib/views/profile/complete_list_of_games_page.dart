import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_profile.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/profile_or_users/games/user_card_game.dart';

class AllGamesUserPage extends StatelessWidget {
  final List<GameProfile> games;
  final String? currentUser;
  final String userId;
  final ValueNotifier<List<dynamic>>? currentFollowedNotifier;

  const AllGamesUserPage(
      {super.key,
      required this.games,
      required this.currentUser,
      required this.userId,
      this.currentFollowedNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        title: const Text(
          'All Games',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.darkGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
              child: ImageCardProfileWidget(
                game: games[index],
                currentUser: currentUser ?? '',
                userId: userId,
                currentFollowedNotifier: currentFollowedNotifier,
              ),
            );
          },
        ),
      ),
    );
  }
}
