import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_profile.dart';
import 'package:gamerverse/widgets/profile_or_users/posts/NewPostBottomSheet.dart'; // Per creare nuovi post
import 'package:gamerverse/widgets/profile_or_users/posts/PostCardProfile.dart'; // Per mostrare i post
// Navbar
import 'package:gamerverse/services/specific_game/wishlist_service.dart'; // Per la wishlist
import 'package:gamerverse/services/Community/post_service.dart'; // Per i post
import 'package:gamerverse/models/post.dart'; // Modello Post
// Per leggere l'ID utente

class ProfilePosts extends StatefulWidget {
  final String userId; // ID dell'utente

  const ProfilePosts(
      {super.key, required this.userId}); // Richiediamo userId nel costruttore

  @override
  _ProfilePostPageState createState() => _ProfilePostPageState();
}

class _ProfilePostPageState extends State<ProfilePosts> {
  WishlistService wishlistService =
      WishlistService(); // Servizio per la wishlist
  List<GameProfile> wishlistGames = []; // Lista dei giochi nella wishlist
  List<Post> userPosts = []; // Lista dei post dell'utente

  @override
  void initState() {
    super.initState();
    _fetchData(); // Recuperiamo dati al caricamento della pagina
  }

  // Metodo per caricare sia wishlist che post
  Future<void> _fetchData() async {
    await _getUserWishlist();
    await _getUserPosts();
  }

  // Recupero wishlist dell'utente
  Future<void> _getUserWishlist() async {
    try {
      List<GameProfile> games =
          await WishlistService.getWishlist(widget.userId);
      setState(() {
        wishlistGames = games; // Aggiorniamo la wishlist
      });
    } catch (e) {
      print('Errore nel caricamento della wishlist: $e');
    }
  }

  // Recupero post dell'utente
  Future<void> _getUserPosts() async {
    try {
      Map<String, dynamic> result = await PostService.GetPosts();
      if (result["success"] == true) {
        List<Post> postsList = (result["posts"] as List)
            .map((postJson) => Post.fromJson(postJson))
            .where(
                (post) => post.writerId == widget.userId) // Filtra per userId
            .toList();

        setState(() {
          userPosts = postsList; // Aggiorniamo i post
        });
      } else {
        print("Errore nel caricamento dei post: ${result["message"]}");
      }
    } catch (e) {
      print("Errore nel caricamento dei post: $e");
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      body: Column(
        children: [
          Expanded(
            child: userPosts.isEmpty
                ? Center()
                : ListView.builder(
                    itemCount: userPosts.length,
                    itemBuilder: (context, index) {
                      final post = userPosts[index];
                      return PostCard(
                        userId: post.writerId,
                        // Autore
                        gameId: post.gameId,
                        // ID gioco
                        description: post.description,
                        // Contenuto
                        likeCount: post.likes,
                        // Like
                        commentCount: 5,
                        // Commenti (placeholder)
                        timestamp: post.timestamp,
                        // Data
                        onCommentPressed: () {
                          // Logica per i commenti
                          Navigator.pushNamed(
                            context,
                            '/comments',
                            arguments: post.id,
                          );
                        },
                        onDeletePressed: () {
                          // Logica per eliminare il post
                          print('Post eliminato: ${post.id}');
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Apri il Bottom Sheet per creare un post
          _showNewPostBottomSheet(context);
        },
        backgroundColor: const Color(0xff3e6259),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Funzione per mostrare il Bottom Sheet per creare un post
  void _showNewPostBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: const Color(0xff051f20),
      builder: (BuildContext context) {
        return NewPostBottomSheet(
          wishlistGames: wishlistGames, // Passa la wishlist
          onPostCreated: (description, gameId) {
            _createPost(context, description, gameId); // Crea un nuovo post
          },
        );
      },
    );
  }

  // Funzione per creare un post
  Future<void> _createPost(
      BuildContext context, String description, String gameId) async {
    try {
      Map<String, dynamic> result =
          await PostService.sendPost(description, gameId);
      if (result["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post creato con successo')),
        );
        await _getUserPosts(); // Aggiorniamo la lista dei post
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: ${result["message"]}')),
        );
      }
    } catch (e) {
      print("Errore nella creazione del post: $e");
    }
  }
}
