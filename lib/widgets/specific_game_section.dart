import 'package:flutter/material.dart';

class SpecificGameSectionWidget extends StatefulWidget {
  final String title; // Titolo dinamico

  const SpecificGameSectionWidget({super.key, required this.title});

  @override
  SpecificGameSectionWidgetState createState() => SpecificGameSectionWidgetState();
}

class SpecificGameSectionWidgetState extends State<SpecificGameSectionWidget> {
  // Funzione per mostrare il pop-up a discesa
  void showSpecificGamePopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 250,
            padding: const EdgeInsets.all(12),
            child: const Text(
              'Questa è la storyline completa del gioco. '
                  'Può essere un testo di più righe che descrive la trama in dettaglio.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Barra con testo e freccia
        InkWell(
          onTap: () {
            // Mostra il pop-up a discesa
            showSpecificGamePopup(context);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 16),
                ),
                Icon(
                  Icons.keyboard_arrow_right_outlined, // Mostra sempre la freccia verso il basso
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}