import 'package:flutter/material.dart';
import '../../widgets/profile_info_card.dart';
import '../../widgets/profile_tab_bar.dart';
import '../../widgets/wishing_favorite_completed.dart';
import 'profile_settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        backgroundColor: const Color(0xff163832),
        title: const Text('Username'),
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
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileInfoCard(), // Scheda informazioni utente
          SizedBox(height: 20),
          TabBarSection(mode:0), // Tab Bar (Games, Reviews, Post)
          Expanded(child: GameListSection()), // Sezione Lista Giochi
        ],
      ),
    );
  }
}
