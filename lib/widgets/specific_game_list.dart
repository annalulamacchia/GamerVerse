import 'package:flutter/material.dart';

// Widget per visualizzare la lista dei developers
class SpecificGameList extends StatelessWidget {
  final List<String> list; // Lista di sviluppatori da passare
  final String title;

  // Costruttore per ricevere la lista di developers
  const SpecificGameList({super.key, required this.title, required this.list});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white, // Colore di base del testo
        ),
        children: [
          // Parte fissa
          TextSpan(
            text: '$title:  ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          // Nomi dei developer dinamici
          for (var elem in list)
            TextSpan(
              text: '$elem    ',
            ),
        ]
        ,
      ),
    );
  }
}

