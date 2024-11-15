import 'package:flutter/material.dart';

class SpecificUserGame extends StatelessWidget {
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
      body: Column(
        children: [
          // Image section
          Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(child: Text('Game Image Placeholder')),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              // Action for more details
            },
            child: const Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'More Details on the Game',
                    style: TextStyle(color: Colors.blue),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.blue),
                ],
              ),
            ),
          ),
          // Comments section
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Number of comments
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey[300],
                                child: const Icon(Icons.person, color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              Text('Username'),
                              Spacer(),
                              Icon(Icons.more_vert),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'This is a placeholder text for user comment. '
                                'It can be multiple lines and should wrap accordingly.',
                            style: TextStyle(color: Colors.black87),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.thumb_up_alt_outlined),
                                onPressed: () {},
                              ),
                              Text('11'),
                              SizedBox(width: 16),
                              IconButton(
                                icon: Icon(Icons.comment_outlined),
                                onPressed: () {},
                              ),
                              Text('11'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Handle navigation based on the index
        },
      ),
    );
  }
}
