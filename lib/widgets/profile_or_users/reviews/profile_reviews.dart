import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_review.dart';
import 'package:gamerverse/services/specific_game/review_service.dart';
import 'package:gamerverse/widgets/profile_or_users/reviews/game_review_card.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';

class ProfileReviews extends StatefulWidget {
  final String userId;
  final String? currentUser;
  final ValueNotifier<bool>? blockedNotifier;

  const ProfileReviews({
    super.key,
    required this.userId,
    required this.currentUser,
    this.blockedNotifier,
  });

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

  // Load all the reviews of the user
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
          // This part ensures that the blocked status is only checked if the current user is different from the profile user.
          if (widget.currentUser != widget.userId)
            ValueListenableBuilder<bool>(
              valueListenable: widget.blockedNotifier!,
              builder: (context, isBlocked, child) {
                // If the user is blocked, show a NoDataList widget
                if (isBlocked) {
                  return NoDataList(
                    textColor: Colors.grey[400],
                    icon: Icons.reviews_outlined,
                    message: 'The User is Blocked!',
                    subMessage: 'Please, unblock to see their reviews.',
                    color: Colors.grey[500]!,
                  );
                }

                // If the user is not blocked, show the reviews list
                return FutureBuilder<List<GameReview>?>(
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
                        subMessage:
                            'Start sharing thoughts about games you enjoy!',
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
                );
              },
            ),
          // If currentUser is equal to userId, we just show the reviews without blocked notifier logic.
          if (widget.currentUser == widget.userId)
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
