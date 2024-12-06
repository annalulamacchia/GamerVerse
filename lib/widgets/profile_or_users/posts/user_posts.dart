import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/profile_or_users/posts/PostCardProfile.dart';

class UserPosts extends StatelessWidget {
  final String userId; // Aggiunto userId come parametro obbligatorio
  final String? currentUser;

  const UserPosts(
      {super.key,
      required this.userId,
      required this.currentUser}); // Il costruttore ora richiede userId

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
                return PostCard(
                  userId: "w",
                  // Autore
                  gameId: "we",
                  // ID gioco
                  description: "ee",
                  // Contenuto
                  likeCount: 2,
                  // Like
                  commentCount: 5,
                  // Commenti (placeholder)
                  timestamp: "ss",
                  // Data
                  onCommentPressed: () {
                    // Logica per i commenti
                    Navigator.pushNamed(
                      context,
                      '/comments',
                      arguments: "d",
                    );
                  },
                  postId: "c",
                  onDeletePressed: () {
                    // Logica per eliminare il post
                    print('Post eliminato: ${22}');
                  },
                  currentUser: "c",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
