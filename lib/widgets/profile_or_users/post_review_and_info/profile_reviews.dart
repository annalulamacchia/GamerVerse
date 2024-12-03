import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_review.dart';
import 'package:gamerverse/services/specific_game/review_service.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/profile_info_card.dart';
import 'package:gamerverse/widgets/profile_or_users/profile_tab_bar.dart';
import 'package:gamerverse/widgets/profile_or_users/game_review_card.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart'; // Import the GameReviewCard widget

class ProfileReviews extends StatefulWidget {
  final String userId; // Accept userId in constructor

  const ProfileReviews({super.key, required this.userId}); // Constructor now takes userId

  @override
  State<ProfileReviews> createState() => _ProfileReviewsPageState();
}

class _ProfileReviewsPageState extends State<ProfileReviews> {
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
      body: Column(
        children: [
         Expanded(
            child: FutureBuilder<List<GameReview>?>( // Fetch user reviews
              future: _reviewsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                      userId: widget.userId, // Pass userId to GameReviewCard
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
    );
  }
}
