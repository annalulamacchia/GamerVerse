import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gamerverse/services/game_api_service.dart';
import 'package:gamerverse/utils/colors.dart';

class SpecificGameSectionWidget extends StatefulWidget {
  final String title;
  final List<dynamic> games;
  final String storyline;

  const SpecificGameSectionWidget({
    super.key,
    required this.title,
    required this.games,
    required this.storyline,
  });

  @override
  SpecificGameSectionWidgetState createState() =>
      SpecificGameSectionWidgetState();
}

class SpecificGameSectionWidgetState extends State<SpecificGameSectionWidget> {
  //function to show bottom pop up if title == 'Storyline'
  void showSpecificGamePopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              height: 250,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  utf8.decode(widget.storyline.codeUnits),
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              )),
        );
      },
    );
  }

  bool isLoading = true;
  List<dynamic>? gameIds;

  @override
  void initState() {
    super.initState();
    if (widget.title == 'Series' && widget.games.isNotEmpty) {
      _loadCollections();
      isLoading = false;
    }
  }

  //load the collections of the game
  Future<void> _loadCollections() async {
    if (widget.games.isEmpty) {
      setState(() {
        gameIds = [];
        isLoading = false;
      });
      return;
    }

    final coll = await GameApiService.fetchCollections(widget.games);

    final games = [];
    for (var collection in coll!) {
      List<dynamic> currentGameIds = List<dynamic>.from(collection['games']);
      games.addAll(currentGameIds);
    }

    games.sort();

    setState(() {
      gameIds = games;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (widget.title == 'Storyline') {
              showSpecificGamePopup(context);
            } else {
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.teal))
                  : Navigator.pushNamed(
                      context,
                      '/series',
                      arguments: {
                        'gameIds': gameIds ?? [],
                        'title': 'Series',
                      },
                    );
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 7.5),
            padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.mediumGreen,
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        if (widget.storyline != "") const SizedBox(height: 20),
      ],
    );
  }
}
