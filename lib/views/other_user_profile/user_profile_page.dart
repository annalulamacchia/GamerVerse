import 'package:flutter/material.dart';
import '../../widgets/user_info_card.dart';
import '../../widgets/profile_tab_bar.dart';
import '../../widgets/wishing_favorite_completed.dart';
import '../common_sections/followers_or_following_page.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage() : super();

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfoCard(), // Scheda informazioni utente
          const SizedBox(height: 20),
          const TabBarSection(mode:1), // Tab Bar (Games, Reviews, Post)
          Expanded(child: GameListSection()), // Sezione Lista Giochi
        ],
      ),
    );
  }
}
