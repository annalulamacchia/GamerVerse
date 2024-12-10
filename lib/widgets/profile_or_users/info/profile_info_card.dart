import 'package:flutter/material.dart';
import 'package:gamerverse/views/profile/followers_or_following_page.dart';
import 'package:gamerverse/services/user/Get_user_info.dart';

class ProfileInfoCard extends StatefulWidget {
  final int games_counter;

  const ProfileInfoCard({super.key, required this.games_counter});

  @override
  State<ProfileInfoCard> createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends State<ProfileInfoCard> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final response = await UserProfileService.getUserByUid();
    if (response['success']) {
      setState(() {
        userData = response;
        isLoading = false;

        List<dynamic> followers = userData!['data']['followers'] ?? [];
        List<dynamic> followed = userData!['data']['followed'] ?? [];
        userData!['data']['followers_count'] = followers.where((follower) {
          return follower['isBlocked'] == false && follower['isFriend'];
        }).length;

        userData!['data']['followed_count'] = followed.where((followedUser) {
          return followedUser['isBlocked'] == false && followedUser['isFriend'];
        }).length;
      });
    } else {
      setState(() {
        errorMessage = response['message'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.teal));
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    if (userData == null) {
      return const Center(child: Text('No user data available.'));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff163832), Color(0xff3e6259)], // Gradiente della card precedente
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatarWithName(
                  userData!['data']!['profile_picture'],
                  userData!['data']!['name'],
                  userData!['data']!['surname'],
                ),
                const SizedBox(width: 16), // Spazio tra l'immagine e le statistiche
                Expanded(
                  child: Column(
                    children: [
                      // Righe per le statistiche (Games, Followed, Followers)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn(
                            context,
                            (widget.games_counter).toString(),
                            'Games   ',
                            Icons.videogame_asset,
                          ),
                          _buildClickableStatColumn(
                            context,
                            userData!['data']['followed_count']?.toString() ?? '0',
                            'Followed ',
                            Icons.person_search,
                            const FollowersPage(),
                          ),
                          _buildClickableStatColumn(
                            context,
                            userData!['data']['followers_count']?.toString() ?? '0',
                            'Followers',
                            Icons.group,
                            const FollowersPage(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12), // Distanza tra le statistiche e il nome
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarWithName(String? profilePictureUrl, String name, String surname) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Centra l'immagine e il testo
      crossAxisAlignment: CrossAxisAlignment.center, // Allinea al centro
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            image: profilePictureUrl != null
                ? DecorationImage(
                image: NetworkImage(profilePictureUrl), fit: BoxFit.cover)
                : null,
          ),
          child: profilePictureUrl == null
              ? const Icon(Icons.person, size: 40, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 16),  // Spazio tra immagine e testo
        Text(
          '$name $surname',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(BuildContext context, String count, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 6),
        Text(
          count,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildClickableStatColumn(BuildContext context, String count,
      String label, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: _buildStatColumn(context, count, label, icon),
    );
  }
}

