import 'package:flutter/material.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/common_sections/report_menu.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:gamerverse/services/Community/post_service.dart';
import 'package:gamerverse/widgets/community/likeButton.dart';

class PostCard extends StatefulWidget {
  final String postId;
  final String userId;
  final String gameId;
  final String content;
  final String imageUrl;
  final String timestamp;
  final int likeCount;
  final int commentCount;
  final List<dynamic> likedBy; // Lista degli utenti che hanno messo like
  final String? currentUser;
  final String username;
  final String gameName;
  final String gameCover;
  final VoidCallback? onPostDeleted;
  final String profilePicture;

  const PostCard({
    super.key,
    required this.postId,
    required this.userId,
    required this.gameId,
    required this.content,
    required this.imageUrl,
    required this.timestamp,
    required this.likeCount,
    required this.commentCount,
    required this.likedBy, // Passa likedBy qui
    required this.currentUser,
    required this.username,
    required this.gameName,
    required this.gameCover,
    this.onPostDeleted,
    required this.profilePicture,
  });

  @override
  PostCardState createState() => PostCardState();
}

class PostCardState extends State<PostCard> {
  bool _isExpanded = false;
  bool _isDeleting = false;
  final ValueNotifier<int> commentNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    commentNotifier.value = widget.commentCount;
  }

  @override
  void dispose() {
    commentNotifier.dispose();
    super.dispose();
  }

  void _deletePost() async {
    setState(() {
      _isDeleting = true;
    });

    try {
      await PostService.deletePost(widget.postId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        if (widget.onPostDeleted != null) {
          widget.onPostDeleted!();
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete post: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  String _getRelativeTime(String timestamp) {
    final postTime = DateTime.parse(timestamp);
    return timeago.format(postTime, locale: 'en');
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text(
              'Are you sure you want to delete this post? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deletePost();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 6,
      color: AppColors.lightGreenishWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con immagine del gioco e overlay per il nome del gioco
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image.network(
                  widget.gameCover,
                  width: double.infinity,
                  height: 125,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/game',
                        arguments: int.parse(widget.gameId),
                      );
                    },
                    child: Text(
                      widget.gameName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome utente e immagine profilo
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          backgroundImage: widget.profilePicture != ''
                              ? NetworkImage(widget.profilePicture)
                              : null,
                          radius: 20,
                          child: widget.profilePicture != ''
                              ? null
                              : Icon(Icons.person,
                                  color: Colors.grey[700], size: 30),
                        ),
                        const SizedBox(width: 10),
                        // Nome utente e data
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (widget.userId == widget.currentUser) {
                                    Navigator.pushNamed(context, '/profile',
                                        arguments: widget.userId);
                                  } else {
                                    Navigator.pushNamed(context, '/userProfile',
                                        arguments: widget.userId);
                                  }
                                },
                                child: SizedBox(
                                  width: 275,
                                  child: Text(
                                    widget.username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                _getRelativeTime(widget.timestamp),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Contenuto del post
                    Text(
                      widget.content,
                      maxLines: _isExpanded ? widget.content.length : 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    if (widget.content.toUpperCase().length > 74)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Text(
                          _isExpanded ? 'Show less' : 'Show more',
                          style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),

                    // Footer con icone di interazione
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Pulsante Like
                        Row(
                          children: [
                            LikeButton(
                              postId: widget.postId,
                              currentUser: widget.currentUser ?? '',
                              initialLikeCount: widget.likeCount,
                              initialLikedUsers: widget.likedBy,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "likes",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),

                        // Commenti
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.comment_outlined,
                                color: Colors.grey[700],
                                size: 24,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/comments',
                                  arguments: {
                                    'postId': widget.postId,
                                    'currentUser': widget.currentUser,
                                    'commentNotifier': commentNotifier
                                  },
                                );
                              },
                            ),
                            ValueListenableBuilder<int>(
                              valueListenable: commentNotifier,
                              builder: (context, commentCount, child) {
                                return Text(
                                  "$commentCount comments",
                                  style: const TextStyle(fontSize: 14),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: widget.currentUser != widget.userId
                    ? ReportMenu(
                        userId: widget.currentUser,
                        reportedId: widget.postId,
                        parentContext: context,
                        writerId: widget.userId,
                        type: 'Post',
                      )
                    : IconButton(
                        icon: _isDeleting
                            ? const Opacity(
                                opacity: 0,
                                child: CircularProgressIndicator(),
                              )
                            : const Icon(
                                Icons.delete_outline,
                                color: Colors.black54,
                              ),
                        onPressed: _isDeleting ? null : _showDeleteConfirmation,
                      ),
              ),
            ],
          ),
          // Toggle o cestino fisso in alto a destra
        ],
      ),
    );
  }
}
