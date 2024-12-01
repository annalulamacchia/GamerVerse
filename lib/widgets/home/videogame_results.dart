import 'package:flutter/material.dart';
import 'package:gamerverse/services/game_api_service.dart';

class VideoGameResults extends StatefulWidget {
  final String searchQuery;

  const VideoGameResults({super.key, required this.searchQuery});

  @override
  _VideoGameResultsState createState() => _VideoGameResultsState();
}

class _VideoGameResultsState extends State<VideoGameResults> {
  late Future<List<Map<String, dynamic>>?> _gamesFuture;

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  @override
  void didUpdateWidget(VideoGameResults oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _fetchGames();
    }
  }

  void _fetchGames() {
    setState(() {
      if (widget.searchQuery.isNotEmpty) {
        _gamesFuture = GameApiService.fetchGamesByName(widget.searchQuery);
      } else {
        _gamesFuture = Future.value([]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: _gamesFuture,
      builder: (context, snapshot) {
        // Loading State with a Material Design progress indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
          );
        }

        // Error State with Snackbar option
        if (snapshot.hasError) {
          Future.delayed(Duration.zero, () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${snapshot.error}'), backgroundColor: Colors.red),
            );
          });

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 50),
                SizedBox(height: 10),
                Text('Something went wrong. Please try again later.', style: TextStyle(color: Colors.red)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _fetchGames,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('Retry', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }

        // Empty State with a search icon and clear message
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off, color: Colors.white70, size: 50),
                SizedBox(height: 10),
                Text('No games found for "${widget.searchQuery}".', style: TextStyle(color: Colors.white70, fontSize: 16)),
              ],
            ),
          );
        }

        // Data State: Show list of games
        final games = snapshot.data!;
        return ListView.builder(
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            final gameId = game['id']; // Assuming each game has an 'id'

            return InkWell(
              onTap: () {
                // Navigate to the SpecificGame page when the card is tapped
                Navigator.pushNamed(
                  context,
                  '/game', // Route name
                  arguments: gameId, // Pass the game ID to the new page
                );
              },
              child: Card(
                child: ListTile(
                  leading: game['coverUrl'] != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      game['coverUrl']!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.image_not_supported),
                  title: Text(
                    game['name'] ?? 'Unknown Game',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text('Click to view details'),
                ),
              ),
            );
          },
        );



      },
    );
  }
}

class AnimatedCard extends StatelessWidget {
  final Map<String, dynamic> game;

  const AnimatedCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 500),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          leading: game['coverUrl'] != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              game['coverUrl']!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          )
              : const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
          title: Text(
            game['name'] ?? 'Unknown Game',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              'Click to view details',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              // Navigate to game details page
            },
          ),
          onTap: () {
            // Show more information about the selected game
          },
        ),
      ),
    );
  }
}
