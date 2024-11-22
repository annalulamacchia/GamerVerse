import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/profile_or_users/profile_info_card.dart';

// Importa i widget personalizzati dalla cartella widgets
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/profile_tab_bar.dart';
import 'package:gamerverse/widgets/profile_or_users/NewPostBottomSheet.dart'; // Importa il nuovo widget NewPostBottomSheet
import 'package:gamerverse/widgets/profile_or_users/PostCardProfile.dart'; // Importa il nuovo widget NewPostBottomSheet


class ProfilePostPage extends StatefulWidget {
  const ProfilePostPage({super.key});

  @override
  _ProfilePostPageState createState() => _ProfilePostPageState();
}

class _ProfilePostPageState extends State<ProfilePostPage> {
  // Puoi aggiungere variabili di stato qui
  int _likeCount = 11;
  final int _commentCount = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      // Sfondo scuro della pagina
      appBar: AppBar(
        title: const Text('Username', style: TextStyle(color: Colors.white)),
        // Sostituisci con il nome utente dinamico, se necessario
        backgroundColor: const Color(0xff163832),
        // Verde scuro per l'app bar
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), // Icona a forma di ingranaggio
            onPressed: () {
              Navigator.pushNamed(context, '/profileSettings');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const ProfileInfoCard(), // Scheda informazioni utente
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            // Sezione Tab
          ),
          const TabBarSection(mode: 0, selected: 2),
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Numero dei post
              itemBuilder: (context, index) {
                return PostCard(
                  gameName: 'Game Name $index', // Nome dinamico del gioco
                  gameImageUrl: 'https://via.placeholder.com/90', // URL immagine
                  description: 'Descrizione dinamica del gioco $index...', // Descrizione dinamica
                  likeCount: 11, // Like iniziali
                  commentCount: 5, // Commenti iniziali
                  onCommentPressed: () {
                    Navigator.pushNamed(context, '/comments'); // Apri la pagina dei commenti
                  },
                  onDeletePressed: () {
                    setState(() {
                      // Logica per eliminare il post
                    });
                  },
                );
              },
            ),
          ),

        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1, // Seleziona 'Home' per questa pagina
        isLoggedIn: true, // Sostituisci con lo stato di accesso effettivo
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewPostBottomSheet(
              context); // Mostra il bottom sheet per il nuovo post
        },
        backgroundColor: const Color(0xff3e6259),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Funzione per mostrare il Modal Bottom Sheet per creare un nuovo post
  void _showNewPostBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: const Color(0xff051f20),
      builder: (BuildContext context) {
        return NewPostBottomSheet(); // Usa il nuovo widget NewPostBottomSheet
      },
    );
  }
}
