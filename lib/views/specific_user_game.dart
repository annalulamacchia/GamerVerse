import 'package:flutter/material.dart';
import 'package:gamerverse/views/specific_game/specific_game.dart';
import 'package:gamerverse/widgets/post_user_game.dart';
import 'package:gamerverse/widgets/bottom_navbar.dart';

class SpecificUserGame extends StatelessWidget {
  const SpecificUserGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Game Name'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Game Image
            Container(
              height: 200,
              color: Colors.grey[300],
              child: const Center(child: Text('Game Image Placeholder')),
            ),
            const SizedBox(height: 8),

            //More Details
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SpecificGame(), // La pagina delle impostazioni
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'More Details on the Game',
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(Icons.keyboard_arrow_right, color: Colors.black),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Comments section
            ...List.generate(5, (index) {
              return const UserPost(
                username: 'Username',
                commentText: 'Ciao',
                likeCount: 11,
                commentCount: 12,
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 2,
        isLoggedIn: false,
      ),
    );
  }
}
