import 'package:flutter/material.dart';
import 'package:gamerverse/services/game_api_service.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/common_sections/card_game.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';

class PopularGamesPage extends StatefulWidget {
  const PopularGamesPage({super.key});

  @override
  _PopularGamesPageState createState() => _PopularGamesPageState();
}

class _PopularGamesPageState extends State<PopularGamesPage> {
  List<Map<String, dynamic>> _games = []; // Store popular games
  bool _isLoading = true; // For initial loading
  bool _isLoadingMore = false; // For lazy loading
  String? _errorMessage;
  int _offset = 0; // Start offset
  final ScrollController _scrollController =
      ScrollController(); // Controller for lazy loading

  // Preselect Popularity as the default sorting
  String? _selectedOrderBy = 'Rating';
  String? _selectedPlatform;
  String? _selectedGenre;

  // Filter options lists
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
    _fetchGames(); // Fetch games on page load with default sorting
    _scrollController.addListener(_onScroll); // Attach scroll listener
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Clean up the controller
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
          // Use Popularity as default
          platform: _selectedPlatform,
          genre: _selectedGenre,
          limit: 100,
          offset: _offset,
          page: 'POPULAR');

      if (gamesResponse.isNotEmpty) {
        setState(() {
          _games.addAll(gamesResponse); // Append new games to the list
          _isLoading = false;
          _isLoadingMore = false;
          _offset += 100; // Increase offset for the next batch
        });
      } else {
        // No more games to fetch
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred: $e";
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _onScroll() {
    // Trigger more loading when close to the bottom
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
        _games = []; // Clear current games list
      });

      // Fetch games from the API using selected filters
      final filteredGames = await GameApiService.fetchFilteredGames(
        orderBy: _selectedOrderBy,
        platform: _selectedPlatform,
        genre: _selectedGenre,
      );

      setState(() {
        _games = filteredGames; // Update games list
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred: $e";
        _isLoading = false;
      });
    }
  }

  void _showFilterPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // To allow full-screen height flexibility
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FractionallySizedBox(
              heightFactor: 0.5, // Covers half the screen
              child: Column(
                children: [
                  // Popup header
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

                  // Scrollable content to prevent overflow
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Order By section
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

                          // Platform section
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

                          // Genre section
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

                  // Apply Button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the popup
                        _fetchFilteredGames(); // Trigger API request
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
        title: const Text('Most Rated Games',
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
            onPressed: _showFilterPopup, // Open the filter popup
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
                      // Attach controller
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
                            'https://via.placeholder.com/400x200?text=No+Image'; // Fallback image
                        return ImageCardWidget(
                          imageUrl:
                              coverUrl, // Pass the cover URL to the widget
                          gameId: game['id'], // Pass the game ID to the widget
                        );
                      },
                    ),

                    // Display loading indicator for lazy loading
                    if (_isLoadingMore)
                      const Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                            child:
                                CircularProgressIndicator(color: Colors.teal)),
                      ),
                  ],
                ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
