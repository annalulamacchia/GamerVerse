import 'package:flutter/material.dart';
// Importa il widget UserCard
import 'package:gamerverse/widgets/community/similar_games_users_widget.dart'; // Importa il widget SimilarGamesUsersWidget
import 'package:gamerverse/widgets/community/NearbyUsersWidget.dart'; // Importa il widget NearbyUsersWidget

class AdvisedUsersPage extends StatelessWidget {
  const AdvisedUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xff051f20), // Verde scuro per tutto lo sfondo
        appBar: AppBar(
          backgroundColor: const Color(0xff163832),
          title: const Text(
            'Suggested Users',
            style: TextStyle(color: Colors.white), // Colore del testo dell'AppBar
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white, // Indica la selezione con bianco
            labelColor: Colors.white, // Colore dei testi delle tab
            unselectedLabelColor: Colors.white70, // Colore dei testi non selezionati
            tabs: [
              Tab(text: 'Nearby Users'),
              Tab(text: 'Similar Games'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            NearbyUsersWidget(),
            SimilarGamesUsersWidget(),
          ],
        ),
      ),
    );
  }
}
