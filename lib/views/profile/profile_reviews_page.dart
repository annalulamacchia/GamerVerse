import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/profile_info_card.dart';
// Importa i widget personalizzati dalla cartella widgets
import '../../widgets/bottom_navbar.dart';
import '../../widgets/profile_tab_bar.dart';
import '../../widgets/NewPostBottomSheet.dart'; // Importa il nuovo widget NewPostBottomSheet
import '../common_sections/comment_page.dart';
import '../profile/profile_settings_page.dart';

class ProfileReviewsPage extends StatelessWidget {
  const ProfileReviewsPage({super.key});

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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            // Sezione Tab
          ),
          const TabBarSection(mode: 0, selected: 1), // Usa TabBarSection con modalità 0 e selezione 2
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
