import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_profile.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';
import 'package:hugeicons/hugeicons.dart';

class GameListSection extends StatefulWidget {
  final String userId;
  final List<GameProfile> wishlist;
  final ValueNotifier<bool>? blockedNotifier;

  const GameListSection({
    super.key,
    required this.userId,
    required this.wishlist,
    this.blockedNotifier,
  });

  @override
  GameListSectionState createState() => GameListSectionState();
}

class GameListSectionState extends State<GameListSection> {
  bool isLoading = false;
  List<GameProfile> liked = [];
  List<GameProfile> playing = [];
  List<GameProfile> completed = [];

  @override
  void initState() {
    super.initState();
  }

  // Load and filter wishlist into different categories
  @override
  Widget build(BuildContext context) {
    liked = widget.wishlist.where((game) => game.liked == true).toList();
    playing =
        widget.wishlist.where((game) => game.status == 'Playing').toList();
    completed =
        widget.wishlist.where((game) => game.status == 'Completed').toList();

    return widget.blockedNotifier != null
        ? ValueListenableBuilder<bool>(
            valueListenable: widget.blockedNotifier!,
            builder: (context, isBlocked, child) {
              // If the user is blocked, show NoDataList
              if (isBlocked) {
                return NoDataList(
                  textColor: Colors.white,
                  icon: HugeIcons.strokeRoundedAircraftGame,
                  message: 'The user is blocked!',
                  subMessage: 'Please unblock to view the game list.',
                  color: Colors.grey[500]!,
                );
              }

              // If not blocked, display the game list
              return isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.teal))
                  : ListView(
                      children: [
                        if (liked.isEmpty &&
                            playing.isEmpty &&
                            completed.isEmpty)
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
                        const SizedBox(height: 20),
                      ],
                    );
            },
          )
        : isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.teal))
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
                  const SizedBox(height: 20),
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_right, size: 40),
                onPressed: () {
                  Navigator.pushNamed(context, '/userAllGames', arguments: {
                    'games': games,
                    'currentUser': widget.userId,
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 175,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: games.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/userGame', arguments: {
                    'game': games[index],
                    'currentUser': widget.userId,
                  });
                },
                child: _buildGameCard(games[index].cover),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGameCard(String imageUrl) {
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
