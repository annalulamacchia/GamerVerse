import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa SharedPreferences
import 'package:gamerverse/services/Community/advised_user_service.dart';
import 'package:gamerverse/widgets/profile_or_users/info/user_follower_card.dart'; // Importa UserCard

class SimilarGamesUsersWidget extends StatefulWidget {
  const SimilarGamesUsersWidget({super.key});

  @override
  _SimilarGamesUsersWidgetState createState() =>
      _SimilarGamesUsersWidgetState();
}

class _SimilarGamesUsersWidgetState extends State<SimilarGamesUsersWidget> {
  bool isLoading = true;
  List<Map<String, dynamic>> similarGameUsers = [];
  List<bool> isFollowed = []; // Lista per tenere traccia dello stato di follow
  String? currentUserId; // Aggiungi una variabile per l'ID utente corrente

  @override
  void initState() {
    super.initState();
    _fetchSimilarGameUsers();
  }

  Future<void> _fetchSimilarGameUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final users = await AdvisedUsersService.fetchUsersByGames(); // Chiamata al backend
      setState(() {
        currentUserId = prefs.getString('user_uid') ?? 'default_user';
        similarGameUsers = users;

        // Crea una lista di booleani che rappresentano lo stato di follow di ogni utente
        isFollowed = List.generate(similarGameUsers.length, (index) {
          return false; // Inizializza con 'false' per ogni utente
        });

        isLoading = false;
      });
    } catch (e) {
      print('Error fetching similar game users: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Funzione per aggiornare lo stato di follow
  Future<void> _toggleFollow(int index) async {
    setState(() {
      isFollowed[index] = !isFollowed[index]; // Inverte lo stato di follow
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator(color: Colors.teal))
        : similarGameUsers.isEmpty
        ? const Center(child: Text('No users with similar games found'))
        : ListView.builder(
      itemCount: similarGameUsers.length,
      itemBuilder: (context, index) {
        final user = similarGameUsers[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: UserCard(
            index: user["user_id"],
            username: user["username"],
            profilePicture: user["profile_picture"],
            isFollowed: isFollowed[index], // Passa lo stato di follow
            isBlocked: false,
            parentContext: context,
            onTap: () {
              if (user["user_id"] != currentUserId || currentUserId == null) {
                Navigator.pushNamed(context, '/userProfile',
                    arguments: user["user_id"]);
              } else {
                Navigator.pushNamed(context, '/profile',
                    arguments: user["user_id"]);
              }
            },
            currentUser: currentUserId,
            commonGames: user["common_games"],
            onFollow: () async {
              await _toggleFollow(index); // Toggle stato di follow
            },
          ),
        );
      },
    );
  }
}
