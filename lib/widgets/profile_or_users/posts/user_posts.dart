import 'package:flutter/material.dart';
import 'package:gamerverse/models/post.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/profile_or_users/posts/PostCardProfile.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gamerverse/services/Community/post_service.dart';

class UserPosts extends StatefulWidget {
  final String userId; // ID dell'utente specifico
  final String? currentUser; // Utente corrente
  final ValueNotifier<bool>? blockedNotifier;

  const UserPosts({
    super.key,
    required this.userId,
    required this.currentUser,
    this.blockedNotifier,
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
  List<int> likeCounts = [];
  List<int> commentCounts = [];
  List<List<String>> likeUsersList = [];

  // Metodo per recuperare i post dell'utente specifico
  Future<void> _getUserPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('user_uid');

    if (userId != null) {
      currentUser = userId;
    } else {
      currentUser = null;
      print('User ID not found in SharedPreferences');
    }
    try {
      Map<String, dynamic> result =
          await PostService.GetPosts(false, widget.userId);
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
          usernames = usernamesList;
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

  @override
  void initState() {
    super.initState();
    _getUserPosts(); // Recupera i post all'inizializzazione
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      body: widget.blockedNotifier != null
          ? ValueListenableBuilder<bool>(
              valueListenable: widget.blockedNotifier!,
              builder: (context, isBlocked, child) {
                if (isBlocked) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      NoDataList(
                        textColor: Colors.white,
                        icon: Icons.notifications_off_outlined,
                        message: 'The user is blocked!',
                        subMessage: 'Please unblock to see their posts',
                        color: Colors.grey[500]!,
                      ),
                    ],
                  );
                }

                // Se l'utente non è bloccato, mostra i post
                return isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.teal),
                      )
                    : posts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                NoDataList(
                                  textColor: Colors.white,
                                  icon: Icons.notifications_off_outlined,
                                  message: 'No posts available!',
                                  subMessage:
                                      'Come back later for new updates.',
                                  color: Colors.grey[500]!,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              final gameName = gamesNames[index];
                              final cover = gamesCovers[index];

                              final commentCount = commentCounts.isNotEmpty
                                  ? commentCounts[index]
                                  : 0;
                              final likeCount =
                                  likeCounts.isNotEmpty ? likeCounts[index] : 0;
                              final likedBy = likeUsersList.isNotEmpty
                                  ? likeUsersList[index]
                                  : [];

                              return PostCard(
                                postId: post.id,
                                gameId: post.gameId,
                                userId: post.writerId,
                                content: post.description,
                                gameCover: cover,
                                timestamp: post.timestamp,
                                likeCount: likeCount,
                                commentCount: commentCount,
                                likedBy: likedBy,
                                currentUser: currentUser,
                                gameName: gameName,
                              );
                            },
                          );
              },
            )
          : isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.teal),
                )
              : posts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          NoDataList(
                            textColor: Colors.white,
                            icon: Icons.notifications_off_outlined,
                            message: 'No posts available!',
                            subMessage: 'Come back later for new updates.',
                            color: Colors.grey[500]!,
                          ),
                        ],
                      ),
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
                        final likedBy = likeUsersList.isNotEmpty
                            ? likeUsersList[index]
                            : [];

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
                        );
                      },
                    ),
    );
  }
}
