import 'package:flutter/material.dart';
import 'package:gamerverse/services/Get_user_info.dart';

class UserInfoCard extends StatefulWidget {
  final String userId; // Passa userId tramite il costruttore

  const UserInfoCard({super.key, required this.userId});

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';
  bool isFollowing = false; // Aggiunto per gestire il follow/unfollow

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final response = await UserProfileService.getUserByUid(widget.userId);
      if (response['success']) {
        setState(() {
          userData = response['data'];
          isLoading = false;
          isFollowing = userData!['isFollowing'] ?? false; // Impostato il follow iniziale
        });
      } else {
        setState(() {
          errorMessage = response['message'] ?? 'Error fetching user data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An unexpected error occurred: $e';
        isLoading = false;
      });
    }
  }

  // Funzione per gestire Follow/Unfollow
  Future<void> toggleFollow() async {
    setState(() {
      isLoading = true;
    });

    /*try {
      // Simulazione di follow/unfollow. Puoi sostituire questo con il metodo API per il follow/unfollow
      //final response = await UserProfileService.toggleFollow(widget.userId);
      if (response['success']) {
        setState(() {
          isFollowing = !isFollowing;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = response['message'] ?? 'Error toggling follow state';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An unexpected error occurred: $e';
        isLoading = false;
      });
    }*/
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
      child: Container(
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
                _buildAvatar(userData!['profile_picture']),
                _buildStatColumn('${userData!['games']}', 'Games'),
                _buildStatColumn('${userData!['followed']}', 'Followed'),
                _buildStatColumn('${userData!['followers']}', 'Followers'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildName(userData!['name'], userData!['surname']),
                ElevatedButton(
                  onPressed: toggleFollow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing ? Colors.red : Colors.green, // Cambia colore in base allo stato
                  ),
                  child: Text(
                    isFollowing ? 'Unfollow' : 'Follow',
                    style: const TextStyle(color: Colors.white), // Colore del testo bianco
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String? profilePictureUrl) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0, bottom: 0.0),
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

  Widget _buildName(String name, String surname) {
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 25.0, right: 8),
      child: Row(
        children: [
          Text('$name $surname',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
