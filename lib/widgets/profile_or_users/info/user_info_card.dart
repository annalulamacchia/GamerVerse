import 'package:flutter/material.dart';
import 'package:gamerverse/services/user/Get_user_info.dart';
import 'package:gamerverse/services/Friends/friend_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoCard extends StatefulWidget {
  final String userId;
  final int games_counter;

  const UserInfoCard(
      {super.key, required this.userId, required this.games_counter});

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';
  bool isFollowing = false;
  bool isButtonDisabled = false; // Per gestire il pulsante

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Chiama il servizio per ottenere i dati dell'utente
      final response = await UserProfileService.getUserByUid(widget.userId);
      final prefs = await SharedPreferences.getInstance();
      if (response['success']) {
        setState(() {
          //print(response['data']);
          userData = response['data'];
          isLoading = false;

          final String? loggedInUserId = prefs.getString('user_uid');
          List<dynamic> followers = userData!['followers'] ?? [];
          List<dynamic> followed = userData!['followed'] ?? [];

          userData!['followers_count'] = followers.length;
          userData!['followed_count'] = followed.length;
          isFollowing = followers.contains(loggedInUserId);
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

  Future<void> toggleFollow() async {
    setState(() {
      isButtonDisabled = true; // Disabilita il pulsante
    });

    try {
      if (isFollowing) {
        // Chiama il servizio per rimuovere un amico
        final response =
            await FriendService.removeFriend(userId: widget.userId);
        if (response['success']) {
          userData!['followers_count'] = userData!['followers_count'] - 1;
          print('Friend removed successfully');
        } else {
          print('Failed to remove friend: ${response['message']}');
          throw Exception(response['message']);
        }
      } else {
        // Chiama il servizio per aggiungere un amico
        final response = await FriendService.addFriend(userId: widget.userId);
        if (response['success']) {
          userData!['followers_count'] = userData!['followers_count'] + 1;
          print('Friend added successfully');
        } else {
          print('Failed to add friend: ${response['message']}');
          throw Exception(response['message']);
        }
      }

      setState(() {
        isFollowing = !isFollowing; // Aggiorna lo stato
      });
    } catch (e) {
      print('Error toggling follow state: $e');
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        isButtonDisabled = false; // Riabilita il pulsante
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
                _buildStatColumn((widget.games_counter).toString(), 'Games'),
                _buildStatColumn(
                    userData!['followed_count']?.toString() ?? '0', 'Followed'),
                _buildStatColumn(
                    userData!['followers_count']?.toString() ?? '0',
                    'Followers'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildName(userData!['name'], userData!['surname']),
                ElevatedButton(
                  onPressed: isButtonDisabled ? null : toggleFollow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing ? Colors.red : Colors.green,
                  ),
                  child: Text(
                    isFollowing ? 'Unfollow' : 'Follow',
                    style: const TextStyle(color: Colors.white),
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
            ? DecorationImage(
                image: NetworkImage(profilePictureUrl), fit: BoxFit.cover)
            : null,
      ),
      child:
          profilePictureUrl == null ? const Icon(Icons.person, size: 40) : null,
    );
  }

  Widget _buildStatColumn(String? count, String label) {
    return Column(
      children: [
        Text(
          count ?? '0',
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
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
