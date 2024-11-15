import 'package:flutter/material.dart';
import 'package:gamerverse/views/specific_game/add_review.dart';
import 'package:gamerverse/widgets/specific_game/single_review.dart';
import 'package:hugeicons/hugeicons.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  //function to show the modal to Add Review
  void _showAddReviewForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddReview(
            onSubmit: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        backgroundColor: const Color(0xff163832),
        title: const Text('Game Name', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Game Image
            Container(
              color: Colors.grey[300],
              height: 200.0,
              width: double.infinity,
              child: const Icon(Icons.image, size: 100),
            ),
            const SizedBox(height: 8.0),

            //Game Image and Users Rating
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Game Name
                  Text(
                    'Name',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),

                  //Users Rating
                  Column(
                    children: [
                      Row(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedPacman02,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '4.5',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        'Users Review',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),

            //All Reviews List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return const SingleReview(
                  username: "Giocatore1",
                  rating: 4.5,
                  comment: "Questo gioco è fantastico, mi piace molto!",
                  avatarUrl: "https://www.example.com/avatar1.jpg",
                  likes: 11,
                  dislikes: 11,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReviewForm(context),
        backgroundColor: const Color(0xff163832),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
