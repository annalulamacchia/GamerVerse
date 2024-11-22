import 'package:flutter/material.dart';

// Importa i widget personalizzati dalla cartella widgets
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/user_info_card.dart';
import 'package:gamerverse/widgets/profile_or_users/profile_tab_bar.dart';
import 'package:gamerverse/widgets/profile_or_users/PostCardUser.dart';

class UserPostPage extends StatelessWidget {
  const UserPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20), // Sfondo scuro della pagina
      appBar: AppBar(
        title: const Text('Username', style: TextStyle(color: Colors.white)),
        // Sostituisci con il nome utente dinamico, se necessario
        backgroundColor: const Color(0xff163832),
        // Verde scuro per l'app bar
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'report') {
                // Naviga alla pagina di report
              } else if (value == 'block') {
                // Naviga alla pagina di blocco
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'report', child: Text('Report User')),
              const PopupMenuItem(value: 'block', child: Text('Block User')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const UserInfoCard(), // Scheda informazioni utente
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: TabBarSection(mode: 1, selected: 2), // Sezione Tab
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Numero dei post
              itemBuilder: (context, index) {
                return UserPostCard(
                  gameName: 'Game Name $index', // Nome dinamico del gioco
                  gameImageUrl:
                  'https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg', // URL immagine
                  description: 'Game description goes here for post $index...',
                  likeCount: 11, // Like iniziali
                  commentCount: 5, // Commenti iniziali
                  onLikePressed: () {
                    // Logica per il like
                  },
                  onCommentPressed: () {
                    Navigator.pushNamed(context, '/comments'); // Apri la pagina dei commenti
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
    );
  }

// Funzione per mostrare il Modal Bottom Sheet per creare un nuovo post
}
