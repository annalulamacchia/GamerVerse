import 'package:flutter/material.dart';
import 'package:gamerverse/models/report.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:gamerverse/services/report_service.dart';

class PostInfoReport extends StatefulWidget {
  final Report report;

  const PostInfoReport({super.key, required this.report});

  @override
  PostInfoReportState createState() => PostInfoReportState();
}

class PostInfoReportState extends State<PostInfoReport> {
  bool _isExpanded = false;
  late Future<dynamic> additionalInfo;

  @override
  void initState() {
    super.initState();
    additionalInfo = ReportService.getAdditionalInfo(
      reportType: widget.report.type,
      reportedId: widget.report.reportedId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: additionalInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.teal));
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Failed to load data: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Text(
              'No additional info available',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        // Assuming the data comes as an instance of AdditionalPostInfo
        final additionalPostInfo = snapshot.data;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xff1c463f),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Game Image, game name and username
              Row(
                children: [
                  // Game Image
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/game',
                        arguments: additionalPostInfo.gameId,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        widget.report.gameCover!,
                        width: 50,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Game Name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/game',
                            arguments: int.parse(additionalPostInfo.gameId),
                          );
                        },
                        child: SizedBox(
                          width: 220,
                          child: Text(
                            additionalPostInfo.gameName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      // Username
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/userProfile',
                            arguments: additionalPostInfo.writerId,
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 220,
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'Author: ${widget.report.username}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Post Description
              Text(
                additionalPostInfo.description,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                maxLines:
                    _isExpanded ? additionalPostInfo.description.length : 2,
                overflow: TextOverflow.ellipsis,
              ),

              // View More / View Less
              if (additionalPostInfo.description.toUpperCase().length > 74)
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
                  // Timestamp
                  Text(
                    additionalPostInfo.timestamp.isNotEmpty
                        ? timeago.format(
                            DateTime.parse(additionalPostInfo.timestamp))
                        : "", // Display timestamp
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                  const Spacer(),

                  // Likes
                  if (additionalPostInfo.father == '0')
                    Row(
                      children: [
                        const Icon(Icons.thumb_up_outlined,
                            color: Colors.white54),
                        const SizedBox(width: 2.5),
                        Text(
                          additionalPostInfo.numberLikes.toString(),
                          style: const TextStyle(color: Colors.white54),
                        ),
                        const SizedBox(width: 15),

                        // Comments
                        const Icon(Icons.comment_outlined,
                            color: Colors.white54),
                        const SizedBox(width: 2.5),
                        Text(
                          additionalPostInfo.numberComments.toString(),
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ],
                    )
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
