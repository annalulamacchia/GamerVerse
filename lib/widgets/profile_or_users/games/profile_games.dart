import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/profile_or_users/games/wishing_favorite_completed.dart';
import 'package:gamerverse/models/game_profile.dart';

class ProfileGames extends StatelessWidget {
  final String userId;
  final List<GameProfile> wishlist;
  const ProfileGames({super.key, required this.userId,required this.wishlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      body: GameListSection(userId: userId,wishlist: wishlist),
    );
  }
}
