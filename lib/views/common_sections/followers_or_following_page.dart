import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/profile_or_users/user_follower_card.dart'; // Importa il widget UserCard

class FollowersPage extends StatelessWidget {
  const FollowersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        title: const Text('Followers', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff163832),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return UserCard(
            index: index,
            onTap: () {
              // Navigazione alla pagina del profilo utente
              Navigator.pushNamed(context, '/userProfile');
            },
          );
        },
      ),
    );
  }
}
