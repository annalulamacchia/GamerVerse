// user_follower_card.dart

import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final int index; // Indice dell'utente
  final VoidCallback onTap; // Funzione per la navigazione

  const UserCard({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Card(
        color: const Color(0xff000000), // Sfondo scuro della card
        elevation: 4, // Ombra per l'altezza della card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Bordi arrotondati
        ),
        child: GestureDetector(
          onTap: onTap, // Funzione che viene chiamata quando si tocca la card
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: const CircleAvatar(
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              'User $index',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF14A129),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () {
                // Aggiungi azione per il bottone Follow, se necessario
              },
              child: const Text('Follow', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}
