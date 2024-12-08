import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_review.dart';
import 'package:gamerverse/services/specific_game/review_service.dart';
import 'package:gamerverse/widgets/profile_or_users/reviews/game_review_card.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';

class ProfileReviews extends StatefulWidget {
  final String userId;
  final String? currentUser;

  const ProfileReviews(
      {super.key, required this.userId, required this.currentUser});

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

  //load all the reviews of the user
  void _loadReviews() {
    setState(() {
      _reviewsFuture = ReviewService.getReviewsByUserId(userId: widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      body: Column(
        children: [
          FutureBuilder<List<GameReview>?>(
            future: _reviewsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.teal));
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return NoDataList(
                  textColor: Colors.grey[400],
                  icon: Icons.reviews_outlined,
                  message: 'No reviews have been written yet.',
                  subMessage: 'Start sharing thoughts about games you enjoy!',
                  color: Colors.grey[500]!,
                );
              }

              List<GameReview> reviews = snapshot.data!;

              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    GameReview review = reviews[index];
                    return GameReviewCard(
                      gameReview: review,
                      gameContext: parentContext,
                      onReviewRemoved: () {
                        _loadReviews();
                      },
                      currentUser: widget.currentUser,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
