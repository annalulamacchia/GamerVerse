import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/profile_or_users/info/user_follower_card.dart'; // Importa il widget UserCard
import 'package:gamerverse/widgets/community/similar_games_users_widget.dart'; // Importa il widget UserCard
import 'package:gamerverse/widgets/community/NearbyUsersWidget.dart'; // Importa il widget UserCard

class AdvisedUsersPage extends StatelessWidget {
  const AdvisedUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Suggested Users'),
          bottom: const TabBar(
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
