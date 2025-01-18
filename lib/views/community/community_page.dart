import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_profile.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/posts/NewPostBottomSheet.dart';
import 'package:gamerverse/widgets/community/PostCardCommunity.dart';
import 'package:gamerverse/services/specific_game/wishlist_service.dart';
import 'package:gamerverse/services/Community/post_service.dart';
import 'package:gamerverse/models/post.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  WishlistService wishlistService = WishlistService();
  List<GameProfile> wishlistGames = [];
  List<Post> posts = [];
  List<String> usernames = [];
  List<String> gamesNames = [];
  List<String> gamesCovers = [];
  List<String> profilePictures = [];
  String? currentUser;
  bool isLoading = true;

  // Aggiungiamo queste variabili come variabili di stato
  List<int> likeCounts = [];
  List<int> commentCounts = [];
  List<List<String>> likeUsersList = [];

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
            .map(
                (postJson) => postJson != null ? Post.fromJson(postJson) : null)
            .where((post) => post != null)
            .cast<Post>()
            .toList();

        List<String> usernamesList = (result["usernames"] as List<dynamic>?)
                ?.map((username) => username != null && username is String
                    ? username
                    : "Deleted Account")
                .toList() ??
            [];

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

        List<String> profilePicturesList =
            (result["profile_pictures"] as List<dynamic>?)
                    ?.map((profilePicture) =>
                        profilePicture != null && profilePicture is String
                            ? profilePicture
                            : "")
                    .toList() ??
                [];

        // Otteniamo i like, commenti e gli utenti che mettono like
        List<List<String>> likeUsersListTemp =
            (result["like_users"] as List<dynamic>?)?.map((likeUsers) {
                  if (likeUsers is List<dynamic>) {
                    return likeUsers.map((user) {
                      // Verifica se user è una stringa, altrimenti metti una stringa vuota
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

        // Aggiorniamo lo stato con i dati recuperati
        setState(() {
          posts = postsList;
          usernames = usernamesList;
          gamesNames = gamesNamesList;
          gamesCovers = gamesCoversList;
          likeCounts = likeCountsTemp;
          commentCounts = commentCountsTemp;
          likeUsersList = likeUsersListTemp;
          profilePictures = profilePicturesList;
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
      appBar: AppBar(
        title: const Text('Community', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.darkGreen,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            onPressed: () {
              // Reindirizza alla pagina "AdvisedUser"
              Navigator.pushNamed(context, '/suggestedUsers');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  color: Colors
                      .teal)) // Mostra il caricamento durante il recupero dei post
          : posts.isEmpty
              ? NoDataList(
                  textColor: Colors.white,
                  icon: Icons.notifications_off,
                  message: 'No posts available!',
                  subMessage: 'Come back later for new updates.',
                  color: Colors.grey,
                )
              : ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final username = usernames[index];
                    final gameName = gamesNames[index];
                    final cover = gamesCovers[index];
                    final profilePicture = profilePictures[index];

                    return PostCard(
                      postId: post.id,
                      gameId: post.gameId,
                      userId: post.writerId,
                      content: post.description,
                      imageUrl: cover,
                      timestamp: post.timestamp,
                      likeCount: likeCounts[index],
                      commentCount: commentCounts[index],
                      likedBy: likeUsersList[index],
                      currentUser: currentUser,
                      username: username,
                      gameName: gameName,
                      gameCover: cover,
                      onPostDeleted: _updatePosts,
                      profilePicture: profilePicture,
                    );
                  },
                ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewPostBottomSheet(context);
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
