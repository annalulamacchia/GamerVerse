import 'package:flutter/material.dart';
import '../../widgets/user_info_card.dart';
import '../../widgets/profile_tab_bar.dart';
import '../../widgets/wishing_favorite_completed.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        backgroundColor: const Color(0xff163832),
        title: const Text('Username', style: TextStyle(color: Colors.white)),
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
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfoCard(), // Scheda informazioni utente
          SizedBox(height: 20),
          TabBarSection(mode:1), // Tab Bar (Games, Reviews, Post)
          Expanded(child: GameListSection()), // Sezione Lista Giochi
        ],
      ),
    );
  }
}
