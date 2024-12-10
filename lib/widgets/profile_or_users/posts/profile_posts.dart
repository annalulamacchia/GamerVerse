import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_profile.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/posts/NewPostBottomSheet.dart';
import 'package:gamerverse/widgets/community/PostCardCommunity.dart';
import 'package:gamerverse/services/specific_game/wishlist_service.dart';
import 'package:gamerverse/services/Community/post_service.dart';
import 'package:gamerverse/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePosts extends StatefulWidget {
  final String userId; // ID dell'utente
  final String? currentUser;

  const ProfilePosts({
    super.key,
    required this.userId,
    required this.currentUser,
  });


  @override
  _ProfilePostsState createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  WishlistService wishlistService = WishlistService();
  List<GameProfile> wishlistGames = [];
  List<Post> Posts = [];
  List<String> Usernames = [];
  List<String> Games_Names = [];
  List<String> Games_Covers = [];
  String? currentUser;

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

  Future<void> _getPosts() async {
    try {
      Map<String, dynamic> result = await PostService.GetPosts(false);
      if (result["success"] == true) {
        List<Post> postsList = (result["posts"] as List)
            .map((postJson) => Post.fromJson(postJson))
            .where((post) => post.writerId == currentUser)
            .toList();

        List<String> UsernamesList = (result["usernames"] as List<dynamic>)
            .map((username) => username as String? ?? "Deleted Account")
            .toList();

        List<String> Games_NamesList = (result["game_names"] as List<dynamic>)
            .map((gameName) => gameName as String? ?? "Unknown Game")
            .toList();

        List<String> Games_CoversList = (result["game_covers"] as List<dynamic>)
            .map((cover) => cover as String? ?? "")
            .toList();

        setState(() {
          Posts = postsList;
          Usernames = UsernamesList;
          Games_Names = Games_NamesList;
          Games_Covers = Games_CoversList;
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
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      body: Posts.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
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
          );
        },
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

  Future<void> _createPost(
      BuildContext context, String description, String gameId) async {
    print('Creating post with description: $description and game ID: $gameId');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post creato con successo')),
    );
  }
}
