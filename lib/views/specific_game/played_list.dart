import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/specific_game/single_review.dart';
import 'package:gamerverse/widgets/bottom_navbar.dart';

class PlayedList extends StatelessWidget {
  const PlayedList({super.key});

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
          return const SingleReview(
              username: "Giocatore1",
              rating: 4.5,
              comment: "",
              avatarUrl:
                  "https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg",
              likes: 11,
              dislikes: 11);
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
        isLoggedIn: false,
      ),
    );
  }
}
