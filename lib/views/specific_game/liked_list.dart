import 'package:flutter/material.dart';
import 'package:gamerverse/models/user.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/user_follower_card.dart';

class LikedList extends StatefulWidget {
  final List<User> users;

  const LikedList({super.key, required this.users});

  @override
  LikedListState createState() => LikedListState();
}

class LikedListState extends State<LikedList> {
  int itemCount = 0;

  @override
  void initState() {
    super.initState();
    itemCount = widget.users.length;
  }

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
      //list of all the users that liked a specific game
      body: itemCount == 0
          ? Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 60,
                      color: Colors.pinkAccent,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Looks like no one has added this game to their wishlist yet.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Why not be the first to show some love?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.pinkAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return UserCard(
                  index: (widget.users)[index].userId,
                  username: (widget.users)[index].username,
                  profilePicture: (widget.users)[index].profilePicture ?? '',
                  onTap: () {
                    Navigator.pushNamed(context, '/userProfile');
                  },
                );
              },
            ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
      ),
    );
  }
}
