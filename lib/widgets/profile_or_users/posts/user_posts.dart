import 'package:flutter/material.dart';
import 'package:gamerverse/models/post.dart';
import 'package:gamerverse/widgets/community/PostCardCommunity.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gamerverse/widgets/profile_or_users/posts/NewPostBottomSheet.dart';
import 'package:gamerverse/services/Community/post_service.dart';

class UserPosts extends StatefulWidget {
  final String userId; // ID dell'utente specifico
  final String? currentUser; // Utente corrente

  const UserPosts({
    super.key,
    required this.userId,
    required this.currentUser,
  });

  @override
  _UserPostsState createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  List<Post> posts = [];
  List<String> usernames = [];
  List<String> gamesNames = [];
  List<String> gamesCovers = [];
  String? currentUser;
  bool isLoading = true; // Variabile per gestire il caricamento

  // Metodo per recuperare i post dell'utente specifico
  Future<void> _getUserPosts() async {
    try {
      Map<String, dynamic> result =
      await PostService.GetPosts(false, widget.userId);

      if (result["success"] == true) {
        List<Post> postsList = (result["posts"] as List)
            .map((postJson) => Post.fromJson(postJson))
            .toList();

        List<String> usernamesList = (result["usernames"] as List<dynamic>)
            .map((username) => username as String? ?? "Deleted Account")
            .toList();

        List<String> gamesNamesList = (result["game_names"] as List<dynamic>)
            .map((gameName) => gameName as String? ?? "Unknown Game")
            .toList();

        List<String> gamesCoversList = (result["game_covers"] as List<dynamic>)
            .map((cover) => cover as String? ?? "")
            .toList();

        setState(() {
          posts = postsList;
          usernames = usernamesList;
          gamesNames = gamesNamesList;
          gamesCovers = gamesCoversList;
          isLoading = false; // Impostiamo isLoading a false quando i dati sono caricati
        });
      } else {
        print("Failed to fetch posts: ${result["message"]}");
        setState(() {
          isLoading = false; // Impostiamo isLoading a false se si verifica un errore
        });
      }
    } catch (e) {
      print("Error fetching user posts: $e");
      setState(() {
        isLoading = false; // Impostiamo isLoading a false in caso di errore
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserPosts(); // Recupera i post all'inizializzazione
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.teal),
      )
          : posts.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_drive_file, // Icona di una pagina o un documento
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'This user has not submitted any post',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final username = usernames[index];
          final gameName = gamesNames[index];
          final cover = gamesCovers[index];
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
            currentUser: widget.currentUser,
            username: username,
            gameName: gameName,
            gameCover: cover,
          );
        },
      ),
    );
  }
}
