import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/profile_or_users/reviews/profile_reviews.dart';
import 'package:gamerverse/widgets/profile_or_users/posts/profile_posts.dart';
import 'package:gamerverse/widgets/profile_or_users/games/profile_games.dart';
import 'package:gamerverse/widgets/profile_or_users/posts/user_posts.dart';

class TabBarSection extends StatefulWidget {
  final String? currentUser;
  final int mode;
  final int selected;
  final String? userId;

  const TabBarSection({
    super.key,
    required this.mode,
    required this.selected,
    this.userId,
    required this.currentUser,
  });

  @override
  TabBarSectionState createState() => TabBarSectionState();
}

class TabBarSectionState extends State<TabBarSection> {
  late int _currentTabIndex;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 2.5, bottom: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                // Usa Expanded per distribuire equamente i tab
                child: _buildTabButton(
                  context,
                  'Games',
                  _currentTabIndex == 0 ? Colors.green : Colors.black,
                  () => _onTabSelected(0),
                ),
              ),
              Expanded(
                child: _buildTabButton(
                  context,
                  'Reviews',
                  _currentTabIndex == 1 ? Colors.green : Colors.black,
                  () => _onTabSelected(1),
                ),
              ),
              Expanded(
                child: _buildTabButton(
                  context,
                  'Post',
                  _currentTabIndex == 2 ? Colors.green : Colors.black,
                  () => _onTabSelected(2),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        // Usa SingleChildScrollView per permettere lo scorrimento del contenuto
        Expanded(child: _buildTabContent()),
        // Assicura che il contenuto delle tab occupi lo spazio rimanente
      ],
    );
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  Widget _buildTabContent() {
    if (_currentTabIndex == 0) {
      return _buildProfileGamesWidget();
    }
    if (_currentTabIndex == 1) {
      return _buildProfileReviewsWidget();
    }
    if (widget.mode == 0 && _currentTabIndex == 2) {
      return _buildProfilePostsWidget();
    } else if (widget.mode == 1 && _currentTabIndex == 2) {
      return _buildUserPostsWidget();
    } else {
      return const Center(child: Text('Invalid mode'));
    }
  }

  Widget _buildTabButton(
    BuildContext context,
    String text,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Widget per il profilo dell'utente (mode == 0)
  Widget _buildProfileGamesWidget() {
    if (widget.userId == null) {
      return const Center(child: Text('User not found'));
    }
    return ProfileGames(userId: widget.userId!);
  }

  Widget _buildProfileReviewsWidget() {
    if (widget.userId == null) {
      return const Center(child: Text('User not found'));
    }
    return ProfileReviews(
      userId: widget.userId!,
      currentUser: widget.currentUser,
    );
  }

  Widget _buildProfilePostsWidget() {
    return ProfilePosts(
        userId: widget.userId!, currentUser: widget.currentUser);
  }

  Widget _buildUserPostsWidget() {
    return UserPosts(
        userId: widget.userId!,
        currentUser: widget.currentUser); // Passa userId
  }
}
