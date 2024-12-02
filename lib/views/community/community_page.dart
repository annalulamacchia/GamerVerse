import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/NewPostBottomSheet.dart'; // Importa il nuovo widget NewPostBottomSheet
import 'package:gamerverse/widgets/common_sections/report_user.dart';
import 'package:gamerverse/widgets/common_sections/report.dart';
import 'package:gamerverse/widgets/community/PostCardCommunity.dart';
import 'package:gamerverse/services/specific_game/wishlist_service.dart';
import 'package:gamerverse/services/Community/post_service.dart';// Importa il servizio Wishlist
import 'package:gamerverse/models/game.dart'; // Assicurati di avere il modello Game importato
import 'package:gamerverse/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  WishlistService wishlistService = WishlistService();
  List<Game> wishlistGames = []; // Lista di giochi nella wishlist
  List<Post> Posts = [];
  // Metodo per recuperare la wishlist

  Future<void> _getUserWishlist() async {
    try {
      // Recupera l'ID utente da SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_uid'); // Recupera l'ID dell'utente

      if (userId != null) {
        // Recupera la lista dei giochi dalla wishlist usando il servizio
        List<Game> games = await WishlistService.getWishlist(userId);
        if (mounted) {
          // Controlla che il widget sia ancora montato
          setState(() {
            wishlistGames = games;
          });
        }
      } else {
        print('User ID not found in SharedPreferences');
      }
    } catch (e) {
      print('Error fetching wishlist: $e');
    }
  }

  Future<void> _getPosts() async {
    try {
      // Chiama la funzione GetPosts dal servizio
      Map<String, dynamic> result = await PostService.GetPosts();

      // Verifica se la risposta è positiva
      if (result["success"] == true) {
        // Mappa i post in oggetti Post
        List<Post> postsList = (result["posts"] as List)
            .map((postJson) => Post.fromJson(postJson))
            .toList();

        setState(() {
          Posts = postsList; // Salva i post mappati nella lista
        });
      } else {
        print("Failed to fetch posts: ${result["message"]}");
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }


  @override
  void initState() {
    super.initState();
    _getUserWishlist();
    _getPosts();// Recupera la wishlist dell'utente al momento dell'inizializzazione
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        title: const Text('Community', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff163832),
      ),
      body: Posts.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Mostra un caricamento finché i post non sono disponibili
          : ListView.builder(
        itemCount: Posts.length, // Numero di post
        itemBuilder: (context, index) {
          final post = Posts[index];
          return PostCard(
            gameId: post.gameId, // Assicurati che GameName sia correttamente mappato
            userId: post.writerId, // Mostra lo writerId come autore
            content: post.description, // Passa la descrizione del post
            imageUrl: '', // Aggiungi un URL immagine appropriato
            timestamp: post.timestamp, // Puoi calcolare un timestamp dinamico
            likeCount: post.likes,
            commentCount: 5, // Puoi aggiungere la logica per contare i commenti
            onLikePressed: () {
              // Logica per il like
              print('Liked Post: ${post.id}');
            },
            onCommentPressed: () {
              // Logica per il commento
              print('Commented Post: ${post.id}');
            },
            onReportUserPressed: () {
              // Logica per report dell'utente
              print('Reported User: ${post.writerId}');
            },
            onReportPostPressed: () {
              // Logica per report del post
              print('Reported Post: ${post.id}');
            },
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 0, // Seleziona 'Home' per questa pagina
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewPostBottomSheet(context); // Mostra il bottom sheet per il nuovo post
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
        return NewPostBottomSheet(
          wishlistGames: wishlistGames, // Passa la lista di giochi alla bottom sheet
          onPostCreated: (description, gameId) {
            _createPost(context, description, gameId); // Gestisci la creazione del post
          },
        );
      },
    );
  }

  // Funzione per inviare i dati del post al backend
  Future<void> _createPost(BuildContext context, String description, String gameId) async {
    // Logica per inviare il nuovo post
    print('Creating post with description: $description and game ID: $gameId');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post creato con successo')),
    );
  }

  // Funzione per mostrare un dialog di report dell'utente
  void _showReportUserDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return const ReportUserWidget();
        });
  }

  // Funzione per mostrare un dialog di report del post
  void _showReportPostDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return const ReportWidget();
        });
  }


}


