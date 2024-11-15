import 'package:flutter/material.dart';
import 'package:gamerverse/views/common_sections/comment_page.dart';
import 'package:gamerverse/widgets/report.dart';

class UserPost extends StatefulWidget {
  final String username;
  final String commentText;
  final int likeCount;
  final int commentCount;

  const UserPost({
    super.key,
    required this.username,
    required this.commentText,
    required this.likeCount,
    required this.commentCount,
  });

  @override
  UserPostState createState() => UserPostState();
}

class UserPostState extends State<UserPost> {
  bool isLiked = false;
  late int currentLikeCount;

  @override
  void initState() {
    super.initState();
    // Imposta il numero di like iniziale dal widget
    currentLikeCount = widget.likeCount;
  }

  // Funzione per gestire il click sul pulsante like
  void _toggleLike() {
    setState(() {
      if (isLiked) {
        currentLikeCount--;
      } else {
        currentLikeCount++;
      }
      isLiked = !isLiked; // Inverte lo stato del like
    });
  }

  void _showReport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const ReportWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row con avatar, nome utente e icona opzioni
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Report') {
                        _showReport(context);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Report',
                        child: Text('Report Post'),
                      ),
                      const PopupMenuItem(
                        value: 'Report',
                        child: Text('Report User'),
                      ),
                    ],
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                  ),
                ],
              ),

              // Testo del commento
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.commentText,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),

              const SizedBox(height: 8),
              // Row per like e comment count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Occupa solo lo spazio necessario
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                          color: isLiked ? Colors.black : Colors.black54,
                        ),
                        onPressed: _toggleLike, // Chiama _toggleLike al click
                      ),
                      Text(currentLikeCount.toString()),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.comment_outlined),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentsPage(), // La pagina delle impostazioni
                            ),
                          );
                        },
                      ),
                      Text(widget.commentCount.toString()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
