import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_profile.dart';

class ImageCardProfileWidget extends StatelessWidget {
  final GameProfile game;
  final String currentUser;
  final String userId;

  const ImageCardProfileWidget({
    super.key,
    required this.game,
    required this.currentUser,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/userGame', arguments: {
          'game': game,
          'currentUser': currentUser,
          'userId': userId
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 10,
        margin: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            game.cover,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
