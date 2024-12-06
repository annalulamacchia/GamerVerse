import 'package:flutter/material.dart';
import 'package:gamerverse/utils/firebase_auth_helper.dart';
import 'package:gamerverse/widgets/profile_or_users/info/user_info_card.dart';
import 'package:gamerverse/widgets/profile_or_users/info/profile_tab_bar.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<String> userIdFuture;
  String? currentUser;

  @override
  void initState() {
    super.initState();
    userIdFuture = Future.value(widget.userId);
    _loadUserData();
  }

  //load the current user_id
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString('user_uid');
    final valid = await FirebaseAuthHelper.checkTokenValidity();
    setState(() {
      if (valid) {
        currentUser = uid;
      } else {
        currentUser = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        backgroundColor: const Color(0xff163832),
        title:
            const Text('User Profile', style: TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'report') {
                // Logica per report
              } else if (value == 'block') {
                // Logica per blocco
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
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            String userId = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Card Informazioni Utente
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: UserInfoCard(userId: userId),
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
                      mode: 1,
                      selected: 0,
                      userId: userId,
                      currentUser: currentUser,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1, // Indice per "Home"
      ),
    );
  }
}
