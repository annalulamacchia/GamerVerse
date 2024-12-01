import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/profile_or_users/profile_info_card.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/profile_tab_bar.dart';
import 'package:gamerverse/widgets/profile_or_users/NewPostBottomSheet.dart'; // Importa il nuovo widget NewPostBottomSheet
import 'package:gamerverse/widgets/profile_or_users/PostCardProfile.dart'; // Importa il nuovo widget PostCardProfile
import 'package:gamerverse/services/Community/post_service.dart';
import 'package:gamerverse/models/game.dart'; // Importa il modello Game
import 'package:intl/intl.dart'; // Per formattazione della data

class ProfilePostPage extends StatefulWidget {
  const ProfilePostPage({super.key});

  @override
  _ProfilePostPageState createState() => _ProfilePostPageState();
}

class _ProfilePostPageState extends State<ProfilePostPage> {
  final int _likeCount = 11;
  final int _commentCount = 5;

  Future<List<Game>> _getUserWishlist() async {
    // Logica per recuperare la wishlist dell'utente (al momento vuota per esempio)
    return [];
  }

  Future<List<Map<String, dynamic>>> _getUserPosts() async {
    final result = await PostService.GetPosts(); // Recupera i post dal backend
    if (result["success"]) {
      final posts = List<Map<String, dynamic>>.from(result["posts"]);
      // Ordina i post per timestamp dal più recente al più vecchio
      posts.sort((a, b) {
        final dateA = DateTime.parse(a["timestamp"]);
        final dateB = DateTime.parse(b["timestamp"]);
        return dateB.compareTo(dateA);
      });
      return posts;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        title: const Text('Username', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff163832),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
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
          ),
          const TabBarSection(mode: 0, selected: 2),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>( // Recupero dei post utente
              future: _getUserPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error loading posts"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No posts available"));
                }

                final posts = snapshot.data!;

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final timestamp = DateFormat('yyyy-MM-dd HH:mm').format(
                      DateTime.parse(post["timestamp"]),
                    );

                    return PostCard(
                      userId: post["writer_id"],
                      gameId: post["game_id"],
                      description: post["description"],
                      likeCount: post["likes"],
                      commentCount: 5,
                      timestamp: timestamp,
                      onCommentPressed: () {
                        Navigator.pushNamed(context, '/comments', arguments: post["id"]);
                      },
                      onDeletePressed: () {
                        setState(() {
                          // Logica per eliminare il post
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<Game> wishlistGames = await _getUserWishlist(); // Recupera la wishlist
          _showNewPostBottomSheet(context, wishlistGames); // Passa la wishlist al bottom sheet
        },
        backgroundColor: const Color(0xff3e6259),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showNewPostBottomSheet(BuildContext context, List<Game> wishlistGames) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: const Color(0xff051f20),
      builder: (BuildContext context) {
        return NewPostBottomSheet(
          wishlistGames: wishlistGames,
          onPostCreated: (description, gameId) {
            _createPost(context, description, gameId); // Chiamata alla funzione di creazione post
          },
        );
      },
    );
  }

  Future<void> _createPost(BuildContext context, String description, String gameId) async {
    final result = await PostService.sendPost(description, gameId);

    if (result["success"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post creato con successo')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: ${result["message"]}')),
      );
    }
  }
}
