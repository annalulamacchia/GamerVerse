import 'package:flutter/material.dart';
import 'package:gamerverse/services/user/Get_user_info.dart';
import 'package:gamerverse/services/Friends/friend_service.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/utils/firebase_auth_helper.dart';
import 'package:gamerverse/views/profile/followers_or_following_page.dart';
import 'package:gamerverse/widgets/common_sections/dialog_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoCard extends StatefulWidget {
  final String userId;
  final int gamesCounter;
  final ValueNotifier<bool>? blockedNotifier;
  final ValueNotifier<bool>? isFollowedNotifier;
  final ValueNotifier<int>? followersNotifier;
  final ValueNotifier<List<dynamic>>? currentFollowedNotifier;
  final String? currentUser;

  const UserInfoCard({
    super.key,
    required this.userId,
    required this.gamesCounter,
    this.blockedNotifier,
    this.isFollowedNotifier,
    this.followersNotifier,
    this.currentUser,
    this.currentFollowedNotifier,
  });

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  Map<String, dynamic>? userData;
  Map<String, dynamic>? currentUserData;
  bool isLoading = true;
  bool isLoadingCurrentUser = true;
  String errorMessage = '';
  bool isButtonDisabled = false;
  String? loggedInUserId;
  List<dynamic> followed = [];
  List<dynamic> followers = [];
  List<dynamic> currentUserFollowed = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchCurrentUserData();
  }

  Future<void> fetchCurrentUserData() async {
    try {
      if (widget.currentUser != null) {
        final response = await UserProfileService.getUserByUid(widget.currentUser);
        if (response['success']) {
          setState(() {
            currentUserData = response['data'];
            currentUserFollowed = currentUserData!['followed'] ?? [];
            widget.currentFollowedNotifier!.value = currentUserFollowed;

            isLoadingCurrentUser = false;
          });
        } else {
          setState(() {
            errorMessage = response['message'] ?? 'Error fetching user data';
            isLoadingCurrentUser = false;
          });
        }
      } else {
        setState(() {
          isLoadingCurrentUser = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An unexpected error occurred: $e';
        isLoadingCurrentUser = false;
      });
    }
  }

  Future<void> fetchUserData() async {
    try {
      final response = await UserProfileService.getUserByUid(widget.userId);
      final prefs = await SharedPreferences.getInstance();
      final String? uid = prefs.getString('user_uid');
      final valid = await FirebaseAuthHelper.checkTokenValidity();
      setState(() {
        if (valid) {
          loggedInUserId = uid;
        } else {
          loggedInUserId = null;
        }
      });
      if (response['success']) {
        setState(() {
          userData = response['data'];
          isLoading = false;

          List<dynamic> followersList = userData!['followers'] ?? [];
          List<dynamic> followedList = userData!['followed'] ?? [];

          userData!['followers_count'] = followersList.where((follower) {
            return follower['isBlocked'] == false &&
                follower['isFriend'] &&
                follower['id'] != widget.userId;
          }).length;

          if (widget.followersNotifier != null) {
            widget.followersNotifier!.value = followersList.where((follower) {
              return follower['isBlocked'] == false &&
                  follower['isFriend'] &&
                  follower['id'] != widget.userId;
            }).length;
          }

          userData!['followed_count'] = followedList.where((followedUser) {
            return followedUser['isBlocked'] == false &&
                followedUser['isFriend'] &&
                followedUser['id'] != widget.userId;
          }).length;

          if (loggedInUserId != null) {
            widget.isFollowedNotifier!.value = followersList.any((follower) {
              return follower['id'] == loggedInUserId &&
                  follower['isBlocked'] == false &&
                  follower['isFriend'];
            });

            widget.blockedNotifier!.value = followersList.any((follower) {
              return follower['id'] == loggedInUserId &&
                  (follower['isBlocked'] ?? false);
            });
          }

          followers = followersList.where((follower) {
            return follower['isBlocked'] == false &&
                follower['isFriend'] == true &&
                follower['id'] != widget.userId;
          }).toList();

          followed = followedList.where((followedUser) {
            return followedUser['isBlocked'] == false &&
                followedUser['isFriend'] &&
                followedUser['id'] != widget.userId;
          }).toList();
        });
      } else {
        setState(() {
          errorMessage =
              response['message'] ?? 'Error fetching current user data';
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
          fetchUserData();
          fetchCurrentUserData();
        } else {
          throw Exception(response['message']);
        }
      } else {
        final response = await FriendService.addFriend(userId: widget.userId);
        if (response['success']) {
          userData!['followers_count'] = userData!['followers_count'] + 1;
          widget.followersNotifier!.value++;
          fetchUserData();
          fetchCurrentUserData();
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
    if (isLoading || isLoadingCurrentUser) {
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
            colors: [AppColors.darkGreen, AppColors.mediumGreen],
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            image: userData!['profile_picture'] != null &&
                                    userData!['profile_picture'] != ''
                                ? DecorationImage(
                                    image: NetworkImage(
                                        userData!['profile_picture']),
                                    fit: BoxFit.cover)
                                : null,
                          ),
                          child: (userData!['profile_picture'] != null &&
                                      userData!['profile_picture'] == '') ||
                                  userData!['profile_picture'] == null
                              ? const Icon(Icons.person,
                                  size: 40, color: Colors.white)
                              : null,
                        ),
                        if (userData != null && userData!['isAdmin'] == true)
                          Positioned(
                            bottom: -1.5,
                            right: 0,
                            child: Icon(
                              Icons.verified,
                              color: AppColors.lightestGreen,
                              size: 22,
                            ),
                          ),
                      ],
                    ),
                  ],
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
                            (widget.gamesCounter).toString(),
                            'Games   ',
                            Icons.videogame_asset,
                          ),
                          _buildClickableStatColumn(
                            context,
                            userData!['followed_count']?.toString() ?? '0',
                            'Followed ',
                            Icons.person_search,
                            FollowersPage(
                              users: followed,
                              currentUser: widget.currentUser,
                              currentFollowed: currentUserFollowed,
                              blockedNotifier: widget.blockedNotifier,
                              onFollow: fetchCurrentUserData,
                            ),
                          ),
                          if (widget.followersNotifier != null)
                            ValueListenableBuilder<int>(
                              valueListenable: widget.followersNotifier!,
                              builder: (context, followersCount, child) {
                                return _buildClickableStatColumn(
                                  context,
                                  followersCount.toString(),
                                  'Followers',
                                  Icons.group,
                                  FollowersPage(
                                    users: followers,
                                    currentUser: widget.currentUser,
                                    currentFollowed: currentUserFollowed,
                                    blockedNotifier: widget.blockedNotifier,
                                    onFollow: fetchCurrentUserData,
                                  ),
                                );
                              },
                            ),
                          if (widget.followersNotifier == null)
                            _buildClickableStatColumn(
                              context,
                              userData!['followers_count']?.toString() ?? '0',
                              'Followers',
                              Icons.group,
                              FollowersPage(
                                users: followers,
                                currentUser: widget.currentUser,
                                currentFollowed: currentUserFollowed,
                                blockedNotifier: widget.blockedNotifier,
                                onFollow: fetchCurrentUserData,
                              ),
                            )
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
                  child: Row(
                    children: [
                      // Il nome utente, che andrà a capo se troppo lungo
                      Expanded(
                        child: Text(
                          '${userData!['username']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.start,
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Pulsante di follow/unfollow o unblock
                      if (loggedInUserId != null)
                        ValueListenableBuilder<bool>(
                          valueListenable: widget.blockedNotifier!,
                          builder: (context, isBlocked, child) {
                            return TextButton(
                              onPressed:
                                  widget.currentUser == null || isButtonDisabled
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
                                backgroundColor: widget.currentUser == null
                                    ? Colors
                                        .grey // Grigio per utente corrente nullo
                                    : (isBlocked
                                        ? Colors
                                            .orange // Colore per il pulsante "Unblock"
                                        : (widget.isFollowedNotifier!.value
                                            ? const Color(
                                                0xFF871C1C) // Colore per "Unfollow"
                                            : const Color(0xBE17A828))),
                                // Colore per "Follow"
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 9.0, horizontal: 15.0),
                                // Maggiore padding
                                textStyle: const TextStyle(
                                    fontSize: 16), // Font uniforme per entrambi
                              ),
                              child: Text(
                                widget.currentUser == null
                                    ? 'Follow'
                                    : (isBlocked
                                        ? 'Unblock'
                                        : (widget.isFollowedNotifier!.value
                                            ? 'Unfollow'
                                            : 'Follow')),
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
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
