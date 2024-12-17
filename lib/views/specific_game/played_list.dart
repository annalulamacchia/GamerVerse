import 'package:flutter/material.dart';
import 'package:gamerverse/models/game.dart';
import 'package:gamerverse/models/review.dart';
import 'package:gamerverse/services/specific_game/review_service.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';
import 'package:gamerverse/widgets/specific_game/single_review.dart';

class PlayedList extends StatefulWidget {
  final Game game;
  final String? userId;

  const PlayedList({super.key, required this.game, this.userId});

  @override
  PlayedListState createState() => PlayedListState();
}

class PlayedListState extends State<PlayedList> {
  late Future<List<Review>> _reviewsFuture;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  //load all the reviews without description or all the users that are playing, have completed a game, but not reviewed yet
  void _loadReviews() {
    setState(() {
      _reviewsFuture =
          ReviewService.fetchReviewsByStatus(gameId: widget.game.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
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
        title: Text(widget.game.name, style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<List<Review>?>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.teal));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return NoDataList(
              textColor: Colors.grey[400],
              icon: Icons.reviews_outlined,
              message: 'No reviews available.',
              subMessage: 'Be the first to share your thoughts!',
              color: Colors.grey[500]!,
            );
          }

          List<Review> reviews = snapshot.data!;

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              Review review = reviews[index];
              return SingleReview(
                  userId: widget.userId,
                  review: review,
                  gameContext: parentContext,
                  onReviewRemoved: () {
                    _loadReviews();
                  });
            },
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
      ),
    );
  }
}
