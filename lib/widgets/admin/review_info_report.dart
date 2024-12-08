import 'package:flutter/material.dart';
import 'package:gamerverse/models/report.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewInfoReport extends StatefulWidget {
  final Report report;

  const ReviewInfoReport({super.key, required this.report});

  @override
  ReviewInfoReportState createState() => ReviewInfoReportState();
}

class ReviewInfoReportState extends State<ReviewInfoReport> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff1c463f),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Game Image, username and rating
          Row(
            children: [
              //Game Image
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/game',
                      arguments: int.parse(
                          widget.report.additionalReviewInfo!.gameId));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    widget.report.additionalReviewInfo!.gameCover,
                    width: 50,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Username
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/userProfile',
                          arguments:
                              widget.report.additionalReviewInfo!.writerId);
                    },
                    child: Text(
                      widget.report.additionalReviewInfo!.username,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),

                  // Rating
                  Row(
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedPacman02,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.report.additionalReviewInfo!.rating.toString(),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),

              //Status of the game
              const Text(
                'Playing', // Display timestamp
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Review
          Text(
            widget.report.additionalReviewInfo!.description,
            style: const TextStyle(fontSize: 14, color: Colors.white),
            maxLines: _isExpanded
                ? widget.report.additionalReviewInfo!.description.length
                : 2,
            overflow: TextOverflow.ellipsis,
          ),

          // View More / View Less
          if (widget.report.additionalReviewInfo!.description
                  .toUpperCase()
                  .length >
              74)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? 'View Less' : 'View More',
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 15),

          // Like and Dislike
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Timestamp
              Text(
                widget.report.additionalReviewInfo!.timestamp != ""
                    ? timeago.format(DateTime.parse(
                        widget.report.additionalReviewInfo!.timestamp))
                    : "", // Display timestamp
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
              const Spacer(),

              //Likes
              const Icon(Icons.thumb_up_outlined, color: Colors.white54),
              const SizedBox(width: 2.5),
              Text(widget.report.additionalReviewInfo!.numberLikes.toString(),
                  style: const TextStyle(color: Colors.white54)),
              const SizedBox(width: 15),

              //Dislikes
              const Icon(Icons.thumb_down_outlined, color: Colors.white54),
              const SizedBox(width: 2.5),
              Text(
                  widget.report.additionalReviewInfo!.numberDislikes.toString(),
                  style: const TextStyle(color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
