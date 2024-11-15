import 'package:flutter/material.dart';
import 'package:gamerverse/views/specific_game/series_games.dart';

class SpecificGameSectionWidget extends StatefulWidget {
  final String title; // Titolo dinamico

  const SpecificGameSectionWidget({super.key, required this.title});

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
              child: const Text(
                'Questa è la storyline completa del gioco. '
                'Può essere un testo di più righe che descrive la trama in dettaglio.',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              )),
        );
      },
    );
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SeriesGame(),
                ),
              );
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
