import 'package:flutter/material.dart';

class AddReview extends StatefulWidget {
  final VoidCallback onSubmit;

  const AddReview({super.key, required this.onSubmit});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  int _rating = 1;
  final TextEditingController _reviewController = TextEditingController();

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
        mainAxisSize: MainAxisSize.min, // Riduce l'altezza del popup
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < _rating ? Colors.amber : Colors.grey,
                    size: 40,
                  ),
                  onPressed: () => _setRating(index + 1),
                );
              }),

              const SizedBox(width: 15),

              Text(
                _rating.toString(),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 16),
          TextField(
            controller: _reviewController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Write your review here...',
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                widget.onSubmit();
                _reviewController.clear();
              },
              child: const Text('Post'),
            ),
          ),
        ],
      ),
    );
  }
}
