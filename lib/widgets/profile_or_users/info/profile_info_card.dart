import 'package:flutter/material.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/views/profile/followers_or_following_page.dart';
import 'package:gamerverse/services/user/Get_user_info.dart';

class ProfileInfoCard extends StatefulWidget {
  final int gamesCounter;
  final String currentUser;

  const ProfileInfoCard(
      {super.key, required this.gamesCounter, required this.currentUser});

  @override
  State<ProfileInfoCard> createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends State<ProfileInfoCard> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';
  List<dynamic> followers = [];
  List<dynamic> followed = [];
  ValueNotifier<int>? followedNotifier = ValueNotifier<int>(0);

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

        List<dynamic> followersList = userData!['data']['followers'] ?? [];
        List<dynamic> followedList = userData!['data']['followed'] ?? [];

        userData!['data']['followers_count'] = followersList.where((follower) {
          return follower['isBlocked'] == false &&
              follower['isFriend'] &&
              follower['id'] != widget.currentUser;
        }).length;

        userData!['data']['followed_count'] =
            followedList.where((followedUser) {
          return followedUser['isBlocked'] == false &&
              followedUser['isFriend'] &&
              followedUser['id'] != widget.currentUser;
        }).length;

        followedNotifier!.value = userData!['data']['followed_count'];

        followed = followedList.where((followedUser) {
          return followedUser['isBlocked'] == false &&
              followedUser['isFriend'] &&
              followedUser['id'] != widget.currentUser;
        }).toList();

        followers = followersList.where((follower) {
          return follower['isBlocked'] == false &&
              follower['isFriend'] &&
              follower['id'] != widget.currentUser;
        }).toList();
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
            colors: [AppColors.darkGreen, AppColors.mediumGreen],
            // Gradiente della card precedente
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
            // Profile picture + statistics on the same row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatarWithName(
                  userData!['data']!['profile_picture'],
                  userData!['data']!['username'],
                ),
                const SizedBox(width: 16),
                // Space between the avatar and the stats
                Expanded(
                  child: Column(
                    children: [
                      // Row for statistics (Games, Followed, Followers)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn(
                            context,
                            (widget.gamesCounter).toString(),
                            'Games   ',
                            Icons.videogame_asset,
                          ),
                          if (followedNotifier != null)
                            ValueListenableBuilder<int>(
                              valueListenable: followedNotifier!,
                              builder: (context, followedCount, child) {
                                return _buildClickableStatColumn(
                                  context,
                                  followedCount.toString(),
                                  'Followed ',
                                  Icons.person_search,
                                  FollowersPage(
                                      users: followed,
                                      currentUser: widget.currentUser,
                                      currentFollowed: followed,
                                      followedNotifier: followedNotifier,
                                      onFollow: fetchUserData),
                                );
                              },
                            ),
                          if (followedNotifier == null)
                            _buildClickableStatColumn(
                              context,
                              userData!['data']['followed_count']?.toString() ??
                                  '0',
                              'Followed ',
                              Icons.person_search,
                              FollowersPage(
                                users: followed,
                                currentUser: widget.currentUser,
                                currentFollowed: followed,
                                followedNotifier: followedNotifier,
                                onFollow: fetchUserData,
                              ),
                            ),
                          _buildClickableStatColumn(
                            context,
                            userData!['data']['followers_count']?.toString() ??
                                '0',
                            'Followers',
                            Icons.group,
                            FollowersPage(
                                users: followers,
                                currentUser: widget.currentUser,
                                currentFollowed: followed,
                                followedNotifier: followedNotifier,
                                onFollow: fetchUserData),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Username in a separate row
            const SizedBox(height: 12.5), // Space between stats and username
            Text(
              userData!['data']!['username'] ?? 'Unknown User',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.start,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarWithName(String? profilePictureUrl, String username) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            image: profilePictureUrl != null && profilePictureUrl != ''
                ? DecorationImage(
                    image: NetworkImage(profilePictureUrl), fit: BoxFit.cover)
                : null,
          ),
          child: profilePictureUrl != null && profilePictureUrl == ''
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
