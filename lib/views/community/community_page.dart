import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_profile.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/posts/NewPostBottomSheet.dart'; // Importa il nuovo widget NewPostBottomSheet
import 'package:gamerverse/widgets/community/PostCardCommunity.dart';
import 'package:gamerverse/services/specific_game/wishlist_service.dart';
import 'package:gamerverse/services/Community/post_service.dart'; // Importa il servizio Wishlist
import 'package:gamerverse/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  WishlistService wishlistService = WishlistService();
  List<GameProfile> wishlistGames = [];
  List<Post> Posts = [];
  List<String> Usernames = [];
  List<String> Games_Names = [];
  List<String> Games_Covers = [];
  String? currentUser;
  bool isLoading = true; // Variabile per il caricamento

  // Metodo per recuperare la wishlist
  Future<void> _getUserWishlist() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_uid');

      if (userId != null) {
        List<GameProfile> games = await WishlistService.getWishlist(userId);
        currentUser = userId;
        if (mounted) {
          setState(() {
            wishlistGames = games;
          });
        }
      } else {
        currentUser = null;
        print('User ID not found in SharedPreferences');
      }
    } catch (e) {
      print('Error fetching wishlist: $e');
    }
  }

  // Metodo per recuperare tutti i post
  Future<void> _getPosts() async {
    try {
      Map<String, dynamic> result = await PostService.GetPosts(true);
      print(result);

      if (result["success"] == true) {
        List<Post> postsList = (result["posts"] as List)
            .map((postJson) => postJson != null ? Post.fromJson(postJson) : null)
            .where((post) => post != null) // Remove null values
            .cast<Post>() // Cast the list back to List<Post>
            .toList();


        List<String> UsernamesList = (result["usernames"] as List<dynamic>?)
            ?.map((username) => username != null && username is String ? username : "Deleted Account")
            .toList() ?? []; // Returns an empty list if result["usernames"] is null

        List<String> gamesNameslist = (result["game_names"] as List<dynamic>?)
            ?.map((gameName) => gameName != null && gameName is String ? gameName : "Unknown Game")
            .toList() ?? []; // Returns an empty list if result["game_names"] is null

        List<String> gamesCoverslist = (result["game_covers"] as List<dynamic>?)
            ?.map((cover) => cover != null && cover is String ? cover : "")
            .toList() ?? []; // Returns an empty list if result["game_covers"] is null


        setState(() {
          Posts = postsList;
          Usernames = UsernamesList;
          Games_Names = gamesNameslist;
          Games_Covers = gamesCoverslist;
          isLoading = false; // Imposta isLoading a false quando i dati sono stati caricati
        });
      } else {
        print("Failed to fetch posts: ${result["message"]}");
        setState(() {
          isLoading = false; // Anche se la chiamata fallisce, imposta isLoading a false
        });
      }
    } catch (e) {
      print("Error fetching posts: $e");
      setState(() {
        isLoading = false; // Imposta isLoading a false in caso di errore
      });
    }
  }

  void _updatePosts() {
    _getPosts(); // Ricarica i post
  }

  @override
  void initState() {
    super.initState();
    _getUserWishlist();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        title: const Text('Community', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff163832),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(), // Mostra il caricamento durante il recupero dei post
      )
          : Posts.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline, // Icona di avviso
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'There are no posts to visualize, follow new users or add yourself a post for your followers.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: Posts.length,
        itemBuilder: (context, index) {
          final post = Posts[index];
          final username = Usernames[index];
          final gameName = Games_Names[index];
          final cover = Games_Covers[index];
          return PostCard(
            postId: post.id,
            gameId: post.gameId,
            userId: post.writerId,
            content: post.description,
            imageUrl: cover,
            timestamp: post.timestamp,
            likeCount: post.likes,
            commentCount: 5,
            onLikePressed: () {
              print('Liked Post: ${post.id}');
            },
            currentUser: currentUser,
            username: username,
            gameName: gameName,
            gameCover: cover,
            onPostDeleted: _updatePosts,
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewPostBottomSheet(context);
        },
        backgroundColor: const Color(0xff3e6259),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

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
          wishlistGames: wishlistGames,
          onPostCreated: (description, gameId) {
            _createPost(context, description, gameId);
          },
        );
      },
    );
  }

  Future<void> _createPost(BuildContext context, String description, String gameId) async {
    print('Creating post with description: $description and game ID: $gameId');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post creato con successo')),
    );
  }
}

