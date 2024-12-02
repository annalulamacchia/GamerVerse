import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/user_info_card.dart'; // Replace ProfileInfoCard with UserInfoCard
import 'package:gamerverse/widgets/profile_or_users/profile_tab_bar.dart';
import 'package:gamerverse/widgets/profile_or_users/game_review_card.dart'; // Import the GameReviewCard widget

class UserReviewPage extends StatelessWidget {
  const UserReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for reviews (replace with actual data)
    final List<Map<String, dynamic>> reviews = [
      {
        "gameName": "Game 1",
        "rating": 4.5,
        "comment": "Amazing game with stunning graphics and engaging gameplay!",
        "gameUrl":
            "https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg",
        "likes": 15,
        "dislikes": 2,
      },
      {
        "gameName": "Game 2",
        "rating": 2.5,
        "comment": "Decent, but could use some improvements.",
        "gameUrl":
            "https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg",
        "likes": 10,
        "dislikes": 5,
      },
      {
        "gameName": "Game 3",
        "rating": 1.5,
        "comment": "Not up to expectations.",
        "gameUrl":
            "https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg",
        "likes": 5,
        "dislikes": 12,
      },
      {
        "gameName": "Game 4",
        "rating": 4.5,
        "comment": "One of the best games I've played this year!",
        "gameUrl":
            "https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg",
        "likes": 20,
        "dislikes": 1,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xff051f20), // Dark background for the page
      appBar: AppBar(
        title: const Text('Username', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff163832), // Dark green for the app bar
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'report') {
                // Navigate to the report page
              } else if (value == 'block') {
                // Navigate to the block page
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'report', child: Text('Report User')),
              const PopupMenuItem(value: 'block', child: Text('Block User')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const UserInfoCard(), // Replace ProfileInfoCard with UserInfoCard
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: TabBarSection(mode: 1, selected: 1), // Profile tab bar
          ),
          // Reviews Section
          Expanded(
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                /*return GameReviewCard(
                  gameName: review["gameName"],
                  rating: review["rating"],
                  comment: review["comment"],
                  gameUrl: review["gameUrl"],
                  likes: review["likes"],
                  dislikes: review["dislikes"],
                );*/
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1, // Set the current tab index for navigation
        //isLoggedIn: true, // Replace with the actual login status
      ),
    );
  }
}
