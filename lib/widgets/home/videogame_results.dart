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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
          );
        }

        if (snapshot.hasError) {
          Future.delayed(Duration.zero, () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${snapshot.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 50),
                SizedBox(height: 10),
                Text(
                  'Something went wrong. Please try again later.',
                  style: TextStyle(color: Colors.red),
                ),
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

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off, color: Colors.white, size: 50),
                SizedBox(height: 10),
                Text(
                  'No games found for "${widget.searchQuery}".',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          );
        }

        final games = snapshot.data!;
        return ListView.builder(
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            final gameId = game['id'];

            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/game',
                  arguments: gameId,
                );
              },
              child: Card(
                color: Colors.white, // White card background
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      // Game Cover
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: game['coverUrl'] != null
                            ? Image.network(
                          game['coverUrl']!,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        )
                            : const Icon(
                          Icons.image_not_supported,
                          size: 90,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 15),

                      // Game Information
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game['name'] ?? 'Unknown Game',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Dark text color
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Click to view details',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.black45),
                    ],
                  ),
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
        color: Colors.white, // White card background
        elevation: 8,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          leading: game['coverUrl'] != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              game['coverUrl']!,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          )
              : const Icon(
            Icons.image_not_supported,
            size: 90,
            color: Colors.grey,
          ),
          title: Text(
            game['name'] ?? 'Unknown Game',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black, // Dark text color
            ),
          ),
          subtitle: const Text(
            'Click to view details',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black45),
          onTap: () {
            // Action on tap
          },
        ),
      ),
    );
  }
}
