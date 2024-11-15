import 'package:flutter/material.dart';
// Importa i widget personalizzati dalla cartella widgets
import '../../widgets/bottom_navbar.dart';
import '../../widgets/user_info_card.dart';
import '../../widgets/profile_tab_bar.dart';
// Importa il nuovo widget NewPostBottomSheet
import '../common_sections/comment_page.dart';
class UserPostPage extends StatelessWidget {
  const UserPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20), // Sfondo scuro della pagina
      appBar: AppBar(
        title: const Text('Username',style:TextStyle(color:Colors.white)), // Sostituisci con il nome utente dinamico, se necessario
        backgroundColor: const Color(0xff163832),// Verde scuro per l'app bar
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'report') {
                // Naviga alla pagina di report
              } else if (value == 'block') {
                // Naviga alla pagina di blocco
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'report', child: Text('Report User')),
              const PopupMenuItem(value: 'block', child: Text('Block User')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const UserInfoCard(), // Scheda informazioni utente
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: TabBarSection(mode:1,selected:2), // Sezione Tab
          ),
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
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Immagine del gioco a sinistra
                                Image.network(
                                  'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.wired.it%2Fgallery%2Fnascondere-scritte-foto-immagini-ai%2F&psig=AOvVaw0KX_7VzYQmZ874L2OfbOwB&ust=1731514505952000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCPjD-M-m14kDFQAAAAAdAAAAABAI', // Placeholder per l'immagine
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.broken_image, color: Colors.grey[400],size:90);
                                  },
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
                                      const SizedBox(height: 0),
                                      Text(
                                        'Game description goes here..asdsadasdsadasdsad'
                                            'asdsadsadasd'
                                            'asdsadadd'
                                            'asdsadsadad'
                                            'asdsadasd.',
                                        maxLines: 10,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.thumb_up, color: Colors.grey[700]),
                                  onPressed: () {
                                    // Logica per il like
                                  },
                                ),
                                const Text("11", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                                const SizedBox(width: 20),
                                IconButton(
                                  icon: Icon(Icons.comment, color: Colors.grey[700]),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CommentsPage()),
                                    );
                                  },

                                ),
                                const Text("5", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                              ],
                            ),
                          ],
                        ),
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

    );
  }

  // Funzione per mostrare il Modal Bottom Sheet per creare un nuovo post
}
