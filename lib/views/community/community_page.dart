import 'package:flutter/material.dart';
import 'package:gamerverse/views/community/advised_users_page.dart';
import 'package:gamerverse/widgets/profile_info_card.dart';
import 'package:hugeicons/hugeicons.dart';
// Importa i widget personalizzati dalla cartella widgets
import '../../widgets/bottom_navbar.dart';
import '../../widgets/profile_tab_bar.dart';
import '../../widgets/NewPostBottomSheet.dart'; // Importa il nuovo widget NewPostBottomSheet
import '../common_sections/comment_page.dart';
import 'advised_users_page.dart';
import '../../widgets/report_user.dart';
import '../../widgets/report.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  // Variabili statiche per mantenere i conteggi iniziali
  final int likeCount = 11;
  final int commentCount = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20), // Sfondo scuro della pagina
      appBar: AppBar(
        title: const Text('Username', style: TextStyle(color: Colors.white)), // Sostituisci con il nome utente dinamico, se necessario
        backgroundColor: const Color(0xff163832), // Verde scuro per l'app bar
        actions: [
          Align(
            alignment: Alignment.topRight, // Sposta il pulsante nell'angolo in alto a destra
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 0.0), // Margine rispetto al bordo
              child: IconButton(
                padding: EdgeInsets.zero, // Rimuove il padding predefinito
                iconSize: 48.0, // Rende l'icona più grande
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedUserAdd02,
                  color: Colors.white,
                  size: 40.0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdvisedUsersPage(),
                    ),
                  );
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
              itemCount: 3, // Ora ci sono 3 card di post
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Card(
                      color: const Color(0xfff0f9f1), // Sfondo verdino chiaro per le card
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8, // Maggiore elevazione per un'ombra più marcata
                      shadowColor: Colors.black.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.only(right:15,left:15,top:15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Immagine del gioco a sinistra
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://images.everyeye.it/img-cover/call-of-duty-black-ops-6-v9-49819-320x450.webp',
                                      ),
                                      fit: BoxFit.fill, // Riempe il contenitore ma potrebbe deformarsi
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Game Name',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: Colors.black87,
                                        ),
                                      ),

                                      const Text(
                                        'Author: Username', // Aggiunta la scritta per l'autore
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'riga 1Riga 2' * 20, // Testo simulato
                                        maxLines: 6,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey[700], fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Timestamp in basso a sinistra
                                Text(
                                  '5 hours ago', // Aggiungi il timestamp dinamico
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.thumb_up, color: Colors.grey[700]),
                                      onPressed: () {
                                        // Azione per aggiungere like
                                      },
                                    ),
                                    Text("$likeCount",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold, color: Colors.black87)),
                                    const SizedBox(width: 20),
                                    IconButton(
                                      icon: Icon(Icons.comment, color: Colors.grey[700]),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CommentsPage()),
                                        );
                                      },
                                    ),
                                    Text("$commentCount",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold, color: Colors.black87)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 20,
                      right: 20,
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.grey, size: 35),
                        onSelected: (value) {
                          if (value == 'reportUser') {
                            _showReportUserDialog(context); // Mostra il dialog per reportare l'utente
                          } else if (value == 'reportPost') {
                            _showReportPostDialog(context); // Mostra il dialog per reportare il post
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<String>(
                              value: 'reportUser',
                              child: Text("Report User"),
                            ),
                            PopupMenuItem<String>(
                              value: 'reportPost',
                              child: Text("Report Post"),
                            ),
                          ];
                        },
                      ),
                    ),
                  ],
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
          _showNewPostBottomSheet(context); // Mostra il bottom sheet per il nuovo post
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
          return ReportUserWidget();
        }
    );


  }

  // Funzione per mostrare un dialog di report del post
  void _showReportPostDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ReportWidget();
        }
    );
  }
}
