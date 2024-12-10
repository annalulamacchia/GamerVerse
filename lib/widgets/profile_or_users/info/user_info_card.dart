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

  const UserInfoCard(
      {super.key,
      required this.userId,
      required this.games_counter,
      this.blockedNotifier,
      this.isFollowedNotifier,
      this.followersNotifier,
      this.currentUser});

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
      // Chiama il servizio per ottenere i dati dell'utente
      final response = await UserProfileService.getUserByUid(widget.userId);
      final prefs = await SharedPreferences.getInstance();
      if (response['success']) {
        setState(() {
          //print(response['data']);
          userData = response['data'];
          isLoading = false;

          loggedInUserId = prefs.getString('user_uid');
          List<dynamic> followers = userData!['followers'] ?? [];
          List<dynamic> followed = userData!['followed'] ?? [];

          // Calcola il numero di followers, escludendo utenti bloccati
          userData!['followers_count'] = followers.where((follower) {
            return follower['isBlocked'] == false && follower['isFriend'];
          }).length;
          if (widget.followersNotifier != null) {
            widget.followersNotifier!.value = followers.where((follower) {
              return follower['isBlocked'] == false && follower['isFriend'];
            }).length;
          }

          // Calcola il numero di utenti seguiti, escludendo utenti bloccati
          userData!['followed_count'] = followed.where((followedUser) {
            return followedUser['isBlocked'] == false &&
                followedUser['isFriend'];
          }).length;

          // Verifica se l'utente loggato è seguito e non bloccato
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
        // Chiama il servizio per rimuovere un amico
        final response =
            await FriendService.removeFriend(userId: widget.userId);
        if (response['success']) {
          userData!['followers_count'] = userData!['followers_count'] - 1;
          print('Friend removed successfully');
          widget.followersNotifier!.value--;
        } else {
          print('Failed to remove friend: ${response['message']}');
          throw Exception(response['message']);
        }
      } else {
        // Chiama il servizio per aggiungere un amico
        final response = await FriendService.addFriend(userId: widget.userId);
        if (response['success']) {
          userData!['followers_count'] = userData!['followers_count'] + 1;
          widget.followersNotifier!.value++;
          print('Friend added successfully');
        } else {
          print('Failed to add friend: ${response['message']}');
          throw Exception(response['message']);
        }
      }

      setState(() {
        widget.isFollowedNotifier!.value =
            !widget.isFollowedNotifier!.value; // Aggiorna lo stato
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

  Future<void> unblockUser(BuildContext context) async {
    final result = await FriendService.blockUnblockUser(
        userId: loggedInUserId!, blockedId: widget.userId, action: 'unblock');
    if (result) {
      setState(() {
        widget.blockedNotifier!.value =
            !widget.blockedNotifier!.value; // Aggiorna lo stato
      });

      Navigator.pop;
      DialogHelper.showSuccessDialog(
          context, "The User was unblocked successfully!");
    } else {
      DialogHelper.showErrorDialog(context,
          "There was an error for blocking the user. Please, try again!");
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
                // Usa ValueListenableBuilder se followersNotifier è disponibile
                if (widget.followersNotifier != null)
                  ValueListenableBuilder<int>(
                    valueListenable: widget.followersNotifier!,
                    builder: (context, followersCount, child) {
                      return _buildStatColumn(
                          followersCount.toString(), 'Followers');
                    },
                  ),

                // Se followersNotifier è null, usa il valore da userData
                if (widget.followersNotifier == null)
                  _buildStatColumn(
                      userData!['followers_count']?.toString() ?? '0',
                      'Followers'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildName(userData!['name'], userData!['surname']),
                ValueListenableBuilder<bool>(
                  valueListenable: widget.blockedNotifier!,
                  builder: (context, isBlocked, child) {
                    if (widget.currentUser != null) {
                      return ElevatedButton(
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isBlocked
                              ? Colors
                                  .orange // Colore per il pulsante "Unblock"
                              : (widget.isFollowedNotifier!.value
                                  ? Colors.red
                                  : Colors.green),
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
                    } else {
                      return SizedBox(
                        height: 30,
                      );
                    }
                  },
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
