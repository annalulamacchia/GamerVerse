import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/profile_info_card.dart';
// Importa i widget personalizzati dalla cartella widgets
import '../../widgets/bottom_navbar.dart';
import '../../widgets/profile_tab_bar.dart';
import '../../widgets/NewPostBottomSheet.dart'; // Importa il nuovo widget NewPostBottomSheet
import '../common_sections/comment_page.dart';
import '../profile/profile_settings_page.dart';

class ProfilePostPage extends StatefulWidget {
  const ProfilePostPage({super.key});

  @override
  _ProfilePostPageState createState() => _ProfilePostPageState();
}

class _ProfilePostPageState extends State<ProfilePostPage> {
  // Puoi aggiungere variabili di stato qui
  int _likeCount = 11;
  final int _commentCount = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20), // Sfondo scuro della pagina
      appBar: AppBar(
        title: const Text('Username', style: TextStyle(color: Colors.white)), // Sostituisci con il nome utente dinamico, se necessario
        backgroundColor: const Color(0xff163832), // Verde scuro per l'app bar
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), // Icona a forma di ingranaggio
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountSettingsPage(), // La pagina delle impostazioni
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const ProfileInfoCard(), // Scheda informazioni utente
           const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            // Sezione Tab
          ),
          const TabBarSection(mode: 0,selected:2),
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
                                  'https://via.placeholder.com/90', // URL immagine valido
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.broken_image, color: Colors.grey[400], size: 90);
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
                                      const SizedBox(height: 5),
                                      Text(
                                        'riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2''riga 1Riga 2',
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.thumb_up, color: Colors.grey[700]),
                                  onPressed: () {
                                    setState(() {
                                      _likeCount++; // Aumenta il conteggio dei like
                                    });
                                  },
                                ),
                                Text("$_likeCount",
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
                                Text("$_commentCount",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, color: Colors.black87)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red, size: 35),
                        onPressed: () {
                          setState(() {
                            // Logica per eliminare il post
                          });
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
        return  NewPostBottomSheet(); // Usa il nuovo widget NewPostBottomSheet
      },
    );
  }
}
