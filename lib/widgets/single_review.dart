import 'package:flutter/material.dart';
import 'package:gamerverse/views/profile/profile_page.dart';
import 'package:gamerverse/widgets/report.dart';

class SingleReview extends StatelessWidget {
  final String username;
  final double rating;
  final String comment;
  final String avatarUrl; // URL per l'avatar dell'utente
  final int likes;
  final int dislikes;

  // Costruttore per accettare i dati
  const SingleReview({
    super.key,
    required this.username,
    required this.rating,
    required this.comment,
    required this.avatarUrl,
    required this.likes,
    required this.dislikes,
  });

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
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12), // Bordi arrotondati
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Parte superiore con Avatar, informazioni sull'utente e opzioni
          Row(
            children: [
              // Avatar dell'utente
              CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl), // Carica immagine avatar
                radius: 20,
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Naviga alla pagina del profilo
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    child: Text(
                      username,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 16,
                      ),
                      Text(
                        rating.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(), // Spaziatura per spingere il bottone con i tre puntini a destra
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Report') {
                    // Mostra la bottom sheet per il report
                    _showReport(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'Report',
                    child: Text('Report Review'),
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
          const SizedBox(height: 10),

          // Commento dell'utente
          Text(
            comment,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),

          // Pulsanti per like e dislike con conteggio
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up),
                    onPressed: () {
                      // Azione per il like
                    },
                  ),
                  Text(likes.toString()),
                ],
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_down),
                    onPressed: () {
                      // Azione per il dislike
                    },
                  ),
                  Text(dislikes.toString()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
