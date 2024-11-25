import 'package:flutter/material.dart';
import 'package:gamerverse/services/gameApiService.dart';
import 'package:gamerverse/widgets/common_sections/card_game.dart';

class SeriesGame extends StatefulWidget {
  final List<Map<String, dynamic>>? collections;

  const SeriesGame({super.key, required this.collections});

  @override
  _SeriesGameState createState() => _SeriesGameState();
}

class _SeriesGameState extends State<SeriesGame> {
  bool isLoading = true;
  late List<dynamic> gameIds;
  List<Map<String, dynamic>>? coverGames;

  @override
  void initState() {
    super.initState();
    gameIds = [];

    if (widget.collections!.isNotEmpty) {
      for (var collection in widget.collections!) {
        List<dynamic> currentGameIds = List<dynamic>.from(collection['games']);
        gameIds.addAll(currentGameIds);
      }

      gameIds.sort();
    }
    _loadCovers(gameIds);
  }

  Future<void> _loadCovers(List<dynamic> gameIds) async {
    if (gameIds.isEmpty) {
      setState(() {
        coverGames = null;
        isLoading = false;
      });
      return;
    }

    final covers = await GameApiService.fetchCoverByGames(gameIds);
    setState(() {
      coverGames = covers;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        title: const Text('Series Game', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xff163832),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 0.8,
                ),
                itemCount: gameIds.length,
                itemBuilder: (context, index) {
                  int gameId = gameIds[index];
                  if (gameId == coverGames?[index]['game']) {
                    final coverGame = coverGames?[index];

                    return Container(
                      width: 180,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      child: ImageCardWidget(
                          imageUrl:
                              'https://images.igdb.com/igdb/image/upload/t_cover_big/${coverGame?['image_id']}.jpg',
                          gameId: gameId),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
      ),
    );
  }
}
