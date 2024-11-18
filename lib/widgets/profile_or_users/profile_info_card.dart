import 'package:flutter/material.dart';
import 'package:gamerverse/views/common_sections/followers_or_following_page.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xff8eb69b),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAvatar(),
                _buildStatColumn('10', 'Games'),
                _buildClickableStatColumn(
                    context, '10', 'Followed', const FollowersPage()),
                _buildClickableStatColumn(
                    context, '10', 'Followers', const FollowersPage()),
              ],
            ),
            _buildName()
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
      ),
      child: const Icon(Icons.person, size: 40),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(count,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildClickableStatColumn(
      BuildContext context, String count, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: _buildStatColumn(count, label),
    );
  }

  Widget _buildName() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 25.0, right: 8),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Jack Bab',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
