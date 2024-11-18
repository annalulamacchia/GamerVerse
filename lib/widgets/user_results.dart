import 'package:flutter/material.dart';
import 'package:gamerverse/views/other_user_profile/user_profile_page.dart';

class UserResults extends StatelessWidget {
  const UserResults({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6, // Example: Show 6 results
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text((index + 1).toString()),
          ),
          title: GestureDetector(
            onTap: () {
              // Navigate to the profile page directly
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfilePage(),
                ),
              );
            },
            child: Text(
              'Username ${index + 1}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
