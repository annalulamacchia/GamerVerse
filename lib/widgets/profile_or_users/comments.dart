import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final String username;
  final String comment;
  final VoidCallback onReportPressed;
  final VoidCallback onDeletePressed;

  const CommentCard({
    super.key,
    required this.username,
    required this.comment,
    required this.onReportPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xfff0f9f1), // Sfondo verdino chiaro
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.only(left: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Avatar e nome utente
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xff3e6259),
                      child: Text(
                        username[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                // Menu di azioni (Report, Delete)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Report') {
                      onReportPressed();
                    } else if (value == 'Delete') {
                      onDeletePressed();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'Report',
                      child: Text('Report Comment'),
                    ),
                    const PopupMenuItem(
                      value: 'Delete',
                      child: Text('Delete Comment'),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                ),
              ],
            ),

            // Testo del commento
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                comment,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
