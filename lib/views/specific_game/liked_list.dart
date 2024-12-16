import 'package:flutter/material.dart';
import 'package:gamerverse/models/user.dart';
import 'package:gamerverse/services/user/Get_user_info.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/info/user_follower_card.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';

class LikedList extends StatefulWidget {
  final List<User> users;
  final String? currentUser;
  final String gameName;

  const LikedList(
      {super.key,
      required this.users,
      this.currentUser,
      required this.gameName});

  @override
  LikedListState createState() => LikedListState();
}

class LikedListState extends State<LikedList> {
  int itemCount = 0;
  Map<String, dynamic>? currentUserData;
  bool isLoadingCurrentUser = true;
  String errorMessage = '';
  List<dynamic> currentUserFollowed = [];

  @override
  void initState() {
    super.initState();
    itemCount = widget.users.length;
    fetchCurrentUserData();
  }

  Future<void> fetchCurrentUserData() async {
    try {
      final response =
          await UserProfileService.getUserByUid(widget.currentUser);
      if (response['success']) {
        setState(() {
          currentUserData = response['data'];
          isLoadingCurrentUser = false;

          currentUserFollowed = currentUserData!['followed'] ?? [];
        });
      } else {
        setState(() {
          errorMessage = response['message'] ?? 'Error fetching user data';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.gameName, style: TextStyle(color: Colors.white)),
      ),

      //list of all the users that liked a specific game
      body: itemCount == 0
          ? NoDataList(
              icon: Icons.favorite_border,
              message:
                  'Looks like no one has added this game to their wishlist yet.',
              subMessage: 'Why not be the first to show some love?',
              color: Colors.pinkAccent,
              textColor: Colors.white,
            )
          : ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, index) {
                bool isIdInFollowed = false;
                bool isBlocked = false;
                final user = (widget.users)[index];

                isIdInFollowed = currentUserFollowed.any((followed) =>
                    followed['id'] == user.userId &&
                    followed['isFriend'] == true &&
                    followed['isBlocked'] == false);
                isBlocked = currentUserFollowed.any((followed) =>
                    followed['id'] == user.userId &&
                    followed['isBlocked'] == true);

                return UserCard(
                  index: user.userId,
                  username: user.username,
                  profilePicture: user.profilePicture ?? '',
                  onTap: () {
                    if (user.userId != widget.currentUser) {
                      Navigator.pushNamed(context, '/userProfile',
                          arguments: user.userId);
                    } else {
                      Navigator.pushNamed(context, '/profile',
                          arguments: user.userId);
                    }
                  },
                  isBlocked: isBlocked,
                  isFollowed: isIdInFollowed,
                  parentContext: context,
                  currentUser: widget.currentUser,
                );
              },
            ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
      ),
    );
  }
}
