import 'package:flutter/material.dart';
import 'package:gamerverse/models/report.dart';
import 'package:gamerverse/services/report_service.dart';
import 'package:gamerverse/utils/colors.dart';

class UserInfo extends StatefulWidget {
  final String title;
  final Report report;

  const UserInfo({super.key, required this.title, required this.report});

  @override
  UserInfoState createState() => UserInfoState();
}

class UserInfoState extends State<UserInfo> {
  Future<dynamic>? additionalInfoFuture;

  @override
  void initState() {
    super.initState();
    additionalInfoFuture = ReportService.getAdditionalInfo(
      reportType: widget.report.type,
      reportedId: widget.report.reportedId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: additionalInfoFuture,
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

        // Casting snapshot data to specific class based on report type
        final additionalInfo = snapshot.data;
        if (additionalInfo == null) {
          return Center(
            child: Text(
              'No additional info found',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return _buildUserInfo(additionalInfo);
      },
    );
  }

  Widget _buildUserInfo(dynamic additionalInfo) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.mediumMediumGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prima riga: Avatar, Games, Followed, Followers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Avatar
              CircleAvatar(
                backgroundImage: widget.report.profilePicture.isNotEmpty
                    ? NetworkImage(widget.report.profilePicture)
                    : null,
                child: widget.report.profilePicture.isEmpty
                    ? Icon(Icons.person, size: 40)
                    : null,
              ),

              // Games, Followed, and Followers
              Row(
                children: [
                  // Games
                  Column(
                    children: [
                      Text(
                        additionalInfo.numberGames.toString(),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        'Games',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(width: 24),

                  // Followed
                  Column(
                    children: [
                      Text(
                        additionalInfo.followed.toString(),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        'Followed',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(width: 24),

                  // Followers
                  Column(
                    children: [
                      Text(
                        additionalInfo.followers.toString(),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        'Followers',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Seconda riga: Name e Username
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              if (widget.title == 'Users' ||
                  widget.title == 'Temporarily Blocked Users')
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/userProfile',
                      arguments: widget.report.reportedId,
                    );
                  },
                  child: SizedBox(
                    width: 275,
                    child: Text(
                      additionalInfo.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              // Username
              SizedBox(
                width: 275,
                child: Text(
                  widget.report.username,
                  style: TextStyle(fontSize: 14, color: Colors.white54),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
