import 'package:flutter/material.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/profile_or_users/games/wishing_favorite_completed.dart';
import 'package:gamerverse/models/game_profile.dart';

class ProfileGames extends StatelessWidget {
  final String userId;
  final List<GameProfile> wishlist;
  final ValueNotifier<bool>? blockedNotifier;
  final String? currentUser;
  final ValueNotifier<bool>? gamesLoadingNotifier;
  final ValueNotifier<List<dynamic>>? currentFollowedNotifier;

  const ProfileGames(
      {super.key,
      required this.userId,
      required this.wishlist,
      this.blockedNotifier,
      required this.currentUser,
      this.gamesLoadingNotifier,
      this.currentFollowedNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      body: GameListSection(
        userId: userId,
        wishlist: wishlist,
        blockedNotifier: blockedNotifier,
        currentUser: currentUser,
        gamesLoadingNotifier: gamesLoadingNotifier,
        currentFollowedNotifier: currentFollowedNotifier,
      ),
    );
  }
}
