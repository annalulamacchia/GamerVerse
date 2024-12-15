import 'package:flutter/material.dart';
import 'package:gamerverse/models/comment.dart';
import 'package:gamerverse/services/Community/post_service.dart';
import 'package:gamerverse/widgets/common_sections/dialog_helper.dart';
import 'package:gamerverse/widgets/common_sections/report_menu.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;
  final String? currentUser;
  final BuildContext parentContext;
  final VoidCallback onCommentRemoved;
  final ValueNotifier<int> commentNotifier;

  const CommentCard({
    super.key,
    required this.comment,
    required this.currentUser,
    required this.parentContext,
    required this.onCommentRemoved,
    required this.commentNotifier,
  });

  @override
  CommentCardState createState() => CommentCardState();
}

class CommentCardState extends State<CommentCard> {
  bool _isExpanded = false;

  //function to remove the review
  void _removeComment(String reviewI, BuildContext context) async {
    final success =
        await PostService.removeComment(commentId: widget.comment.commentId);

    if (success) {
      DialogHelper.showSuccessDialog(context, 'Review removed succesfully!');
      widget.onCommentRemoved();
      widget.commentNotifier.value--;
    } else {
      DialogHelper.showErrorDialog(
          context, 'Error in removing the review. Please try again.');
    }
  }

  //function to show the modal to remove the review
  void _showDeleteConfirmation(BuildContext context, String? reviewId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Review'),
          content: const Text(
              'Are you sure you want to delete this comment? This action cannot be undone.'),
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
                if (reviewId != null) {
                  _removeComment(
                      widget.comment.commentId, widget.parentContext);
                }
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
    return Stack(
      children: [
        Card(
          color: const Color(0xfff0f9f1),
          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 17.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          backgroundImage: widget.comment.profilePicture != ''
                              ? NetworkImage(widget.comment.profilePicture)
                              : null,
                          radius: 22,
                          child: widget.comment.profilePicture != ''
                              ? null
                              : Icon(Icons.person,
                                  color: Colors.grey[700], size: 30),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            if (widget.currentUser == null ||
                                widget.currentUser != widget.comment.writerId) {
                              Navigator.pushNamed(
                                context,
                                '/userProfile',
                                arguments: widget.comment.writerId,
                              );
                            } else if (widget.currentUser != null &&
                                widget.currentUser == widget.comment.writerId) {
                              Navigator.pushNamed(
                                context,
                                '/profile',
                                arguments: widget.comment.writerId,
                              );
                            }
                          },
                          child: Container(
                            width: 240,
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              widget.comment.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: null,
                              softWrap: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 7.5,
                ),
                Text(
                  widget.comment.description,
                  maxLines: _isExpanded ? widget.comment.description.length : 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),

                // View More / View Less
                if (widget.comment.description.toUpperCase().length > 74)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? 'View Less' : 'View More',
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 15,
          child: Row(
            children: [
              if (widget.currentUser != null &&
                  widget.comment.writerId != widget.currentUser)
                ReportMenu(
                  userId: widget.currentUser,
                  writerId: widget.comment.writerId,
                  reportedId: widget.comment.commentId,
                  parentContext: widget.parentContext,
                  type: 'Comment',
                ),
              if (widget.currentUser != null &&
                  widget.comment.writerId == widget.currentUser)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.black54,
                  ),
                  onPressed: () => _showDeleteConfirmation(
                      widget.parentContext, widget.comment.commentId),
                ),
              if (widget.currentUser == null)
                const Icon(Icons.more_vert,
                    color: Colors.transparent, size: 37.5),
            ],
          ),
        ),
      ],
    );
  }
}
