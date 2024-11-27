import 'package:flutter/material.dart';
import 'package:gamerverse/models/user.dart';
import 'package:gamerverse/widgets/common_sections/bottom_navbar.dart';
import 'package:gamerverse/widgets/profile_or_users/user_follower_card.dart';

class LikedList extends StatefulWidget {
  final List<User> users;

  const LikedList({super.key, required this.users});

  @override
  _LikedListState createState() => _LikedListState();
}

class _LikedListState extends State<LikedList> {
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
      body: ListView.builder(
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

  // Puoi aggiungere metodi per aggiornare lo stato
  void updateItemCount(int newCount) {
    setState(() {
      itemCount = newCount;
    });
  }
}
