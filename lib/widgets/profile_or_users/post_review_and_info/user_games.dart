import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/profile_or_users/user_info_card.dart';
import 'package:gamerverse/widgets/profile_or_users/profile_tab_bar.dart';
import 'package:gamerverse/widgets/profile_or_users/wishing_favorite_completed.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';

class UserGames extends StatelessWidget {
  final String userId; // Aggiunto userId come parametro obbligatorio

  // Costruttore che accetta userId
  const UserGames({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      body:
      GameListSection(), // Sezione Lista Giochi

    );
  }
}
