import 'package:flutter/material.dart';
import 'package:gamerverse/services/specific_game/review_service.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:gamerverse/widgets/common_sections/dialog_helper.dart';
import 'package:hugeicons/hugeicons.dart';

class AddReview extends StatefulWidget {
  final String? userId;
  final String gameId;
  final VoidCallback onReviewAdded;

  const AddReview(
      {super.key,
      required this.userId,
      required this.gameId,
      required this.onReviewAdded});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  int _rating = 1;
  final TextEditingController _reviewController = TextEditingController();
  bool _isLoading = false;
  bool _isLoadingExistingReview = true;
  Map<String, dynamic>? review;

  @override
  void initState() {
    super.initState();
    _loadExistingReview();
  }

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  //load an existing review
  Future<void> _loadExistingReview() async {
    review = await ReviewService.getReview(
      writerId: widget.userId,
      gameId: widget.gameId,
    );

    if (review != null) {
      setState(() {
        _rating = review?['rating'];
        _reviewController.text = review?['description'];
      });
    }
    setState(() {
      _isLoadingExistingReview = false;
    });
  }

  //add the review
  Future<void> _submitReview() async {
    setState(() {
      _isLoading = true;
    });
    print(review?['review_id']);

    bool success = await ReviewService.addReview(
        reviewId: review?['review_id'],
        userId: widget.userId,
        gameId: widget.gameId,
        description: _reviewController.text,
        rating: _rating,
        timestamp: DateTime.now().toUtc().toIso8601String());

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.of(context).pop();
      //if the review is modified, shows a success modal
      if (review != null) {
        DialogHelper.showSuccessDialog(
            context, "Review modified successfully!");
      } else {
        //if the review is added, shows a success modal
        DialogHelper.showSuccessDialog(context, "Review added successfully!");
      }
      widget.onReviewAdded();
    } else {
      //if the user have not played the game, shows an error modal
      DialogHelper.showErrorDialog(context,
          "You are not playing or you don't have completed this game. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isLoadingExistingReview
              ? Center(
                  child: Opacity(
                    opacity: 0,
                    child: CircularProgressIndicator(color: Colors.teal),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //5 ghosts Rating
                    ...List.generate(5, (index) {
                      return IconButton(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedPacman02,
                          color: index < _rating ? Colors.amber : Colors.grey,
                          size: 35.0,
                        ),
                        onPressed: () => _setRating(index + 1),
                      );
                    }),
                    const SizedBox(width: 15),
                    //Text rating
                    Text(
                      _rating.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 16),
          _isLoadingExistingReview
              ? Center(
                  child: Opacity(
                    opacity: 0,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: const TextSelectionThemeData(
                        selectionHandleColor: AppColors.mediumGreen,
                        cursorColor: AppColors.mediumGreen,
                        selectionColor: AppColors.mediumGreen),
                  ),
                  //Text Area
                  child: TextField(
                    controller: _reviewController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write your review here...',
                      hintStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.mediumGreen),
                      ),
                    ),
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white70),
                    cursorColor: Colors.white70,
                  ),
                ),
          const SizedBox(height: 16),

          //Post Button
          Center(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mediumGreen,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text(
                      'Post',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
