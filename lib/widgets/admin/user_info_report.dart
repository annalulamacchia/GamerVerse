import 'package:flutter/material.dart';
import 'package:gamerverse/models/report.dart';

class UserInfo extends StatelessWidget {
  final String title;
  final Report report;

  const UserInfo({super.key, required this.title, required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xff1c463f),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Profile Picture, Name and Username
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Avatar
              CircleAvatar(
                backgroundImage: report
                            .additionalUserInfo?.profilePicture.isNotEmpty ??
                        false
                    ? NetworkImage(report.additionalUserInfo!.profilePicture)
                    : null,
                child: report.additionalUserInfo?.profilePicture.isEmpty ?? true
                    ? Icon(Icons.person, size: 40)
                    : null,
              ),
              const SizedBox(height: 8),

              //Name
              if (title == 'Users' || title == 'Temporary Blocked Users')
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/userProfile', arguments: report.reportedId);
                  },
                  child: Text(
                    report.additionalUserInfo!.name,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              if (title == 'Permanently Blocked Users')
                const Text(
                  'Name',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),

              //Username
              Text(
                report.additionalUserInfo!.username,
                style: TextStyle(fontSize: 14, color: Colors.white54),
              ),
            ],
          ),

          //Games, Followed and Followers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Games
              Column(
                children: [
                  Text(report.additionalUserInfo!.numberGames.toString(),
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                  Text('Game',
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                ],
              ),
              SizedBox(width: 24),

              //Followed
              Column(
                children: [
                  Text(report.additionalUserInfo!.followed.toString(),
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                  Text('Followed',
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                ],
              ),
              SizedBox(width: 24),

              //Followers
              Column(
                children: [
                  Text(report.additionalUserInfo!.followers.toString(),
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                  Text('Follower',
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
