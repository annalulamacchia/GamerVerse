import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/bottom_navbar.dart'; // Importa il widget CustomBottomNavBar
import 'package:gamerverse/widgets/report.dart';

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
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 32, bottom: 0),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return _buildComment(
                  context,
                  comment['username']!,
                  comment['comment']!,
                );
              },
            ),
          ),
          _buildCommentInputField(context),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 2,
        // Imposta l'indice corretto per evidenziare la sezione Commenti
        isLoggedIn: true, // Sostituisci con il vero stato di login dell'utente
      ),
    );
  }

  // Funzione per costruire i singoli commenti con altezza minima e layout personalizzato
  Widget _buildComment(BuildContext context, String username, String comment) {
    return Card(
      color: const Color(0xfff0f9f1),
      // Sfondo verdino chiaro per la card
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
            // Riga con nome utente, avatar e tre puntini
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Avatar e nome utente
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xff3e6259),
                      // Colore verde per l'avatar
                      child: Text(
                        username[0],
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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
                // Tre puntini in alto a destra
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Report') {
                      // Mostra la bottom sheet per il report
                      _showReport(context);
                    } else if (value == 'Delete') {
                      // Logica per Delete
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'Report',
                      child: Text('Report Comment'),
                    ),
                    const PopupMenuItem(
                      value: 'Report',
                      child: Text('Report User'),
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

            // Commento centrato con padding e font aumentato
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              // Aumentato il padding orizzontale
              child: Text(
                comment,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16, // Aumentato il font size
                ),
              ),
            ),
          ],
        ),
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
