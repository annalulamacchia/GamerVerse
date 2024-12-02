import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_review.dart';
import 'package:gamerverse/services/specific_game/review_service.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/profile_info_card.dart';
import 'package:gamerverse/widgets/profile_or_users/profile_tab_bar.dart';
import 'package:gamerverse/widgets/profile_or_users/game_review_card.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart'; // Import the GameReviewCard widget

class ProfileReviewsPage extends StatefulWidget {
  final String userId;

  const ProfileReviewsPage({super.key, required this.userId});

  @override
  State<ProfileReviewsPage> createState() => _ProfileReviewsPageState();
}

class _ProfileReviewsPageState extends State<ProfileReviewsPage> {
  late Future<List<GameReview>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  void _loadReviews() {
    setState(() {
      _reviewsFuture = ReviewService.getReviewsByUserId(userId: widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    return Scaffold(
      backgroundColor: const Color(0xff051f20), // Dark background for the page
      appBar: AppBar(
        title: const Text(
          'Username', // Replace with dynamic username if needed
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff163832), // Dark green for the app bar
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), // Settings icon
            onPressed: () {
              // Navigate to settings page
              Navigator.pushNamed(context, '/profileSettings');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const ProfileInfoCard(), // User profile information card
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: TabBarSection(mode: 0, selected: 1), // Profile tab bar
          ),
          // Reviews Section
          Expanded(
            child: FutureBuilder<List<GameReview>?>(
              future: _reviewsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return NoDataList(
                    textColor: Colors.grey[400],
                    icon: Icons.reviews_outlined,
                    message: 'You haven\'t written any reviews yet.',
                    subMessage:
                        'Start sharing your thoughts about games you love!',
                    color: Colors.grey[500]!,
                  );
                }

                List<GameReview> reviews = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    GameReview review = reviews[index];
                    return GameReviewCard(
                      gameReview: review,
                      userId: widget.userId,
                      gameContext: parentContext,
                      onReviewRemoved: () {
                        _loadReviews();
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 2, // Set the current tab index for navigation
      ),
    );
  }
}
