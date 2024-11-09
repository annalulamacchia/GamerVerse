import 'package:flutter/material.dart';

class FollowersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        title: const Text('Followers', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff163832),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
            child: Card(
              color: const Color(0xff000000), // Sfondo scuro della card
              elevation: 4, // Leggera ombra per il sollevamento
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Angoli arrotondati
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding interno per ridurre altezza
                leading: const CircleAvatar(child: Icon(Icons.person, color: Colors.white)),
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
                    // Azione per il bottone Follow
                  },
                  child: const Text('Follow', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
