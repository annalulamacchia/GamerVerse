import 'package:flutter/material.dart';

// Importa i widget personalizzati dalla cartella widgets
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/user_info_card.dart';
import 'package:gamerverse/widgets/profile_or_users/profile_tab_bar.dart';
import 'package:gamerverse/widgets/profile_or_users/PostCardUser.dart';

class UserPosts extends StatelessWidget {
  final String userId; // Aggiunto userId come parametro obbligatorio

  const UserPosts({super.key, required this.userId}); // Il costruttore ora richiede userId

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20), // Sfondo scuro della pagina
      body: Column(
        children: [
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
    );
  }
}
