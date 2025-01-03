import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gamerverse/services/game_api_service.dart';
import 'package:intl/intl.dart';

class SpecificGameList extends StatefulWidget {
  final List<dynamic> list;
  final String title;
  final int timestamp;

  const SpecificGameList({
    super.key,
    required this.title,
    required this.list,
    required this.timestamp,
  });

  @override
  SpecificGameListState createState() => SpecificGameListState();
}

class SpecificGameListState extends State<SpecificGameList> {
  List<Map<String, dynamic>>? details;
  String? releaseDate;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadListData();
  }

  Future<void> _loadListData() async {
    if (widget.title == 'Platforms') {
      _loadPlatformsGame(widget.list);
    }
    if (widget.title == 'Developers' || widget.title == 'Publishers') {
      _loadCompaniesGame(widget.list);
    }
    if (widget.title == 'Genres') {
      _loadGenresGame(widget.list);
    }
    if (widget.title == 'First Release Date') {
      _convertReleaseDate(widget.timestamp);
    }
  }

  //load the platforms
  Future<void> _loadPlatformsGame(List<dynamic> platformsIds) async {
    if (platformsIds.isEmpty) {
      setState(() {
        details = null;
        isLoading = false;
      });
      return;
    }

    final platforms = await GameApiService.fetchPlatforms(platformsIds);
    setState(() {
      details = platforms;
      isLoading = false;
    });
  }

  //load the companies of the game
  Future<void> _loadCompaniesGame(List<dynamic> involvedCompaniesIds) async {
    if (involvedCompaniesIds.isEmpty) {
      setState(() {
        details = null;
        isLoading = false;
      });
      return;
    }

    final companies = await GameApiService.fetchCompanies(involvedCompaniesIds);

    final List<dynamic> developersIds = [];
    final List<dynamic> publishersIds = [];
    for (var elem in companies!) {
      if (elem['developer'] == true) {
        developersIds.add(elem['company']);
      }
      if (elem['publisher'] == true) {
        publishersIds.add(elem['company']);
      }
    }

    //load developers of the game
    if (widget.title == 'Developers') {
      if (developersIds.isEmpty) {
        setState(() {
          details = null;
          isLoading = false;
        });
        return;
      }
      final developers =
          await GameApiService.fetchDevelopersOrPublishers(developersIds);
      setState(() {
        details = developers;
        isLoading = false;
      });
    }

    //load publishers of the game
    if (widget.title == 'Publishers') {
      if (publishersIds.isEmpty) {
        setState(() {
          details = null;
          isLoading = false;
        });
        return;
      }
      final publishers =
          await GameApiService.fetchDevelopersOrPublishers(publishersIds);
      setState(() {
        details = publishers;
        isLoading = false;
      });
    }
  }

  //load genres of the game
  Future<void> _loadGenresGame(List<dynamic> genresIds) async {
    if (genresIds.isEmpty) {
      setState(() {
        details = null;
        isLoading = false;
      });
      return;
    }

    final genres = await GameApiService.fetchGenres(genresIds);
    setState(() {
      details = genres;
      isLoading = false;
    });
  }

  //covert release date of the game
  Future<void> _convertReleaseDate(int unixTimestamp) async {
    if (unixTimestamp == 0) {
      setState(() {
        releaseDate = null;
        isLoading = false;
      });
      return;
    }
    setState(() {
      releaseDate = DateFormat('d MMMM yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000,
              isUtc: true));
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Opacity(
          opacity: 0,
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (!isLoading &&
        (widget.title == 'First Release Date' ||
            (details != null && details!.isNotEmpty))) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Title
            Text(
              '${widget.title}:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white38,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 7.5),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  children: [
                    //Platforms
                    if (widget.title == 'Platforms' && details != null)
                      ...details!.map((elem) => TextSpan(
                            text: elem['abbreviation'] != null
                                ? '${elem['abbreviation']}    '
                                : '${elem['name']}    ',
                          )),

                    //Developers
                    if (widget.title == 'Developers' && details != null)
                      ...details!.map((elem) => TextSpan(
                            text: '${elem['name']}    ',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                  context,
                                  '/series',
                                  arguments: {
                                    'gameIds': elem['developed'] ?? [],
                                    'title': 'Developed Games',
                                  },
                                );
                              },
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                          )),

                    //Publishers
                    if (widget.title == 'Publishers' && details != null)
                      ...details!.map((elem) => TextSpan(
                            text: '${elem['name']}    ',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                  context,
                                  '/series',
                                  arguments: {
                                    'gameIds': elem['published'] ?? [],
                                    'title': 'Published Games',
                                  },
                                );
                              },
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                          )),

                    //Genres
                    if (widget.title == 'Genres' && details != null)
                      ...details!.map((elem) => TextSpan(
                            text: '${elem['name']}    ',
                          )),

                    //First Release Date
                    if (widget.title == 'First Release Date')
                      TextSpan(
                        text: releaseDate != null ? '$releaseDate    ' : 'TBD',
                      ),
                  ],
                ),
                maxLines: null,
                softWrap: true,
              ),
            ),
            const SizedBox(height: 27.5),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
