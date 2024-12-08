import 'package:flutter/material.dart';
import 'package:gamerverse/models/game.dart';
import 'package:gamerverse/models/review.dart';
import 'package:gamerverse/models/user.dart';
import 'package:gamerverse/services/game_api_service.dart';
import 'package:gamerverse/services/specific_game/review_service.dart';
import 'package:gamerverse/services/specific_game/status_game_service.dart';
import 'package:gamerverse/services/specific_game/wishlist_service.dart';
import 'package:gamerverse/utils/firebase_auth_helper.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/common_sections/card_game.dart';
import 'package:gamerverse/widgets/specific_game/coming_soon_card.dart';
import 'package:gamerverse/widgets/specific_game/game_time.dart';
import 'package:gamerverse/widgets/specific_game/liked_button_to_list.dart';
import 'package:gamerverse/widgets/specific_game/media_game.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';
import 'package:gamerverse/widgets/specific_game/play_completed_buttons.dart';
import 'package:gamerverse/widgets/specific_game/played_button_to_list.dart';
import 'package:gamerverse/widgets/specific_game/specific_game_list.dart';
import 'package:gamerverse/widgets/specific_game/specific_game_section.dart';
import 'package:gamerverse/widgets/specific_game/single_review.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:gamerverse/widgets/specific_game/favourite_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SpecificGame extends StatefulWidget {
  final int gameId;

  const SpecificGame({super.key, required this.gameId});

  @override
  SpecificGameState createState() => SpecificGameState();
}

class SpecificGameState extends State<SpecificGame> {
  Map<String, dynamic>? gameData;
  Map<String, dynamic>? coverGame;
  List<Map<String, dynamic>>? coverSimilarGames;
  List<Map<String, dynamic>>? screenshotsGame;
  List<Map<String, dynamic>>? videosGame;
  List<Map<String, dynamic>>? artworksGame;
  bool isLoading = true;
  Game? game;
  late String? userId = '';
  ValueNotifier<int> likedCountNotifier = ValueNotifier<int>(0);
  ValueNotifier<int> playedCountNotifier = ValueNotifier<int>(0);
  ValueNotifier<double> averageTimeNotifier = ValueNotifier<double>(0);
  double userRating = 0;
  Review? latestReview;
  bool isLoadingReview = true;
  bool isLoadingUsersByGame = true;
  bool isLoadingUsersByStatus = true;
  ValueNotifier<double> averageUserReviewNotifier = ValueNotifier<double>(0);
  bool _isLoadingUserRating = false;
  bool _isLoadingLatestReview = false;
  bool _isLoadingUsers = false;
  bool _isLoadingStatusUsers = false;
  List<User>? users;
  List<User>? userStatus;
  ValueNotifier<Review> latestReviewNotifier = ValueNotifier<Review>(Review(
      reviewId: null,
      writerId: null,
      description: '',
      rating: 0,
      writerUsername: '',
      timestamp: '',
      likes: {},
      dislikes: {},
      writerPicture: '',
      status: '',
      gameId: ''));

  @override
  void initState() {
    super.initState();
    _loadGameData();
    _loadUserData();
  }

