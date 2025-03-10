import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_profile.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/profile_or_users/posts/NewPostBottomSheet.dart';
import 'package:gamerverse/services/specific_game/wishlist_service.dart';
import 'package:gamerverse/services/Community/post_service.dart';
import 'package:gamerverse/models/post.dart';
import 'package:gamerverse/widgets/profile_or_users/posts/PostCardProfile.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';
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
  List<Post> posts = [];
  List<String> gamesNames = [];
  List<String> gamesCovers = [];
  String? currentUser;
  bool isLoading = true; // Variabile per gestire il caricamento
  List<int> likeCounts = [];
  List<int> commentCounts = [];
  List<List<String>> likeUsersList = [];

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
      print(result);

      if (result["success"] == true) {
        List<Post> postsList = (result["posts"] as List)
            .map(
                (postJson) => postJson != null ? Post.fromJson(postJson) : null)
            .where((post) => post != null)
            .cast<Post>()
            .toList();

        List<String> gamesNamesList = (result["game_names"] as List<dynamic>?)
                ?.map((gameName) => gameName != null && gameName is String
                    ? gameName
                    : "Unknown Game")
                .toList() ??
            [];

        List<String> gamesCoversList = (result["game_covers"] as List<dynamic>?)
                ?.map((cover) => cover != null && cover is String ? cover : "")
                .toList() ??
            [];

        // Aggiungi i dati relativi ai like, commenti e utenti che mettono like
        List<List<String>> likeUsersListTemp =
            (result["like_users"] as List<dynamic>?)?.map((likeUsers) {
                  if (likeUsers is List<dynamic>) {
                    return likeUsers.map((user) {
                      return user is String ? user : '';
                    }).toList();
                  } else {
                    return <String>[]; // Restituisci una lista vuota se likeUsers non è una lista
                  }
                }).toList() ??
                [];

        List<int> likeCountsTemp = (result["like_counts"] as List<dynamic>?)
                ?.map((likeCount) =>
                    likeCount != null && likeCount is int ? likeCount : 0)
                .toList() ??
            [];

        List<int> commentCountsTemp =
            (result["comment_counts"] as List<dynamic>?)
                    ?.map((commentCount) =>
                        commentCount != null && commentCount is int
                            ? commentCount
                            : 0)
                    .toList() ??
                [];

        setState(() {
          posts = postsList;
          gamesNames = gamesNamesList;
          gamesCovers = gamesCoversList;
          likeCounts = likeCountsTemp;
          commentCounts = commentCountsTemp;
          likeUsersList = likeUsersListTemp;
          isLoading = false;
        });
      } else {
        print("Failed to fetch posts: ${result["message"]}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching posts: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updatePosts() {
    _getPosts(); // Ricarica i post
  }

  // Funzione per eliminare un post

  @override
  void initState() {
    super.initState();
    _getUserWishlist();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            )
          : posts.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    NoDataList(
                      textColor: Colors.white,
                      icon: Icons.notifications_off_outlined,
                      message: 'No posts available!',
                      subMessage: 'Come back later for new updates.',
                      color: Colors.grey,
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final gameName = gamesNames[index];
                    final cover = gamesCovers[index];

                    final commentCount =
                        commentCounts.isNotEmpty ? commentCounts[index] : 0;
                    final likeCount =
                        likeCounts.isNotEmpty ? likeCounts[index] : 0;
                    final likedBy =
                        likeUsersList.isNotEmpty ? likeUsersList[index] : [];

                    return PostCard(
                        postId: post.id,
                        gameId: post.gameId,
                        userId: post.writerId,
                        content: post.description,
                        timestamp: post.timestamp,
                        likeCount: likeCount,
                        commentCount: commentCount,
                        likedBy: likedBy,
                        currentUser: currentUser,
                        gameName: gameName,
                        gameCover: cover,
                        onPostDeleted: _updatePosts);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewPostBottomSheet(
              context); // Mostra il modal per creare un nuovo post
        },
        backgroundColor: AppColors.mediumGreen,
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
      backgroundColor: Colors.grey[900],
      builder: (BuildContext context) {
        return NewPostBottomSheet(
          wishlistGames: wishlistGames,
          onPostCreated: (description, gameId) {
            _createPost(context, description, gameId);
          },
          onCreated: _updatePosts,
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
