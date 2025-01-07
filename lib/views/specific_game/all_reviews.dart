import 'package:flutter/material.dart';
import 'package:gamerverse/models/game.dart';
import 'package:gamerverse/models/review.dart';
import 'package:gamerverse/services/specific_game/review_service.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/views/specific_game/add_review.dart';
import 'package:gamerverse/widgets/specific_game/no_data_list.dart';
import 'package:gamerverse/widgets/specific_game/single_review.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';

class ReviewPage extends StatefulWidget {
  final String? userId;
  final Game game;
  final Future<void> Function() onLoadAverageRating;
  final ValueNotifier<double> averageUserReviewNotifier;
  final ValueNotifier<Review> latestReviewNotifier;

  final Future<void> Function() onLoadLatestReview;

  const ReviewPage(
      {super.key,
      required this.userId,
      required this.game,
      required this.onLoadAverageRating,
      required this.averageUserReviewNotifier,
      required this.latestReviewNotifier,
      required this.onLoadLatestReview});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late Future<List<Review>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  //load all the reviews of a specific game
  void _loadReviews() {
    setState(() {
      _reviewsFuture = ReviewService.fetchReviewsByGame(gameId: widget.game.id);
    });
  }

  //redirect to login if the user is not logged
  void _toLoginForReview(BuildContext context) {
    Navigator.pushNamed(context, '/login', arguments: widget.game.id);
  }

  //function to show the modal to Add Review
  void _showAddReviewForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddReview(
            userId: widget.userId,
            gameId: widget.game.id,
            onReviewAdded: () {
              _loadReviews();
              widget.onLoadAverageRating();
              widget.onLoadLatestReview();
            },
          ),
        );
      },
    );
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
        //Game Name
        title: Text(widget.game.name, style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Game Image
            Image.network(
              widget.game.cover,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10.0),

            //Critics Rating and Users Rating
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      //Critics rating
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 20.0),
                          SizedBox(width: 5),
                          Text(
                            widget.game.criticsRating != 0
                                ? widget.game.criticsRating.toStringAsFixed(1)
                                : 'N/A',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        'Critics Review',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),

                  //Users Rating
                  ValueListenableBuilder<double>(
                      valueListenable: widget.averageUserReviewNotifier,
                      builder: (context, averageUserReview, child) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedPacman02,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  averageUserReview != 0
                                      ? averageUserReview.toString()
                                      : 'N/A',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                            Text(
                              'Users Rating',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        );
                      }),
                ],
              ),
            ),
            const Divider(height: 25),

            //All Reviews List
            FutureBuilder<List<Review>?>(
              future: _reviewsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: Colors.teal));
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
                      },
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget.userId != null
            ? _showAddReviewForm(context)
            : _toLoginForReview(context),
        backgroundColor: AppColors.mediumGreen,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
