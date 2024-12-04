import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/profile_or_users/games/wishing_favorite_completed.dart';

class ProfileGames extends StatelessWidget {
  final String userId;

  const ProfileGames({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      body: GameListSection(userId: userId),
    );
  }
}
