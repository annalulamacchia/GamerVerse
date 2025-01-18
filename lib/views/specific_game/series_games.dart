import 'package:flutter/material.dart';
import 'package:gamerverse/services/game_api_service.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/common_sections/card_game.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';

class SeriesGame extends StatefulWidget {
  final List<dynamic> gameIds;
  final String title;

  const SeriesGame({super.key, required this.gameIds, required this.title});

  @override
  SeriesGameState createState() => SeriesGameState();
}

class SeriesGameState extends State<SeriesGame> {
  bool isLoading = true;
  List<Map<String, dynamic>>? coverGames;

  @override
  void initState() {
    super.initState();
    _loadCovers(widget.gameIds);
  }

  //load the cover of some games
  Future<void> _loadCovers(List<dynamic> games) async {
    if (games.isEmpty) {
      setState(() {
        coverGames = null;
        isLoading = false;
      });
      return;
    }

    final covers = await GameApiService.fetchCoverByGames(games);
    setState(() {
      coverGames = covers;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.darkGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.teal))
            : widget.gameIds.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NoDataList(
                          textColor: Colors.white,
                          icon: Icons.error_outline,
                          message: 'No Games Found',
                          subMessage:
                              'Error in loading games, please try again.',
                          color: Colors.grey,
                        )
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: coverGames?.length ?? 0,
                    itemBuilder: (context, index) {
                      final coverGame = coverGames?[index];
                      final gameId = coverGame?['game'];

                      if (gameId != null && widget.gameIds.contains(gameId)) {
                        return Container(
                          width: 180,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          child: ImageCardWidget(
                            imageUrl:
                                'https://images.igdb.com/igdb/image/upload/t_cover_big/${coverGame?['image_id']}.jpg',
                            gameId: gameId,
                          ),
                        );
                      } else {
                        return ImageCardWidget(imageUrl: '', gameId: gameId);
                      }
                    },
                  ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
      ),
    );
  }
}
