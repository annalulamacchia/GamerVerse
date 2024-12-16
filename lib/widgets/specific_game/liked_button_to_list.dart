import 'package:flutter/material.dart';
import 'package:gamerverse/models/user.dart';

class LikedButtonToList extends StatelessWidget {
  final String gameId;
  final List<User>? users;
  final ValueNotifier<int> likedCountNotifier;
  final String? currentUser;
  final String gameName;

  const LikedButtonToList(
      {super.key,
      required this.gameId,
      required this.likedCountNotifier,
      required this.users,
      this.currentUser,
      required this.gameName});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: likedCountNotifier,
      builder: (context, likedCount, child) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/likedList', arguments: {
              'users': users,
              'currentUser': currentUser,
              'gameName': gameName
            });
          },
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite, color: Colors.white, size: 20),
                  SizedBox(width: 4),
                  //Number of users that liked the game
                  Text(
                    likedCount.toString(),
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
              Text(
                'Liked',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
