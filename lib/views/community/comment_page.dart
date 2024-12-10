import 'package:flutter/material.dart';
import 'package:gamerverse/services/Community/post_service.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/posts/comments.dart';
import 'package:gamerverse/models/comment.dart';

class CommentsPage extends StatefulWidget {
  final String postId;
  final String? currentUser;

  const CommentsPage(
      {super.key, required this.postId, required this.currentUser});

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
      _loadComments(); // Ricarica i commenti dopo averne aggiunto uno nuovo
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
      backgroundColor: const Color(0xff051f20), // Sfondo scuro per uniformità
      appBar: AppBar(
        title: const Text('Comments', style: TextStyle(color: Colors.white)),
        backgroundColor:
            const Color(0xff163832), // Colore verde scuro per l'AppBar
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 10),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return CommentCard(
                          comment: comment,
                          currentUser: widget.currentUser,
                          parentContext: parentContext);
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
      color: const Color(0xff051f20), // Sfondo scuro per uniformità
      child: Row(
        children: [
          Expanded(
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
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: _isSending
                ? const CircularProgressIndicator(color: Color(0xff3e6259))
                : const Icon(Icons.send, color: Color(0xff3e6259)),
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
