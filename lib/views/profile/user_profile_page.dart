import 'package:flutter/material.dart';
import 'package:gamerverse/utils/firebase_auth_helper.dart';
import 'package:gamerverse/widgets/profile_or_users/info/user_info_card.dart';
import 'package:gamerverse/widgets/profile_or_users/info/profile_tab_bar.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gamerverse/services/specific_game/wishlist_service.dart';
import 'package:gamerverse/models/game_profile.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<String> userIdFuture;
  String? currentUser; // Identificativo dell'utente corrente
  List<GameProfile> wishlist = []; // Lista dei giochi nella wishlist
  int gamesCounter = 0; // Contatore dei giochi
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userIdFuture = Future.value(widget.userId);
    _loadUserData();
    _loadWishlist(widget.userId);
  }

  // Carica i dati dell'utente corrente
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString('user_uid');
    final valid = await FirebaseAuthHelper.checkTokenValidity();

    setState(() {
      currentUser = valid ? uid : null;
    });
  }

  // Carica la wishlist dell'utente specificato e aggiorna il contatore
  Future<void> _loadWishlist(String userId) async {
    final games = await WishlistService.getWishlist(userId);
    setState(() {
      wishlist = games;
      gamesCounter = games.length; // Calcolo del contatore
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        backgroundColor: const Color(0xff163832),
        title: const Text(
          'User Profile',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'report') {
                // Logica per il report dell'utente
              } else if (value == 'block') {
                // Logica per il blocco dell'utente
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'report', child: Text('Report User')),
              const PopupMenuItem(value: 'block', child: Text('Block User')),
            ],
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: userIdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            String userId = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Card con informazioni dell'utente
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: UserInfoCard(
                    userId: userId,
                    games_counter: gamesCounter, // Passaggio del contatore
                  ),
                ),
                const SizedBox(height: 10),
                // Tab Bar con contenuti
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    child: TabBarSection(
                      mode: 1, // Modalità specifica per il profilo utente
                      selected: 0, // Tab selezionato inizialmente
                      userId: userId,
                      currentUser: currentUser,
                      wishlist: wishlist,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('No data available'),
            );
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1, // Indice per "Home" nella barra di navigazione
      ),
    );
  }
}
