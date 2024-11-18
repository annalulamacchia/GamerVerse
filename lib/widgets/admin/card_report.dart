import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/admin/post_info_report.dart';
import 'package:gamerverse/widgets/admin/review_info_report.dart';
import 'package:gamerverse/widgets/admin/user_info_report.dart';

class ReportCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String selectedStatus;

  const ReportCardWidget(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.selectedStatus});

  //function to show the dialog
  void _showDetailDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: const Color(0xff163832),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title == 'Temporary Blocked Users')
                const Text(
                  'Unblock the user?',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              if (title == 'Permanently Blocked Users')
                Text(
                  title.substring(0, title.length - 1),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              if (title == 'Users' || title == 'Posts' || title == 'Reviews')
                Text(
                  'Reported ${title.substring(0, title.length - 1)}',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.topLeft,
                child: Text('Reported 10 times',
                    style: TextStyle(color: Colors.white54)),
              ),
              const SizedBox(height: 5),

              //Users
              if (title == 'Users' ||
                  title == 'Permanently Blocked Users' ||
                  title == 'Temporary Blocked Users')
                UserInfo(title: title),

              //Posts
              if (title == 'Posts')
                const PostInfoReport(
                  username: 'Username',
                  gameName: 'Game Name',
                  comment: 'Questo gioco mi fa schifo. Dio Cristo!!!!',
                  gameUrl:
                      'https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg',
                  likes: 10,
                  numberComments: 11,
                  timestamp: 10,
                ),

              //Reviews
              if (title == 'Reviews')
                const ReviewInfoReport(
                  username: 'Username',
                  rating: 1,
                  comment: 'Questo gioco mi fa schifo. Dio Cristo!!!!',
                  gameUrl:
                      'https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg',
                  likes: 10,
                  dislikes: 11,
                  timestamp: 10,
                ),
              const SizedBox(height: 16),

              //Reason
              if (title == 'Users' || title == 'Posts' || title == 'Reviews')
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff1c463f),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'Reason',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              if (title == 'Users' || title == 'Posts' || title == 'Reviews')
                const SizedBox(height: 16),

              //Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Pending Section
                  if (selectedStatus == 'Pending')
                    Row(
                      children: [
                        //Decline Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Decline',
                              style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 20),

                        //Accept Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Accept',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //show dialog on tap on the card
        _showDetailDialog(context, title);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Banner
              Container(
                height: 120,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.network(
                    'https://i.ytimg.com/vi/fwX3k126zo8/maxresdefault.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              //Username in Users section
              if (title == 'Users' ||
                  title == 'Permanently Blocked Users' ||
                  title == 'Temporary Blocked Users')
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

              //Avatar and username in Posts or Review Section
              if (title == 'Posts' || title == 'Reviews')
                const Row(
                  children: [
                    SizedBox(width: 7.5),

                    //Avatar
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                        'https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg', // URL dell'immagine utente
                      ),
                    ),
                    SizedBox(width: 10),

                    //Username
                    Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
