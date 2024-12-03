import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/profile_or_users/profile_info_card.dart';
import 'package:gamerverse/widgets/profile_or_users/profile_tab_bar.dart';
import 'package:gamerverse/widgets/profile_or_users/wishing_favorite_completed.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';

class ProfileGames extends StatelessWidget {
  final String userId; // Aggiunto userId come parametro obbligatorio

  const ProfileGames({super.key, required this.userId}); // Il costruttore ora richiede userId

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      body:
          GameListSection(), // Sezione Lista Giochi

    );
  }
}
