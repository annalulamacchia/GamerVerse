import 'package:flutter/material.dart';
import 'package:gamerverse/services/gameApiService.dart';

class SpecificGameSectionWidget extends StatefulWidget {
  final String title;
  final List<dynamic> collections;
  final String storyline;

  const SpecificGameSectionWidget({
    super.key,
    required this.title,
    required this.collections,
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
                  widget.storyline,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              )),
        );
      },
    );
  }

  bool isLoading = true;
  List<Map<String, dynamic>>? collectionsGame;

  @override
  void initState() {
    super.initState();
    if (widget.title == 'Series' && widget.collections.isNotEmpty) {
      _loadCollections();
    }
    isLoading = false;
  }

  //load the collections of the game
  Future<void> _loadCollections() async {
    final coll = await GameApiService.fetchCollections(widget.collections);
    setState(() {
      collectionsGame = coll;
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
                  ? const Center(child: CircularProgressIndicator())
                  : Navigator.pushNamed(context, '/series',
                      arguments: collectionsGame);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xff3e6259),
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
      ],
    );
  }
}
