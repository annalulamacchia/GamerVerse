import 'package:flutter/material.dart';
import 'package:gamerverse/services/gameApiService.dart';
import 'package:gamerverse/services/gameCoverApiService.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/common_sections/card_game.dart';
import 'package:gamerverse/widgets/specific_game/game_time.dart';
import 'package:gamerverse/widgets/specific_game/play_completed_buttons.dart';
import 'package:gamerverse/widgets/specific_game/specific_game_list.dart';
import 'package:gamerverse/widgets/specific_game/specific_game_section.dart';
import 'package:gamerverse/widgets/specific_game/single_review.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:gamerverse/widgets/specific_game/favourite_button.dart';

class SpecificGame extends StatefulWidget {
  final int gameId;

  const SpecificGame({super.key, required this.gameId});

  @override
  _SpecificGameState createState() => _SpecificGameState();
}

class _SpecificGameState extends State<SpecificGame> {
  Map<String, dynamic>? gameData;
  Map<String, dynamic>? coverGame;
  List<Map<String, dynamic>>? coverSimilarGames;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGameData();
  }

  Future<void> _loadGameData() async {
    final data = await GameApiService.fetchGameData(widget.gameId);
    setState(() {
      gameData = data;
      isLoading = false;
    });

    if (gameData != null && gameData?['cover'] != null) {
      _loadCoverGame(gameData?['cover']);
    }
    if (gameData != null && gameData?['similar_games'] != null) {
      _loadCoverSimilarGames(gameData?['similar_games']);
    }
  }

  Future<void> _loadCoverGame(int? coverId) async {
    if (coverId == null) {
      setState(() {
        coverGame = null;
        isLoading = false;
      });
      return;
    }

    final cover = await GameCoverApiService.fetchCoverGame(coverId);
    setState(() {
      coverGame = cover;
      isLoading = false;
    });
  }

  Future<void> _loadCoverSimilarGames(List<dynamic> gameIds) async {
    if (gameIds.isEmpty) {
      setState(() {
        coverSimilarGames = null;
        isLoading = false;
      });
      return;
    }

    final covers = await GameCoverApiService.fetchCoverSimilarGames(gameIds);
    setState(() {
      coverSimilarGames = covers;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> developers = ['Red Team', 'Blue Team', 'Dev3'];
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xff051f20),
        appBar: AppBar(
          backgroundColor: const Color(0xff163832),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title:
              const Text('Loading...', style: TextStyle(color: Colors.white)),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        backgroundColor: const Color(0xff163832),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(gameData?['name'],
            style: const TextStyle(color: Colors.white)),
        actions: const [
          FavoriteButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                'https://images.igdb.com/igdb/image/upload/t_thumb/${coverGame?['image_id']}.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            //Name game and users rating
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Name Game
                  Flexible(
                    flex: 1,
                    child: Text(
                      gameData?['name'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  //Users Rating
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/allReviews');
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedPacman02,
                              color: Colors.white,
                              size: 24.0,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '4.5',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Users Rating',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            //Playing and Completed Buttons
            const PlayCompleteButtons(),
            const SizedBox(height: 12),

            //Critics Rating, Liked and Played
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Critics Rating
                const Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 20),
                        SizedBox(width: 4),
                        Text(
                          '5',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                    Text(
                      'Critics Rating',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(width: 20),

                //Liked
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/likedList');
                  },
                  child: const Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.favorite, color: Colors.white, size: 20),
                          SizedBox(width: 4),
                          Text(
                            '100',
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
                ),
                const SizedBox(width: 20),

                //Played
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/playedList');
                  },
                  child: const Column(
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
                            '100',
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
                ),
              ],
            ),
            const Divider(height: 30),

            //Series
            const SpecificGameSectionWidget(title: 'Series'),
            const SizedBox(height: 10),

            //Storyline
            const SpecificGameSectionWidget(title: 'Storyline'),
            const SizedBox(height: 25),

            //Media
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(10, (index) {
                    return Container(
                      width: 200,
                      height: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Item ${index + 1}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 25),

            //Last Review
            const SingleReview(
                username: "Giocatore1",
                rating: 4.5,
                comment: "Questo gioco è fantastico, mi piace molto!",
                avatarUrl:
                    "https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg",
                likes: 11,
                dislikes: 11),
            const SizedBox(height: 2),

            //All Reviews
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3e6259),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/allReviews');
                  },
                  child: const Text('All Reviews',
                      style: TextStyle(color: Colors.white))),
            ),
            const SizedBox(height: 20),

            //Playing Time
            const GameTimeWidget(),
            const Divider(height: 35),

            //Developers
            SpecificGameList(title: 'Developers', list: developers),
            const SizedBox(height: 3),

            //Publisher
            SpecificGameList(title: 'Publisher', list: developers),
            const SizedBox(height: 3),

            //Genre
            SpecificGameList(title: 'Genre', list: developers),
            const SizedBox(height: 3),

            //Platforms
            SpecificGameList(title: 'Platforms', list: developers),
            const SizedBox(height: 3),

            //Release Date
            SpecificGameList(title: 'Release Date', list: developers),
            const Divider(height: 35),

            //Suggested Games
            const Text('Suggested Games',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 7.5),
            Padding(
              padding: const EdgeInsets.all(1),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                      gameData?['similar_games']?.length ?? 0, (index) {
                    final similarGame = gameData?['similar_games'][index];
                    final coverSimilar = coverSimilarGames?[index];
                    return Container(
                      width: 180,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      child: ImageCardWidget(
                          imageUrl:
                          'https://images.igdb.com/igdb/image/upload/t_thumb/${coverSimilar?['image_id']}.jpg',
                          gameId: similarGame), // Usa ImageCardWidget
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
      ),
    );
  }
}
