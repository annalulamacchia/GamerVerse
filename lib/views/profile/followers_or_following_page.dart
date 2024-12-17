import 'package:flutter/material.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/profile_or_users/info/user_follower_card.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';

class FollowersPage extends StatelessWidget {
  final List<dynamic> users;
  final String? currentUser;
  final List<dynamic>? currentFollowed;

  const FollowersPage(
      {super.key,
      required this.users,
      required this.currentUser,
      this.currentFollowed});

  @override
  Widget build(BuildContext context) {
    BuildContext parentContext = context;
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        title: const Text('Friends', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.darkGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: users.isEmpty ? 1 : users.length,
        itemBuilder: (context, index) {
          if (users.isEmpty) {
            return NoDataList(
              textColor: Colors.grey,
              icon: Icons.person_outline,
              message: 'No users yet.',
              subMessage: 'Looks like there’s nothing to show at the moment.',
              color: Colors.white,
            );
          } else {
            final user = users[index];
            bool isIdInFollowed = false;
            bool isBlocked = false;
            if (currentFollowed != null) {
              isIdInFollowed = currentFollowed!.any((followed) =>
                  followed['id'] == user['id'] &&
                  followed['isFriend'] == true &&
                  followed['isBlocked'] == false);
              isBlocked = currentFollowed!.any((followed) =>
                  followed['id'] == user['id'] &&
                  followed['isBlocked'] == true);
            }
            return UserCard(
              username: user['username'],
              profilePicture: user['profilePicture'],
              index: user['id'],
              currentUser: currentUser,
              isFollowed: isIdInFollowed,
              parentContext: parentContext,
              onTap: () {
                if (user['id'] != currentUser || currentUser == null) {
                  Navigator.pushNamed(context, '/userProfile',
                      arguments: user['id']);
                } else {
                  Navigator.pushNamed(context, '/profile',
                      arguments: user['id']);
                }
              },
              isBlocked: isBlocked,
            );
          }
        },
      ),
    );
  }
}
