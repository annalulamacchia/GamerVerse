import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/profile_or_users/info/user_follower_card.dart'; // Importa il widget UserCard
import 'package:gamerverse/widgets/community/similar_games_users_widget.dart'; // Importa il widget SimilarGamesUsersWidget
import 'package:gamerverse/widgets/community/NearbyUsersWidget.dart'; // Importa il widget NearbyUsersWidget
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';

class AdvisedUsersPage extends StatelessWidget {
  const AdvisedUsersPage({Key? key}) : super(key: key);

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
        body:
        const TabBarView(
          children: [
            NearbyUsersWidget(),
            SimilarGamesUsersWidget(),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavBar(
          currentIndex: 2,
        ),
      ),
    );
  }
}
