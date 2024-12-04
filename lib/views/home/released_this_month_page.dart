import 'package:flutter/material.dart';
import 'package:gamerverse/services/game_api_service.dart';
import 'package:gamerverse/widgets/common_sections/card_game.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';

class ReleasedThisMonthPage extends StatefulWidget {
  const ReleasedThisMonthPage({super.key});

  @override
  _ReleasedThisMonthPageState createState() => _ReleasedThisMonthPageState();
}

class _ReleasedThisMonthPageState extends State<ReleasedThisMonthPage> {
  final List<Map<String, dynamic>> _games = []; // Store all games released this month
  bool _isLoading = true; // For initial loading
  bool _isLoadingMore = false; // For lazy loading
  String? _errorMessage;
  int _offset = 0; // Start offset for pagination
  final ScrollController _scrollController = ScrollController(); // Controller for lazy loading

  @override
  void initState() {
    super.initState();
    _fetchGames();
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

      final gamesResponse = await GameApiService.fetchReleasedThisMonthGames(offset: _offset);
      if (gamesResponse != null && gamesResponse.isNotEmpty) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Released This Month', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {}, // Filter functionality here
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : Stack(
        children: [
          GridView.builder(
            controller: _scrollController, // Attach controller
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3), // Adjusted index for Released This Month
    );
  }
}
