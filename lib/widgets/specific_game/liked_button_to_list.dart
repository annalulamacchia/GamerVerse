import 'package:flutter/material.dart';
import 'package:gamerverse/models/user.dart';
import 'package:gamerverse/services/specific_game/whishlistService.dart';

class LikedButtonToList extends StatefulWidget {
  final String gameId;
  final ValueNotifier<int> likedCountNotifier;

  const LikedButtonToList(
      {super.key, required this.gameId, required this.likedCountNotifier});

  @override
  _LikedButtonToListState createState() => _LikedButtonToListState();
}

class _LikedButtonToListState extends State<LikedButtonToList> {
  List<User>? users;
  bool isLoading = true;
  int oldCount = 0;

  @override
  void initState() {
    super.initState();
    widget.likedCountNotifier.addListener(_loadUsersByGame);
    _loadUsersByGame();
  }

  @override
  void dispose() {
    widget.likedCountNotifier.removeListener(_loadUsersByGame);
    super.dispose();
  }

  //load all the users that have that game in the wishlist
  Future<void> _loadUsersByGame() async {
    setState(() {
      isLoading = true;
      oldCount = widget.likedCountNotifier.value;
    });
    final us = await WishlistService.getUsersByGame(widget.gameId);
    setState(() {
      users = us;
      isLoading = false;
    });

    widget.likedCountNotifier.value = us!.length;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/likedList', arguments: users);
            },
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite, color: Colors.white, size: 20),
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
            valueListenable: widget.likedCountNotifier,
            builder: (context, likedCount, child) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/likedList', arguments: users);
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite, color: Colors.white, size: 20),
                        SizedBox(width: 4),
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
