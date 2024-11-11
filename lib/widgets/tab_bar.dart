import 'package:flutter/material.dart';
import '../views/profile_post_page.dart';
import '../views/profile_page.dart';

class TabBarSection extends StatelessWidget {
  const TabBarSection({Key? key}) : super(key: key);

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          _buildTabButton(
            context,
            'Reviews',
            Colors.black,
                () {
              //Navigator.push(
               // context,
                //MaterialPageRoute(builder: (context) => ReviewsPage()),
              //);
            },
          ),
          _buildTabButton(
            context,
            'Post',
            Colors.black,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePostPage() ),
              );
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
