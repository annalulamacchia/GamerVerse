import 'package:flutter/material.dart';
import 'package:gamerverse/services/game_api_service.dart';
import 'package:gamerverse/widgets/common_sections/card_game.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';

class AllGamesPage extends StatefulWidget {
  const AllGamesPage({super.key});

  @override
  _AllGamesPageState createState() => _AllGamesPageState();
}

class _AllGamesPageState extends State<AllGamesPage> {
  List<Map<String, dynamic>>? _games;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  Future<void> _fetchGames() async {
    try {
      final gamesResponse = await GameApiService.fetchGameDataList(); // Fetch the games
      if (gamesResponse != null) {
        setState(() {
          _games = gamesResponse;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Failed to fetch games.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Games', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {}, // You can implement the filter functionality here
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: _games?.length ?? 0,
        itemBuilder: (context, index) {
          final game = _games![index];
          final coverUrl = game['coverUrl'] ?? 'https://via.placeholder.com/400x200?text=No+Image'; // Fallback image
          return ImageCardWidget(
            imageUrl: coverUrl,  // Pass the cover URL to the widget
            gameId: game['id'],  // Pass the game ID to the widget
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
