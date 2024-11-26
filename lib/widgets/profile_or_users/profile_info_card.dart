import 'package:flutter/material.dart';
import 'package:gamerverse/views/common_sections/followers_or_following_page.dart';
import 'package:gamerverse/services/Get_user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileInfoCard extends StatefulWidget {
  const ProfileInfoCard({super.key});

  @override
  State<ProfileInfoCard> createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends State<ProfileInfoCard> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';
  String debugMessage = '';  // A new variable to hold debug information

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Recupera l'userId da SharedPreferences e quindi chiama il servizio
  Future<void> fetchUserData() async {

    // Add debug information
    setState(() {


    });

    // Chiamata al servizio per ottenere i dati utente
    final response = await UserProfileService.getUserByUid();

    // Log the response from the service
    setState(() {
      debugMessage += '\nResponse: ${response['message']}'; // Add response message to debug info
    });

    if (response['success']) {
      setState(() {
        userData = response;
        isLoading = false;
        print('Data: $userData');
      });
    } else {
      setState(() {
        errorMessage = response['message'];
        isLoading = false;
        print('error: $errorMessage');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    if (userData == null) {
      return const Center(child: Text('No user data available.'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // The existing Profile Card UI
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xff8eb69b),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAvatar(userData!['data']!['profile_picture']),
                    _buildStatColumn(userData!['Games'], 'Games'),
                    _buildClickableStatColumn(context, '${userData!['data']!['followed']}', 'Followed', const FollowersPage()),
                    _buildClickableStatColumn(context, '${userData!['data']!['followers']}', 'Followers', const FollowersPage()),
                  ],
                ),
                _buildName(userData!['data']!['name'],userData!['data']!['surname'] ), // userData!['surname']
              ],
            ),
          ),

          // Add a space between the profile info and debug messages
          const SizedBox(height: 20),

          // Debug messages section
        ],
      ),
    );
  }

  Widget _buildAvatar(String? profilePictureUrl) {
    return Container(
      margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
        image: profilePictureUrl != null
            ? DecorationImage(image: NetworkImage(profilePictureUrl), fit: BoxFit.cover)
            : null,
      ),
      child: profilePictureUrl == null
          ? const Icon(Icons.person, size: 40)
          : null,
    );
  }

  Widget _buildStatColumn(String? count, String label) {
    return Column(
      children: [
        Text(
          count ?? '0', // Usa '0' se count è null
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildClickableStatColumn(
      BuildContext context, String? count, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: _buildStatColumn(count, label),
    );
  }


  Widget _buildName(String name, String surname) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 25.0, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$name $surname',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
