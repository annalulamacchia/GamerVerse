import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/NewPostBottomSheet.dart'; // Importa il nuovo widget NewPostBottomSheet
import 'package:gamerverse/widgets/common_sections/report_user.dart';
import 'package:gamerverse/widgets/common_sections/report.dart';
import 'package:gamerverse/widgets/community/PostCardCommunity.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  // Variabili statiche per mantenere i conteggi iniziali
  final int likeCount = 11;
  final int commentCount = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      // Sfondo scuro della pagina
      appBar: AppBar(
        title: const Text('Username', style: TextStyle(color: Colors.white)),
        // Sostituisci con il nome utente dinamico, se necessario
        backgroundColor: const Color(0xff163832),
        // Verde scuro per l'app bar
        actions: [
          Align(
            alignment: Alignment.topRight,
            // Sposta il pulsante nell'angolo in alto a destra
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 0.0),
              // Margine rispetto al bordo
              child: IconButton(
                padding: EdgeInsets.zero, // Rimuove il padding predefinito
                iconSize: 48.0, // Rende l'icona più grande
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedUserAdd02,
                  color: Colors.white,
                  size: 40.0,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/suggestedUsers');
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Ora ci sono 3 post simulati
              itemBuilder: (context, index) {
                return PostCard(
                  gameName: "Game Name",
                  author: "Username",
                  content: "Riga 1 Riga 2" * 20, // Testo simulato
                  imageUrl: "https://images.everyeye.it/img-cover/call-of-duty-black-ops-6-v9-49819-320x450.webp",
                  timestamp: "5 hours ago",
                  likeCount: 11,
                  commentCount: 5,
                  onLikePressed: () {
                    // Logica per aggiungere un like
                  },
                  onCommentPressed: () {
                    Navigator.pushNamed(context, '/comments');
                  },
                  onReportUserPressed: () {
                    _showReportUserDialog(context);
                  },
                  onReportPostPressed: () {
                    _showReportPostDialog(context);
                  },
                );
              },
            ),
          ),

        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1, // Seleziona 'Home' per questa pagina
        isLoggedIn: true, // Sostituisci con lo stato di accesso effettivo
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewPostBottomSheet(
              context); // Mostra il bottom sheet per il nuovo post
        },
        backgroundColor: const Color(0xff3e6259),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Funzione per mostrare il Modal Bottom Sheet per creare un nuovo post
  void _showNewPostBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: const Color(0xff051f20),
      builder: (BuildContext context) {
        return NewPostBottomSheet(); // Usa il nuovo widget NewPostBottomSheet
      },
    );
  }

  // Funzione per mostrare un dialog di report dell'utente
  void _showReportUserDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return const ReportUserWidget();
        });
  }

  // Funzione per mostrare un dialog di report del post
  void _showReportPostDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return const ReportWidget();
        });
  }
}
