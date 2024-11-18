import 'package:flutter/material.dart';
import 'package:gamerverse/views/other_user_profile/user_profile_page.dart';

class UserInfo extends StatelessWidget {
  final String title;

  const UserInfo({super.key, required this.title});

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
              const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  'https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg', // URL dell'immagine utente
                ),
              ),
              const SizedBox(height: 8),

              //Name
              if (title == 'Users' || title == 'Temporary Blocked Users')
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserProfilePage()),
                    );
                  },
                  child: const Text(
                    'Name',
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
              const Text(
                'Username',
                style: TextStyle(fontSize: 14, color: Colors.white54),
              ),
            ],
          ),

          //Games, Followed and Followers
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Games
              Column(
                children: [
                  Text('10',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                  Text('Game',
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                ],
              ),
              SizedBox(width: 24),

              //Followed
              Column(
                children: [
                  Text('10',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                  Text('Followed',
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                ],
              ),
              SizedBox(width: 24),

              //Followers
              Column(
                children: [
                  Text('10',
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
