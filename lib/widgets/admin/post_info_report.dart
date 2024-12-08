import 'package:flutter/material.dart';
import 'package:gamerverse/models/report.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostInfoReport extends StatefulWidget {
  final Report report;

  const PostInfoReport({super.key, required this.report});

  @override
  PostInfoReportState createState() => PostInfoReportState();
}

class PostInfoReportState extends State<PostInfoReport> {
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
          //Game Image, game name and username
          Row(
            children: [
              //Game Image
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/game',
                      arguments: widget.report.additionalPostInfo!.gameId);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    widget.report.additionalPostInfo!.gameCover,
                    width: 50,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),

              //Game Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/game',
                          arguments: widget.report.additionalPostInfo!.gameId);
                    },
                    child: Text(
                      widget.report.additionalPostInfo!.gameName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),

                  //Username
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/userProfile',
                          arguments:
                              widget.report.additionalPostInfo!.writerId);
                    },
                    child: Row(
                      children: [
                        Text(
                          'Author: ${widget.report.additionalPostInfo!.username}',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 15),

          //Post
          Text(
            widget.report.additionalPostInfo!.description,
            style: const TextStyle(fontSize: 14, color: Colors.white),
            maxLines: _isExpanded
                ? widget.report.additionalPostInfo!.description.length
                : 2,
            overflow: TextOverflow.ellipsis,
          ),

          // View More / View Less
          if (widget.report.additionalPostInfo!.description
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

          // Like and Comments
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Timestamp
              Text(
                widget.report.additionalPostInfo!.timestamp != ""
                    ? timeago.format(DateTime.parse(
                        widget.report.additionalPostInfo!.timestamp))
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
              Text(widget.report.additionalPostInfo!.numberLikes.toString(),
                  style: const TextStyle(color: Colors.white54)),
              const SizedBox(width: 15),

              //Comments
              const Icon(Icons.comment_outlined, color: Colors.white54),
              const SizedBox(width: 2.5),
              Text(widget.report.additionalPostInfo!.numberComments.toString(),
                  style: const TextStyle(color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
