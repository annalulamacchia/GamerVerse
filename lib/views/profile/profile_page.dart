import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_profile.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/profile_or_users/info/profile_info_card.dart';
import 'package:gamerverse/widgets/profile_or_users/info/profile_tab_bar.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gamerverse/services/specific_game/wishlist_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late Future<String> userIdFuture;
  List<GameProfile> wishlist = [];
  int gamesCounter = 0;
  bool isLoading = true;
  final ValueNotifier<bool>? gamesLoadingNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    userIdFuture = _loadUserId();
    _loadWishlist(userIdFuture);
  }

  Future<String> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_uid') ?? 'default_user';
  }

  Future<void> _loadWishlist(Future<String> userIdFuture) async {
    try {
      final userId = await userIdFuture;
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
    return Scaffold(
      backgroundColor: AppColors.darkestGreen,
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        title: const Text('My Profile', style: TextStyle(color: Colors.white)),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/profileSettings');
            },
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: userIdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          } else if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          } else if (snapshot.hasData) {
            return _buildContent(snapshot.data!);
          } else {
            return _buildNoData();
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 2,
      ),
    );
  }

  Widget _buildLoading() =>
      const Center(child: CircularProgressIndicator(color: Colors.teal));

  Widget _buildError(String error) => Center(child: Text('Error: $error'));

  Widget _buildContent(String userId) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ProfileInfoCard(
                gamesCounter: gamesCounter, currentUser: userId),
          ),
          Expanded(
            child: TabBarSection(
              mode: 0,
              selected: 0,
              userId: userId,
              currentUser: userId,
              wishlist: wishlist.isNotEmpty ? wishlist : [],
              gamesLoadingNotifier: gamesLoadingNotifier,
            ),
          ),
        ],
      );

  Widget _buildNoData() => const Center(child: Text('No data available'));
}