  //load the user_id
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString('user_uid');
    final valid = await FirebaseAuthHelper.checkTokenValidity();
    setState(() {
      if (valid) {
        userId = uid;
      } else {
        userId = null;
      }
    });
  }

  //load all the info of the game
  Future<void> _loadGameData() async {
    final data = await GameApiService.fetchGameData(widget.gameId);
    setState(() {
      gameData = data;
    });

    //load the cover of the game
    if (gameData != null && gameData?['cover'] != null) {
      _loadCoverGame(gameData?['cover']);
    }

    //load the similar games
    if (gameData != null &&
        gameData?['similar_games'] != null &&
        gameData?['similar_games'].length != 0) {
      _loadCoverSimilarGames(gameData?['similar_games']);
    }

    if (gameData != null && gameData?['id'] != null) {
      averageUserReviewNotifier.addListener(_loadAverageUserRating);
      _loadAverageUserRating();
      latestReviewNotifier.addListener(_loadLatestReview);
      _loadLatestReview();
      likedCountNotifier.addListener(_loadUsersByGame);
      _loadUsersByGame();
      playedCountNotifier.addListener(_loadUsersByStatusGame);
      _loadUsersByStatusGame();
    }
  }

  @override
  void dispose() {
    super.dispose();
    averageUserReviewNotifier.removeListener(_loadAverageUserRating);
    latestReviewNotifier.removeListener(_loadLatestReview);
    likedCountNotifier.removeListener(_loadUsersByGame);
    playedCountNotifier.removeListener(_loadUsersByStatusGame);
  }

  //load the cover of the game
  Future<void> _loadCoverGame(int? coverId) async {
    if (coverId == null) {
      setState(() {
        coverGame = null;
      });
      return;
    }

    final cover = await GameApiService.fetchCoverGame(coverId);
    setState(() {
      coverGame = cover;
    });

    if (gameData?['id'] != null &&
        gameData?['name'] != null &&
        gameData?['cover'] != null) {
      Map<String, dynamic> gameDetails = {
        'id': gameData?['id'],
        'name': gameData?['name'],
        'cover': coverGame?['image_id'],
        'aggregated_rating': gameData?['aggregated_rating'] != null
            ? gameData!['aggregated_rating']
            : 0,
      };
      game = Game.fromJson(gameDetails);
      isLoading = false;
    }
  }

  //load the cover of the similar games
  Future<void> _loadCoverSimilarGames(List<dynamic> gameIds) async {
    if (gameIds.isEmpty) {
      setState(() {
        coverSimilarGames = null;
      });
      return;
    }

    final covers = await GameApiService.fetchCoverByGames(gameIds);
    setState(() {
      coverSimilarGames = covers;
    });
  }

  //load the average user rating
  Future<void> _loadAverageUserRating() async {
    if (_isLoadingUserRating) return;
    _isLoadingUserRating = true;

    if (!mounted) {
      _isLoadingUserRating = false;
      return;
    }
    final rating =
        await ReviewService.getAverageUserRating(gameId: gameData?['id']);
    setState(() {
      if (rating != null) {
        averageUserReviewNotifier.value = rating;
      } else {
        averageUserReviewNotifier.value = 0;
      }
    });

    _isLoadingUserRating = false;
  }

  //load the latest review
  Future<void> _loadLatestReview() async {
    if (_isLoadingLatestReview) return;
    _isLoadingLatestReview = true;

    if (!mounted) {
      _isLoadingLatestReview = false;
      return;
    }

    final review =
        await ReviewService.getLatestReview(gameId: gameData!['id'].toString());
    setState(() {
      if (review != null) {
        latestReview = review;
      } else {
        latestReview = null;
      }
      isLoadingReview = false;
    });

    _isLoadingLatestReview = false;
  }

  //load all the users that have that game in the wishlist
  Future<void> _loadUsersByGame() async {
    if (_isLoadingUsers) return;
    _isLoadingUsers = true;

    if (!mounted) {
      _isLoadingUsers = false;
      return;
    }

    final us = await WishlistService.getUsersByGame(
        gameId: gameData!['id'].toString());
    setState(() {
      users = us;
      if (us != null) {
        likedCountNotifier.value = us.length;
      } else {
        likedCountNotifier.value = 0;
      }
      isLoadingUsersByGame = false;
    });

    _isLoadingUsers = false;
  }

  //load all the users that have that game in the wishlist
  Future<void> _loadUsersByStatusGame() async {
    if (_isLoadingStatusUsers) return;
    _isLoadingStatusUsers = true;

    if (!mounted) {
      _isLoadingStatusUsers = false;
      return;
    }

    final us = await StatusGameService.getUsersByStatusGame(
        gameData!['id'].toString());
    setState(() {
      userStatus = us;
      if (us != null) {
        playedCountNotifier.value = us.length;
      } else {
        playedCountNotifier.value = 0;
      }
      isLoadingUsersByStatus = false;
    });

    _isLoadingStatusUsers = false;
  }

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
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

        //Name and Add to Wishlist button
        title: Text(gameData?['name'],
            style: const TextStyle(color: Colors.white)),
        actions: [
          FavoriteButton(
              userId: userId,
              game: game,
              likedCountNotifier: likedCountNotifier,
              onLoadWishlist: _loadUsersByGame)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/${coverGame?['image_id']}.jpg',
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
                      maxLines: null,
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(width: 20),

                  //Users Rating
                  InkWell(
                    onTap: (gameData?['first_release_date'] != null &&
                            gameData?['first_release_date'] * 1000 <
                                DateTime.now().millisecondsSinceEpoch)
                        ? () {
                            Navigator.pushNamed(context, '/allReviews',
                                arguments: {
                                  'userId': userId,
                                  'game': game,
                                  'onLoadAverageRating': _loadAverageUserRating,
                                  'averageUserReviewNotifier':
                                      averageUserReviewNotifier,
                                  'latestReviewNotifier': latestReviewNotifier,
                                  'onLoadLatestReview': _loadLatestReview,
                                });
                          }
                        : null,
                    child: Column(
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
                            ValueListenableBuilder<double>(
                                valueListenable: averageUserReviewNotifier,
                                builder: (context, averageUserReview, child) {
                                  return Text(
                                    averageUserReview != 0
                                        ? averageUserReview.toString()
                                        : 'N/A',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  );
                                })
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
            if (gameData?['first_release_date'] != null &&
                gameData?['first_release_date'] * 1000 <
                    DateTime.now().millisecondsSinceEpoch)
              PlayCompleteButtons(
                  userId: userId,
                  game: game!,
                  playedCountNotifier: playedCountNotifier,
                  onStatusChanged: _loadUsersByStatusGame),
            if ((gameData?['first_release_date'] != null &&
                    gameData?['first_release_date'] * 1000 >
                        DateTime.now().millisecondsSinceEpoch) ||
                gameData?['first_release_date'] == null)
              ComingSoonCard(
                  relaseDate: gameData?['first_release_date'] != null
                      ? DateFormat('d MMMM yyyy').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              gameData?['first_release_date'] * 1000,
                              isUtc: true))
                      : 'TBD'),
            const SizedBox(height: 12),

            //Critics Rating, Liked and Played
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Critics Rating
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 20),
                        SizedBox(width: 4),
                        Text(
                          gameData?['aggregated_rating'] != null
                              ? ((gameData?['aggregated_rating'] * 5) / 100)
                                  .toStringAsFixed(1)
                              : 'N/A',
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

                //Liked List
                LikedButtonToList(
                  gameId: gameData!['id'].toString(),
                  likedCountNotifier: likedCountNotifier,
                  users: users,
                ),
                const SizedBox(width: 20),

                //Played List
                PlayedButtonToList(
                    game: game,
                    playedCountNotifier: playedCountNotifier,
                    releaseDate: gameData?['first_release_date'],
                    userId: userId),
              ],
            ),
            const Divider(height: 30),

            //Series
            if (gameData != null &&
                gameData?['collections'] != null &&
                gameData?['collections'].length != 0)
              SpecificGameSectionWidget(
                title: 'Series',
                games: gameData?['collections'],
                storyline: "",
              ),
            const SizedBox(height: 10),

            //Storyline
            if (gameData != null && gameData?['storyline'] != null)
              SpecificGameSectionWidget(
                  title: 'Storyline',
                  games: [],
                  storyline: gameData?['storyline']),
            if (gameData != null &&
                gameData?['storyline'] == null &&
                gameData?['summary'] != null)
              SpecificGameSectionWidget(
                  title: 'Storyline',
                  games: [],
                  storyline: gameData?['summary']),

            //Media
            MediaGameWidget(
              gameData: gameData,
            ),
            if (gameData != null &&
                (gameData?['videos'] != null ||
                    gameData?['artworks'] != null ||
                    gameData?['screenshots'] != null))
              const SizedBox(height: 20),

            if (gameData?['first_release_date'] != null &&
                gameData?['first_release_date'] * 1000 <
                    DateTime.now().millisecondsSinceEpoch)
              if (latestReview != null && isLoadingReview == false)
                //Last Review
                SingleReview(
                    userId: userId,
                    review: latestReview,
                    gameContext: parentContext,
                    onReviewRemoved: () {
                      _loadLatestReview();
                    }),
            if (latestReview == null && isLoadingReview == true)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (gameData?['first_release_date'] != null &&
                gameData?['first_release_date'] * 1000 <
                    DateTime.now().millisecondsSinceEpoch &&
                latestReview == null &&
                isLoadingReview == false)
              NoDataList(
                  icon: Icons.reviews_outlined,
                  message: 'No reviews available.',
                  subMessage: 'Be the first to share your thoughts!',
                  textColor: Colors.black,
                  color: Colors.black,
                  containerColor: Color(0xfff0f9f1)),
            if (gameData?['first_release_date'] != null &&
                gameData?['first_release_date'] * 1000 <
                    DateTime.now().millisecondsSinceEpoch)
              const SizedBox(height: 2),

            //All Reviews
            if (gameData?['first_release_date'] != null &&
                gameData?['first_release_date'] * 1000 <
                    DateTime.now().millisecondsSinceEpoch)
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3e6259),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/allReviews', arguments: {
                        'userId': userId,
                        'game': game,
                        'onLoadAverageRating': _loadAverageUserRating,
                        'averageUserReviewNotifier': averageUserReviewNotifier,
                        'latestReviewNotifier': latestReviewNotifier,
                        'onLoadLatestReview': _loadLatestReview,
                      });
                    },
                    child: latestReview != null
                        ? const Text('All Reviews',
                            style: TextStyle(color: Colors.white))
                        : const Text('Add Review',
                            style: TextStyle(color: Colors.white))),
              ),
            if (gameData?['first_release_date'] != null &&
                gameData?['first_release_date'] * 1000 <
                    DateTime.now().millisecondsSinceEpoch)
              const SizedBox(height: 20),

            //Playing Time
            if (gameData?['first_release_date'] != null &&
                gameData?['first_release_date'] * 1000 <
                    DateTime.now().millisecondsSinceEpoch)
              GameTimeWidget(
                  userId: userId,
                  game: game,
                  averageTimeNotifier: averageTimeNotifier),
            if (gameData?['first_release_date'] != null &&
                gameData?['first_release_date'] * 1000 <
                    DateTime.now().millisecondsSinceEpoch)
              const Divider(height: 35),
            if (gameData?['first_release_date'] != null &&
                gameData?['first_release_date'] * 1000 >
                    DateTime.now().millisecondsSinceEpoch)
              const Divider(height: 25),

            //Developers
            if (gameData != null && gameData?['involved_companies'] != null)
              SpecificGameList(
                  title: 'Developers',
                  list: gameData?['involved_companies'],
                  timestamp: 0),

            //Publisher
            if (gameData != null && gameData?['involved_companies'] != null)
              SpecificGameList(
                  title: 'Publishers',
                  list: gameData?['involved_companies'],
                  timestamp: 0),

            //Genre
            if (gameData != null && gameData?['genres'] != null)
              SpecificGameList(
                  title: 'Genres', list: gameData?['genres'], timestamp: 0),

            //Platforms
            if (gameData != null && gameData?['platforms'] != null)
              SpecificGameList(
                  title: 'Platforms',
                  list: gameData?['platforms'],
                  timestamp: 0),

            //Release Date
            SpecificGameList(
                title: 'First Release Date',
                list: [],
                timestamp:
                    gameData != null && gameData?['first_release_date'] != null
                        ? gameData!['first_release_date']
                        : 0),

            //Suggested Games
            if (gameData?['similar_games'] != null)
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
                  children:
                      List.generate(coverSimilarGames?.length ?? 0, (index) {
                    final similarGame = gameData?['similar_games'][index];
                    if (similarGame == coverSimilarGames?[index]['game']) {
                      final coverSimilar = coverSimilarGames?[index];
                      return Container(
                        width: 180,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        child: ImageCardWidget(
                            imageUrl:
                                'https://images.igdb.com/igdb/image/upload/t_cover_big/${coverSimilar?['image_id']}.jpg',
                            gameId: similarGame),
                      );
                    } else {
                      return Container();
                    }
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
