import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/profile_info_card.dart';
// Import the custom widgets from your widgets folder
import '../widgets/bottom_navbar.dart';
import '../widgets/user_info_card.dart';
import '../widgets/tab_bar.dart';

class ProfilePostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20), // Dark page background
      appBar: AppBar(
        title: const Text('Username'), // Replace with dynamic username if needed
        backgroundColor: const Color(0xff3e6259), // Dark green for the app bar
      ),
      body: Column(
        children: [
          const ProfileInfoCard(), // User info card
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TabBarSection(), // Tab section
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Ora ci sono 3 card di post
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Card(
                      color: const Color(0xfff0f9f1), // Very light green background for cards
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8, // Increased elevation for stronger shadow effect
                      shadowColor: Colors.black.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom:10,top:15,left:10,right:10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Game image on the left
                                Image.network(
                                  'https://via.placeholder.com/150', // Placeholder image URL
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.broken_image, color: Colors.grey[400]);
                                  },
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Game name positioned next to the image
                                      Text(
                                        'Game Name',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 0),
                                      // Game description text
                                      Text(
                                        'Game description goes here. Details about the game...Game description goes here. Details about the game..Game description goes here. Details about the game...Game description goes here. Details about the game...Game description goes here. Details about the game..Game description goes here. Details about the game...',
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey[700],fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            // Like and Comment icons at the bottom center
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.thumb_up, color: Colors.grey[700]),
                                  onPressed: () {
                                    // Like button logic
                                  },
                                ),
                                Text("11", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                                const SizedBox(width: 20),
                                IconButton(
                                  icon: Icon(Icons.comment, color: Colors.grey[700]),
                                  onPressed: () {
                                    // Comment button logic
                                  },
                                ),
                                Text("5", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Positioned delete button in the top-right corner with margin
                    Positioned(
                      top: 20,
                      right: 20,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.red,size:35),
                        onPressed: () {
                          // Delete post logic
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1, // Highlight 'Home' for this page
        isLoggedIn: true, // Replace with the actual login status
      ),
      // Use the Stack to create an invisible area just above the footer
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 10, // Positioning above the footer
            right: 10, // Aligning the button to the right
            child: Container(
              // A transparent container for the + button
              color: Colors.transparent,
              child: FloatingActionButton(
                onPressed: () {
                  // Logic to create a new post
                },
                backgroundColor: const Color(0xff3e6259), // Dark green for the "Add Post" button
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
