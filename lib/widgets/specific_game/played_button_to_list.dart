import 'package:flutter/material.dart';
import 'package:gamerverse/models/userReview.dart';
import 'package:gamerverse/services/statusGameService.dart';
import 'package:hugeicons/hugeicons.dart';

class PlayedButtonToList extends StatefulWidget {
  final String gameId;
  final ValueNotifier<int> playedCountNotifier;

  const PlayedButtonToList(
      {super.key, required this.gameId, required this.playedCountNotifier});

  @override
  _PlayedButtonToListState createState() => _PlayedButtonToListState();
}

class _PlayedButtonToListState extends State<PlayedButtonToList> {
  List<UserReview>? users;
  bool isLoading = true;
  int oldCount = 0;

  @override
  void initState() {
    super.initState();
    widget.playedCountNotifier.addListener(_loadUsersByStatusGame);
    _loadUsersByStatusGame();
  }

  @override
  void dispose() {
    widget.playedCountNotifier.removeListener(_loadUsersByStatusGame);
    super.dispose();
  }

  //load all the users that have that game in the wishlist
  Future<void> _loadUsersByStatusGame() async {
    setState(() {
      isLoading = true;
      oldCount = widget.playedCountNotifier.value;
    });
    final us = await StatusGameService.getUsersByStatusGame(widget.gameId);
    setState(() {
      users = us;
      isLoading = false;
    });

    widget.playedCountNotifier.value = us!.length;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/playedList', arguments: users);
            },
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedGameController03,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    SizedBox(width: 4),
                    Text(
                      oldCount.toString(),
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
          ))
        : ValueListenableBuilder<int>(
            valueListenable: widget.playedCountNotifier,
            builder: (context, playedCount, child) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/playedList');
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedGameController03,
                          color: Colors.white,
                          size: 25.0,
                        ),
                        SizedBox(width: 4),
                        Text(
                          playedCount.toString(),
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                    Text(
                      'Played',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
