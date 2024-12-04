import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_profile.dart';
import 'package:gamerverse/services/specific_game/wishlist_service.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';
import 'package:hugeicons/hugeicons.dart';

class GameListSection extends StatefulWidget {
  final String userId;

  const GameListSection({super.key, required this.userId});

  @override
  GameListSectionState createState() => GameListSectionState();
}

class GameListSectionState extends State<GameListSection> {
  List<GameProfile> wishlist = [];
  bool isLoading = true;
  List<GameProfile> liked = [];
  List<GameProfile> playing = [];
  List<GameProfile> completed = [];

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  //load if the game is in the wishlist of the current user
  Future<void> _loadWishlist() async {
    final games = await WishlistService.getWishlist(widget.userId);
    setState(() {
      wishlist = games;
      isLoading = false;
    });

    liked = wishlist.where((game) => game.liked == true).toList();
    playing = wishlist.where((game) => game.status == 'Playing').toList();
    completed = wishlist.where((game) => game.status == 'Completed').toList();

    final uniqueGameIds = HashSet<String>();

    for (var game in games) {
      uniqueGameIds.add(game.gameId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            children: [
              if (liked.isEmpty && playing.isEmpty && completed.isEmpty)
                NoDataList(
                  textColor: Colors.white,
                  icon: HugeIcons.strokeRoundedAircraftGame,
                  message: 'No games added yet',
                  subMessage:
                      'Start adding games to your list to keep track of your progress.',
                  color: Colors.grey[500]!,
                ),
              if (liked.isNotEmpty)
                _buildGameSection(context, 'Wishlist', liked),
              if (playing.isNotEmpty)
                _buildGameSection(context, 'Playing', playing),
              if (completed.isNotEmpty)
                _buildGameSection(context, 'Completed', completed),
              const SizedBox(
                height: 20,
              ),
            ],
          );
  }

  Widget _buildGameSection(
      BuildContext context, String title, List<GameProfile> games) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Name of the section
              Text(
                title,
                style: const TextStyle(
                    fontSize: 22.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_right, size: 40),
                onPressed: () {
                  Navigator.pushNamed(context, '/userAllGames',
                      arguments: games);
                },
              ),
            ],
          ),
        ),
        //Games
        SizedBox(
          height: 175,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: games.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/userGame',
                      arguments: games[index]);
                },
                child: buildGameCard(games[index].cover),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildGameCard(String imageUrl) {
    return Card(
      margin: const EdgeInsets.only(left: 15.0, right: 5),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 140,
          height: 175,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image);
            },
          ),
        ),
      ),
    );
  }
}
