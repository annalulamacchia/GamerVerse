import 'package:flutter/material.dart';
import '../views/profile/profile_post_page.dart';
import '../views/profile/profile_page.dart';
// Importa anche le pagine specifiche dell'utente
import '../views/other_user_profile/user_profile_page.dart';
//import '../views/other_user_profile/user_reviews_page.dart';
import '../views/other_user_profile/user_post_page.dart';

class TabBarSection extends StatelessWidget {
  final int mode; // Aggiunto parametro `mode`

  const TabBarSection({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabButton(
            context,
            'Games',
            Colors.green,
                () {
              if (mode == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfilePage()),
                );
              }
            },
          ),
          _buildTabButton(
            context,
            'Reviews',
            Colors.black,
                () {
/*if (mode == 0) {
                // Navigazione per la pagina delle recensioni del profilo principale
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ProfileReviewsPage()),
                // );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserReviewsPage()),
                );
              }*/
            },
          ),
          _buildTabButton(
            context,
            'Post',
            Colors.black,
                () {
              if (mode == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePostPage()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserPostPage()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
      BuildContext context, String text, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
