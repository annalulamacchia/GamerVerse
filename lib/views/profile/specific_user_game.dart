import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_post.dart';
import 'package:gamerverse/models/game_profile.dart';
import 'package:gamerverse/services/Community/post_service.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/profile_or_users/posts/post_user_game.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';
import 'package:intl/intl.dart';

class SpecificUserGame extends StatefulWidget {
  final GameProfile game;
  final String currentUser;
  final String userId;

  const SpecificUserGame(
      {super.key,
      required this.game,
      required this.currentUser,
      required this.userId});

  @override
  SpecificUserGameState createState() => SpecificUserGameState();
}

class SpecificUserGameState extends State<SpecificUserGame> {
  late Future<List<GamePost>> postsFuture;

  @override
  void initState() {
    super.initState();
    _loadPostsByGame();
  }

  Future<void> _loadPostsByGame() async {
    setState(() {
      postsFuture = PostService.getPostsByGame(
          userId: widget.currentUser, gameId: widget.game.gameId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.game.gameName,
            style: const TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Game Image
          Container(
            height: 200,
            color: Colors.grey[300],
            child: Image.network(
              widget.game.cover,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),

          // Game Status and Timestamp
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.game.status != '')
                  Text(
                    '${widget.game.status[0].toUpperCase() + widget.game.status.substring(1).toLowerCase()} since: ${DateFormat('d MMMM yyyy').format(DateTime.parse(widget.game.timestamp).toLocal())}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (widget.game.status == '')
                  Text(
                    'Liked since: ${DateFormat('d MMMM yyyy').format(DateTime.parse(widget.game.timestamp).toLocal())}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          const Divider(color: Colors.white24, thickness: 1),

          // More Details
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/game',
                  arguments: int.parse(widget.game.gameId));
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'More Details on the Game',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Icon(Icons.keyboard_arrow_right,
                      color: Colors.white, size: 25),
                ],
              ),
            ),
          ),

          // Post section
          FutureBuilder<List<GamePost>>(
            future: postsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.teal));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return NoDataList(
                  textColor: Colors.white,
                  icon: Icons.notifications_off,
                  message: 'No posts available!',
                  subMessage: 'Come back later for new updates.',
                  color: Colors.grey,
                );
              } else {
                final posts = snapshot.data!;

                return Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return UserPost(
                        postId: post.postId,
                        userId: post.writerId,
                        content: post.description,
                        imageUrl: post.profilePicture,
                        timestamp: post.timestamp,
                        likeCount: post.likes.length,
                        commentCount: post.commentsCount,
                        likedBy: post.likes,
                        currentUser: widget.currentUser,
                        username: post.username,
                        onPostDeleted: _loadPostsByGame,
                      );
                    },
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 2,
      ),
    );
  }
}
