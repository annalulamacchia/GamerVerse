import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart'; // Importa il widget CustomBottomNavBar
import 'package:gamerverse/widgets/common_sections/report.dart';
import 'package:gamerverse/widgets/profile_or_users/posts/comments.dart';
class CommentsPage extends StatelessWidget {
  // Lista dei commenti per il debug
  final List<Map<String, String>> comments = [
    {
      'username': 'User1',
      'comment':
          'This is a comment by User1 This is a comment by User1 This is a comment by User1 This is a comment by User1'
    },
    {'username': 'User2', 'comment': 'Another insightful comment'},
    {'username': 'User1', 'comment': 'This is a comment by User1'},
    {'username': 'User2', 'comment': 'Another insightful comment'},
    // Puoi aggiungere altri commenti qui
  ];

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

  CommentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20), // Sfondo scuro per uniformità
      appBar: AppBar(
        title: const Text('Comments', style: TextStyle(color: Colors.white)),
        // Sostituisci con il nome utente dinamico, se necessario
        backgroundColor:
            const Color(0xff163832), // Colore verde scuro per l'AppBar
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 32, bottom: 0),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return CommentCard(
                  username: comment['username']!,
                  comment: comment['comment']!,
                  onReportPressed: () {
                    // Logica per il report
                    _showReport(context);
                  },
                  onDeletePressed: () {
                    // Logica per eliminare il commento
                  },
                );
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

  // Funzione per costruire i singoli commenti con altezza minima e layout personalizzato


  // Funzione per costruire il campo di input per i nuovi commenti
  Widget _buildCommentInputField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color(0xff051f20), // Sfondo scuro per uniformità
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: const Color(0xffe6f2ed),
                // Sfondo verdino chiaro per il campo di input
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
            icon: const Icon(Icons.send, color: Color(0xff3e6259)),
            onPressed: () {
              // Logica per inviare il commento
            },
          ),
        ],
      ),
    );
  }
}
