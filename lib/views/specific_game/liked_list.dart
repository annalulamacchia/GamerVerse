import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/user_follower_card.dart';

class LikedList extends StatelessWidget {
  const LikedList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        backgroundColor: const Color(0xff163832),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Game Name', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return UserCard(
            index: index,
            onTap: () {
              Navigator.pushNamed(context, '/userProfile');
            },
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
        isLoggedIn: false,
      ),
    );
  }
}
