// new_post_bottom_sheet.dart

import 'package:flutter/material.dart';

class NewPostBottomSheet extends StatelessWidget {
  final List<String> gameOptions = ['Game 1', 'Game 2', 'Game 3']; // Opzioni del menu a discesa per il campo "Game"

  @override
  Widget build(BuildContext context) {
    String? selectedGame;

    return Padding(
      padding: EdgeInsets.only(
        bottom: 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'New Post',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          // Dropdown menu per il campo "Game"
          DropdownButtonFormField<String>(
            value: selectedGame,
            items: gameOptions.map((String game) {
              return DropdownMenuItem<String>(
                value: game,
                child: Text(game, style: TextStyle(color: Colors.grey[800])),
              );
            }).toList(),
            onChanged: (newValue) {
              selectedGame = newValue; // Aggiorna il valore selezionato
            },
            decoration: InputDecoration(
              labelText: 'Game',
              filled: true,
              fillColor: const Color(0xffe6f2ed),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              labelStyle: TextStyle(color: Colors.grey[800]),
            ),
          ),

          const SizedBox(height: 20),

          // Campo di testo per la descrizione
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Description',
              filled: true,
              fillColor: const Color(0xffe6f2ed),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              labelStyle: TextStyle(color: Colors.grey[800]),
              hintText: 'Add a description of your post...',
              hintStyle: TextStyle(color: Colors.grey[600]),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
            ),
            onPressed: () {
              // Logica per salvare il post
              Navigator.of(context).pop(); // Chiude il bottom sheet
            },
            child: const Text('Post', style: TextStyle(color: Colors.white,fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
