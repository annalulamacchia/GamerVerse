import 'package:flutter/material.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/utils/firebase_auth_helper.dart';
import 'package:gamerverse/widgets/common_sections/report_block_menu.dart';
import 'package:gamerverse/widgets/profile_or_users/info/user_info_card.dart';
import 'package:gamerverse/widgets/profile_or_users/info/profile_tab_bar.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gamerverse/services/specific_game/wishlist_service.dart';
import 'package:gamerverse/models/game_profile.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<String> userIdFuture;
  String? currentUser;
  List<GameProfile> wishlist = [];
  int gamesCounter = 0;
  bool isLoading = true;
  ValueNotifier<bool> blockedNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> isFollowedNotifier = ValueNotifier<bool>(false);
  ValueNotifier<int> followersNotifier = ValueNotifier<int>(0);
  ValueNotifier<List<dynamic>>? currentFollowedNotifier =
      ValueNotifier<List<dynamic>>([]);
  final ValueNotifier<bool>? gamesLoadingNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    userIdFuture = Future.value(widget.userId);
    _loadUserData();
    _loadWishlist(widget.userId);
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString('user_uid');
    final valid = await FirebaseAuthHelper.checkTokenValidity();

    setState(() {
      currentUser = valid ? uid : null;
    });
  }

  Future<void> _loadWishlist(String userId) async {
    try {
      final games = await WishlistService.getWishlist(userId);
      setState(() {
        wishlist = games;
        gamesCounter = games.length;
        isLoading = false;
        gamesLoadingNotifier!.value = false;
      });
    } catch (e) {
      setState(() {
        wishlist = [];
        gamesCounter = 0;
        isLoading = false;
        gamesLoadingNotifier!.value = false;
      });
      debugPrint('Error loading wishlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    BuildContext parentContext = context;
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          FutureBuilder<String>(
            future: userIdFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                if (currentUser != null) {
                  return ReportBlockMenu(
                    userId: currentUser,
                    reportedId: snapshot.data!,
                    parentContext: parentContext,
                    blockedNotifier: blockedNotifier,
                    isFollowedNotifier: isFollowedNotifier,
                    followersNotifier: followersNotifier,
                  );
                }
                return Container();
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: userIdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.teal));
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            String userId = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: UserInfoCard(
                    userId: userId,
                    gamesCounter: gamesCounter,
                    blockedNotifier: blockedNotifier,
                    isFollowedNotifier: isFollowedNotifier,
                    followersNotifier: followersNotifier,
                    currentUser: currentUser,
                    currentFollowedNotifier: currentFollowedNotifier,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    child: TabBarSection(
                      mode: 1,
                      selected: 0,
                      userId: userId,
                      currentUser: currentUser,
                      wishlist: wishlist,
                      blockedNotifier: blockedNotifier,
                      currentFollowedNotifier: currentFollowedNotifier,
                      gamesLoadingNotifier: gamesLoadingNotifier,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('No data available'),
            );
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
      ),
    );
  }
}
