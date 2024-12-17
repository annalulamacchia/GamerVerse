import 'package:flutter/material.dart';
import 'package:gamerverse/services/Community/post_service.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/posts/comments.dart';
import 'package:gamerverse/models/comment.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';

class CommentsPage extends StatefulWidget {
  final String postId;
  final String? currentUser;
  final ValueNotifier<int> commentNotifier;

  const CommentsPage(
      {super.key,
      required this.postId,
      required this.currentUser,
      required this.commentNotifier});

  @override
  CommentsPageState createState() => CommentsPageState();
}

class CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSending = false;
  bool _isLoading = true;
  List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    // Carica i commenti quando la pagina viene aperta
    _loadComments();
  }

  // Funzione per caricare i commenti
  Future<void> _loadComments() async {
    try {
      final comments = await PostService.getComments(widget.postId);
      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load comments: $e')),
      );
    }
  }

  // Funzione per inviare il commento
  Future<void> _sendComment(String commentText) async {
    setState(() {
      _isSending = true;
    });

    final success = await PostService.addComment(
      postId: widget.postId,
      userId: widget.currentUser!,
      comment: commentText,
    );

    setState(() {
      _isSending = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added successfully!')),
      );
      _commentController.clear();
      _loadComments();
      widget.commentNotifier.value++;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add comment.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    BuildContext parentContext = context;
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
          title: const Text('Comments', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: AppColors.darkGreen),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.teal,
                  ))
                : ListView.builder(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 17.5, bottom: 17.5),
                    itemCount: _comments.isEmpty ? 1 : _comments.length,
                    itemBuilder: (context, index) {
                      if (_comments.isEmpty) {
                        return NoDataList(
                          textColor: Colors.grey,
                          icon: Icons.comments_disabled_outlined,
                          message: 'No comments yet!',
                          subMessage: 'Be the first to share your thoughts.',
                          color: Colors.white,
                        );
                      } else {
                        final comment = _comments[index];
                        return CommentCard(
                            comment: comment,
                            currentUser: widget.currentUser,
                            parentContext: parentContext,
                            onCommentRemoved: _loadComments,
                            commentNotifier: widget.commentNotifier);
                      }
                    },
                  ),
          ),
          _buildCommentInputField(context),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 2,
      ),
    );
  }

  // Funzione per costruire il campo di input per i nuovi commenti
  Widget _buildCommentInputField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.darkestGreen, // Sfondo scuro per uniformità
      child: Row(
        children: [
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                textSelectionTheme: const TextSelectionThemeData(
                    selectionHandleColor: AppColors.mediumGreen,
                    cursorColor: AppColors.mediumGreen,
                    selectionColor: AppColors.mediumGreen
                ),
              ),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: const Color(0xffe6f2ed),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppColors.mediumGreen),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: _isSending
                ? const CircularProgressIndicator(color: AppColors.mediumGreen)
                : const Icon(Icons.send, color: AppColors.mediumGreen),
            onPressed: _isSending
                ? null
                : () async {
                    final commentText = _commentController.text.trim();
                    if (commentText.isNotEmpty) {
                      await _sendComment(commentText);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
