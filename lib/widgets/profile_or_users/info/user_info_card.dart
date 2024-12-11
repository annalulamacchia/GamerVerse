import 'package:flutter/material.dart';
import 'package:gamerverse/services/user/Get_user_info.dart';
import 'package:gamerverse/services/Friends/friend_service.dart';
import 'package:gamerverse/widgets/common_sections/dialog_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoCard extends StatefulWidget {
  final String userId;
  final int games_counter;
  final ValueNotifier<bool>? blockedNotifier;
  final ValueNotifier<bool>? isFollowedNotifier;
  final ValueNotifier<int>? followersNotifier;
  final String? currentUser;

  const UserInfoCard({
    super.key,
    required this.userId,
    required this.games_counter,
    this.blockedNotifier,
    this.isFollowedNotifier,
    this.followersNotifier,
    this.currentUser,
  });

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';
  bool isButtonDisabled = false;
  String? loggedInUserId;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final response = await UserProfileService.getUserByUid(widget.userId);
      final prefs = await SharedPreferences.getInstance();
      if (response['success']) {
        setState(() {
          userData = response['data'];
          isLoading = false;

          loggedInUserId = prefs.getString('user_uid');
          List<dynamic> followers = userData!['followers'] ?? [];
          List<dynamic> followed = userData!['followed'] ?? [];

          userData!['followers_count'] = followers.where((follower) {
            return follower['isBlocked'] == false && follower['isFriend'];
          }).length;

          if (widget.followersNotifier != null) {
            widget.followersNotifier!.value = followers.where((follower) {
              return follower['isBlocked'] == false && follower['isFriend'];
            }).length;
          }

          userData!['followed_count'] = followed.where((followedUser) {
            return followedUser['isBlocked'] == false &&
                followedUser['isFriend'];
          }).length;

          widget.isFollowedNotifier!.value = followers.any((follower) {
            return follower['id'] == loggedInUserId &&
                follower['isBlocked'] == false &&
                follower['isFriend'];
          });

          widget.blockedNotifier!.value = followers.any((follower) {
            return follower['id'] == loggedInUserId &&
                (follower['isBlocked'] ?? false);
          });
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
      if (widget.isFollowedNotifier!.value) {
        final response =
            await FriendService.removeFriend(userId: widget.userId);
        if (response['success']) {
          userData!['followers_count'] = userData!['followers_count'] - 1;
          widget.followersNotifier!.value--;
        } else {
          throw Exception(response['message']);
        }
      } else {
        final response = await FriendService.addFriend(userId: widget.userId);
        if (response['success']) {
          userData!['followers_count'] = userData!['followers_count'] + 1;
          widget.followersNotifier!.value++;
        } else {
          throw Exception(response['message']);
        }
      }

      setState(() {
        widget.isFollowedNotifier!.value = !widget.isFollowedNotifier!.value;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        isButtonDisabled = false; // Riabilita il pulsante
      });
    }
  }

  Future<void> unblockUser(BuildContext context) async {
    final result = await FriendService.blockUnblockUser(
        userId: loggedInUserId!, blockedId: widget.userId, action: 'unblock');
    if (result) {
      setState(() {
        widget.blockedNotifier!.value = !widget.blockedNotifier!.value;
      });

      Navigator.pop;
      DialogHelper.showSuccessDialog(
          context, "The User was unblocked successfully!");
    } else {
      DialogHelper.showErrorDialog(
          context, "There was an error unblocking the user. Please try again!");
    }
  }

  @override
  Widget build(BuildContext context) {
    BuildContext parentContext = context;
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
            colors: [Color(0xff163832), Color(0xff3e6259)],
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
            // Row for Avatar and Stats
            Row(
              children: [
                // Avatar on the left
                _buildAvatarWithName(
                  userData!['profile_picture'],
                  userData!['name'],
                  userData!['surname'],
                ),
                const SizedBox(width: 16),
                // Expanded section for Stats
                Expanded(
                  child: Column(
                    children: [
                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn(
                            context,
                            (widget.games_counter).toString(),
                            'Games   ',
                            Icons.videogame_asset,
                          ),
                          _buildStatColumn(
                            context,
                            userData!['followed_count']?.toString() ?? '0',
                            'Followed ',
                            Icons.person_search,
                          ),
                          if (widget.followersNotifier != null)
                            ValueListenableBuilder<int>(
                              valueListenable: widget.followersNotifier!,
                              builder: (context, followersCount, child) {
                                return _buildStatColumn(
                                    context,
                                    followersCount.toString(),
                                    'Followers',
                                    Icons.group);
                              },
                            ),
                          if (widget.followersNotifier == null)
                            _buildStatColumn(
                              context,
                              userData!['followers_count']?.toString() ?? '0',
                              'Followers',
                              Icons.group,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Row for Name, Surname, and Follow/Unfollow button
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Name and Surname on the left, starting more to the right
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    // Aggiungi margine sinistro per spostare il nome più a destra
                    child: Text(
                      '${userData!['name']} ${userData!['surname']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start, // Align the text to the left
                    ),
                  ),
                ),
                // Follow/Unfollow Button on the right with added padding
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  // Add space around the button
                  child: ValueListenableBuilder<bool>(
                    valueListenable: widget.blockedNotifier!,
                    builder: (context, isBlocked, child) {
                      return TextButton(
                        onPressed: isButtonDisabled
                            ? null
                            : () {
                                if (widget.blockedNotifier!.value) {
                                  unblockUser(
                                      parentContext); // Funzione per sbloccare l'utente
                                } else {
                                  toggleFollow(); // Funzione per seguire/smettere di seguire
                                }
                              },
                        style: TextButton.styleFrom(
                          backgroundColor: isBlocked
                              ? Colors
                                  .orange // Colore per il pulsante "Unblock"
                              : (widget.isFollowedNotifier!.value
                                  ? Color(0xFF871C1C)
                                  : Color(0xBE17A828)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 9.0, horizontal: 15.0), // More padding
                          textStyle: const TextStyle(
                              fontSize:
                                  16), // Uniform font size for both Follow and Unfollow
                        ),
                        child: Text(
                          isBlocked
                              ? 'Unblock User'
                              : (widget.isFollowedNotifier!.value
                                  ? 'Unfollow'
                                  : 'Follow'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarWithName(
      String? profilePictureUrl, String name, String surname) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
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
      ],
    );
  }

  Widget _buildStatColumn(
      BuildContext context, String count, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(
          count,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
