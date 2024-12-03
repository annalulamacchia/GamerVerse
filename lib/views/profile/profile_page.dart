import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/profile_or_users/profile_info_card.dart';
import 'package:gamerverse/widgets/profile_or_users/profile_tab_bar.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<String> userIdFuture;

  @override
  void initState() {
    super.initState();
    userIdFuture = _loadUserId();
  }

  Future<String> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_uid') ?? 'default_user';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        backgroundColor: const Color(0xff163832),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), // Icona a forma di ingranaggio
            onPressed: () {
              Navigator.pushNamed(context, '/profileSettings');
            },
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ProfileInfoCard(),
                ),
                const SizedBox(height: 5),
                // Usa Expanded per evitare overflow con il ListView
                Expanded(
                  child: TabBarSection(
                    mode: 0,
                    selected: 0,
                    userId: userId,
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
        currentIndex: 2,
      ),
    );
  }
}
