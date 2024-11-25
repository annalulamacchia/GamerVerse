import 'package:flutter/material.dart';
import 'package:gamerverse/services/gameApiService.dart';
import 'package:gamerverse/widgets/specific_game/youtube_player.dart';

class MediaGameWidget extends StatefulWidget {
  Map<String, dynamic>? gameData;

  MediaGameWidget({
    super.key,
    required this.gameData,
  });

  @override
  _MediaGameWidget createState() => _MediaGameWidget();
}

class _MediaGameWidget extends State<MediaGameWidget> {
  List<Map<String, dynamic>>? screenshotsGame;
  List<Map<String, dynamic>>? videosGame;
  List<Map<String, dynamic>>? artworksGame;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedia();
  }

  Future<void> _loadMedia() async {
    //load the videos of the game
    if (widget.gameData != null &&
        widget.gameData?['videos'] != null &&
        widget.gameData?['videos'].length != 0) {
      _loadVideosGame(widget.gameData?['id']);
    }

    //load the screenshots of the game
    if (widget.gameData != null &&
        widget.gameData?['screenshots'] != null &&
        widget.gameData?['screenshots'].length != 0) {
      _loadScreenshotsGame(widget.gameData?['id']);
    }

    //load the artworks of the game
    if (widget.gameData != null &&
        widget.gameData?['artworks'] != null &&
        widget.gameData?['artworks'].length != 0) {
      _loadArtworksGame(widget.gameData?['id']);
    }
  }

  //load the screenshots of the game
  Future<void> _loadScreenshotsGame(int? gameId) async {
    if (gameId == null) {
      setState(() {
        screenshotsGame = null;
        isLoading = false;
      });
      return;
    }

    final screenshots = await GameApiService.fetchScreenshotsGame(gameId);
    setState(() {
      screenshotsGame = screenshots;
      isLoading = false;
    });
  }

  //load videos of the game
  Future<void> _loadVideosGame(int? gameId) async {
    if (gameId == null) {
      setState(() {
        videosGame = null;
        isLoading = false;
      });
      return;
    }

    final videos = await GameApiService.fetchVideosGame(gameId);
    setState(() {
      videosGame = videos;
      isLoading = false;
    });
  }

  //load artworks of the game
  Future<void> _loadArtworksGame(int? gameId) async {
    if (gameId == null) {
      setState(() {
        artworksGame = null;
        isLoading = false;
      });
      return;
    }

    final artworks = await GameApiService.fetchArtworksGame(gameId);
    setState(() {
      artworksGame = artworks;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final images = screenshotsGame ?? [];
    final videos = videosGame ?? [];
    final artworks = artworksGame ?? [];

    List<Widget> mediaWidgets = [];

    //Videos
    mediaWidgets.addAll(videos.map((media) {
      return Container(
        width: 200,
        height: 125,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: YoutubePlayerWidget(videoId: media['video_id']),
                    ),
                  );
                },
              );
            },
            child: YoutubePlayerWidget(videoId: media['video_id']),
          ),
        ),
      );
    }).toList());

    //Images
    mediaWidgets.addAll(images.map((media) {
      return isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              width: 200,
              height: 125,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://images.igdb.com/igdb/image/upload/t_screenshot_huge/${media['image_id']}.jpg',
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Image.network(
                    'https://images.igdb.com/igdb/image/upload/t_screenshot_huge/${media['image_id']}.jpg',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
    }).toList());

    mediaWidgets.addAll(artworks.map((media) {
      return Container(
        width: 200,
        height: 125,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://images.igdb.com/igdb/image/upload/t_screenshot_huge/${media['image_id']}.jpg',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            },
            child: Image.network(
              'https://images.igdb.com/igdb/image/upload/t_screenshot_huge/${media['image_id']}.jpg',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }).toList());

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: mediaWidgets,
        ),
      ),
    );
  }
}
