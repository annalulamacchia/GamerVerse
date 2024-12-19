import 'package:flutter/material.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';

// Importa il widget UserCard
import 'package:gamerverse/widgets/community/similar_games_users_widget.dart'; // Importa il widget SimilarGamesUsersWidget
import 'package:gamerverse/widgets/community/NearbyUsersWidget.dart'; // Importa il widget NearbyUsersWidget
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';

class AdvisedUsersPage extends StatelessWidget {
  const AdvisedUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.darkestGreen,
        appBar: AppBar(
          backgroundColor: AppColors.darkGreen,
          title: const Text(
            'Suggested Users',
            style:
                TextStyle(color: Colors.white), // Colore del testo dell'AppBar
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the arrow (back icon) color to white
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            // Indica la selezione con bianco
            labelColor: Colors.white,
            // Colore dei testi delle tab
            unselectedLabelColor: Colors.white70,
            // Colore dei testi non selezionati
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
