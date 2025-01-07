import 'package:flutter/material.dart';
import 'package:gamerverse/services/game_api_service.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';
import 'package:gamerverse/widgets/specific_game/youtube_player.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;

class MediaGameWidget extends StatefulWidget {
  final Map<String, dynamic>? gameData;

  const MediaGameWidget({
    super.key,
    required this.gameData,
  });

  @override
  MediaGameWidgetState createState() => MediaGameWidgetState();
}

class MediaGameWidgetState extends State<MediaGameWidget> {
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

  Future<bool> _checkImageExists(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> _filterValidImages(
      List<Map<String, dynamic>> images) async {
    List<Map<String, dynamic>> validImages = [];
    for (var image in images) {
      final imageUrl =
          'https://images.igdb.com/igdb/image/upload/t_screenshot_huge/${image['image_id']}.jpg';
      final isValid = await _checkImageExists(imageUrl);
      if (isValid) {
        validImages.add(image);
      }
    }
    return validImages;
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
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.8),
                builder: (context) {
                  return Dialog(
                    insetPadding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    child: Stack(
                      children: [
                        Center(
                          child: YoutubePlayerWidget(
                            videoId: media['video_id'],
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  'https://i.ytimg.com/vi/${media['video_id']}/hqdefault.jpg',
                  width: 200,
                  height: 125,
                  fit: BoxFit.cover,
                ),
                const Icon(Icons.play_circle_fill,
                    color: Colors.white, size: 50),
              ],
            ),
          ),
        ),
      );
    }).toList());

    // Images and Artworks
    List<Map<String, dynamic>> allImages = [...images, ...artworks];
    mediaWidgets.addAll(allImages.map((media) {
      return isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : FutureBuilder<bool>(
              future: _checkImageExists(
                'https://images.igdb.com/igdb/image/upload/t_screenshot_huge/${media['image_id']}.jpg',
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError || !(snapshot.data ?? false)) {
                    return SizedBox.shrink();
                  }
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
                          _openImageGallery(
                              context, allImages, allImages.indexOf(media));
                        },
                        child: Image.network(
                          'https://images.igdb.com/igdb/image/upload/t_screenshot_huge/${media['image_id']}.jpg',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
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

  void _openImageGallery(BuildContext context,
      List<Map<String, dynamic>> images, int initialIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _filterValidImages(images),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.teal),
              );
            }

            if (snapshot.hasError || (snapshot.data?.isEmpty ?? true)) {
              return Center(
                  child: NoDataList(
                      textColor: Colors.teal,
                      icon: Icons.image_not_supported_outlined,
                      message: 'Image not available',
                      subMessage: 'There is a problem in loading this image',
                      color: Colors.white));
            }

            final validImages = snapshot.data!;

            return Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.black.withOpacity(0.7),
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: validImages.length,
                    controller: PageController(initialPage: initialIndex),
                    itemBuilder: (context, index) {
                      return PhotoView(
                        imageProvider: NetworkImage(
                          'https://images.igdb.com/igdb/image/upload/t_screenshot_huge/${validImages[index]['image_id']}.jpg',
                        ),
                        backgroundDecoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 16,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
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
}
