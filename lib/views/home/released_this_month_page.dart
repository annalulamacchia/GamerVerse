import 'package:flutter/material.dart';
import 'package:gamerverse/services/game_api_service.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/common_sections/card_game.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';

class ReleasedThisMonthPage extends StatefulWidget {
  const ReleasedThisMonthPage({super.key});

  @override
  _ReleasedThisMonthPageState createState() => _ReleasedThisMonthPageState();
}

class _ReleasedThisMonthPageState extends State<ReleasedThisMonthPage> {
  List<Map<String, dynamic>> _games = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorMessage;
  int _offset = 0;
  final ScrollController _scrollController = ScrollController();

  // Filter options
  String? _selectedOrderBy = 'Rating';
  String? _selectedPlatform;
  String? _selectedGenre;

  final List<String> _orderByOptions = ['Popularity', 'Alphabetical', 'Rating'];
  final List<String> _platformOptions = [
    'PS1',
    'PS2',
    'PS3',
    'PS4',
    'PS5',
    'PlayStation VR',
    'PlayStation VR2',
    'Xbox',
    'Xbox 360',
    'Xbox One',
    'Xbox Series X|S',
    'PC',
    'Nintendo DS',
    'Nintendo 3DS',
    'Wii',
    'WiiU',
    'Nintendo Switch',
    'Oculus Quest',
    'Oculus Rift',
  ];
  final List<String> _genreOptions = [
    'Action',
    'Adventure',
    'Arcade',
    'Indie',
    'Puzzle',
    'Racing',
    'RPG',
    'Shooter',
    'Sport',
    'Strategy',
  ];

  @override
  void initState() {
    super.initState();
    _fetchGames();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchGames() async {
    try {
      setState(() {
        if (_offset == 0) {
          _isLoading = true;
        } else {
          _isLoadingMore = true;
        }
      });

      final gamesResponse = await GameApiService.fetchFilteredGames(
        orderBy: _selectedOrderBy,
        platform: _selectedPlatform,
        genre: _selectedGenre,
        limit: 100,
        offset: _offset,
        page: 'RELEASED_THIS_MONTH',
      );

      if (gamesResponse.isNotEmpty) {
        setState(() {
          _games.addAll(gamesResponse);
          _offset += gamesResponse.length;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore) {
      _fetchGames();
    }
  }

  Future<void> _fetchFilteredGames() async {
    try {
      setState(() {
        _isLoading = true;
        _games = [];
        _offset = 0;
      });

      final filteredGames = await GameApiService.fetchFilteredGames(
        orderBy: _selectedOrderBy,
        platform: _selectedPlatform,
        genre: _selectedGenre,
        limit: 100,
        offset: _offset,
        page: 'RELEASED_THIS_MONTH',
      );

      setState(() {
        _games = filteredGames;
        _offset = filteredGames.length;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showFilterPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FractionallySizedBox(
              heightFactor: 0.5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: const Text(
                              'Order By',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            children: _orderByOptions.map((option) {
                              return ChoiceChip(
                                label: Text(option),
                                selected: _selectedOrderBy == option,
                                selectedColor: Colors.green,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedOrderBy = selected ? option : null;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: const Text(
                              'Platform',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            children: _platformOptions.map((option) {
                              return ChoiceChip(
                                label: Text(option),
                                selected: _selectedPlatform == option,
                                selectedColor: Colors.green,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedPlatform =
                                        selected ? option : null;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: const Text(
                              'Genre',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            children: _genreOptions.map((option) {
                              return ChoiceChip(
                                label: Text(option),
                                selected: _selectedGenre == option,
                                selectedColor: Colors.green,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedGenre = selected ? option : null;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _fetchFilteredGames();
                      },
                      child: Text('Apply',
                          style: TextStyle(color: AppColors.mediumGreen)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        title: const Text('Released This Month',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.darkGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterPopup,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : _errorMessage != null
              ? const Center(
                  child: NoDataList(
                    textColor: Colors.teal,
                    icon: Icons.videogame_asset_off,
                    message: 'No games found with those filters',
                    subMessage:
                        'Try adjusting your search criteria or check back later.',
                    color: Colors.white,
                  ),
                )
              : Stack(
                  children: [
                    GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _games.length,
                      itemBuilder: (context, index) {
                        final game = _games[index];
                        final coverUrl = game['coverUrl'] ??
                            'https://via.placeholder.com/400x200?text=No+Image';
                        return ImageCardWidget(
                          imageUrl: coverUrl,
                          gameId: game['id'],
                        );
                      },
                    ),
                    if (_isLoadingMore)
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.teal),
                        ),
                      ),
                  ],
                ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
