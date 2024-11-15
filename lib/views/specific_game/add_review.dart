import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AddReview extends StatefulWidget {
  final VoidCallback onSubmit;

  const AddReview({super.key, required this.onSubmit});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  int _rating = 1;
  final TextEditingController _reviewController = TextEditingController();

  //function to set the rating near the clicked ghosts
  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              Text(
                _rating.toString(),
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: const TextSelectionThemeData(
                selectionHandleColor: Colors.teal,
              ),
            ),
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
                  borderSide: BorderSide(color: Colors.teal),
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
              onPressed: () {
                widget.onSubmit();
                _reviewController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: const Text(
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
