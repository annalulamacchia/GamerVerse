import 'package:flutter/material.dart';
import 'package:gamerverse/services/Friends/friend_service.dart';
import 'package:gamerverse/widgets/common_sections/dialog_helper.dart';

class UserCard extends StatefulWidget {
  final String index;
  final String username;
  final String profilePicture;
  final VoidCallback onTap;
  final String? currentUser;
  final bool isFollowed;
  final bool isBlocked;
  final BuildContext parentContext;

  const UserCard(
      {super.key,
      required this.index,
      required this.onTap,
      required this.username,
      required this.profilePicture,
      this.currentUser,
      required this.isFollowed,
      required this.isBlocked,
      required this.parentContext});

  @override
  State<UserCard> createState() => UserCardState();
}

class UserCardState extends State<UserCard> {
  bool isButtonDisabled = false;
  bool isFriend = false;
  bool isBlocked = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    isFriend = widget.isFollowed;
    isBlocked = widget.isBlocked;
  }

  Future<void> toggleFollow() async {
    setState(() {
      isButtonDisabled = true;
    });

    try {
      if (widget.isFollowed) {
        final response = await FriendService.removeFriend(userId: widget.index);
        if (response['success']) {
        } else {
          throw Exception(response['message']);
        }
      } else {
        final response = await FriendService.addFriend(userId: widget.index);
        if (response['success']) {
        } else {
          throw Exception(response['message']);
        }
      }

      setState(() {
        isFriend = !isFriend;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        isButtonDisabled = false; // Riabilita il pulsante
      });
    }
  }

  Future<void> unblockUser(BuildContext context) async {
    final result = await FriendService.blockUnblockUser(
        userId: widget.currentUser!,
        blockedId: widget.index,
        action: 'unblock');
    if (result) {
      setState(() {
        isBlocked = !isBlocked;
      });

      Navigator.pop;
      DialogHelper.showSuccessDialog(
          context, "The User was unblocked successfully!");
    } else {
      DialogHelper.showErrorDialog(
          context, "There was an error unblocking the user. Please try again!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Card(
        color: const Color(0xff000000),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: GestureDetector(
          onTap: widget.onTap,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: CircleAvatar(
              radius: 25,
              child: widget.profilePicture != ''
                  ? Image.network(widget.profilePicture)
                  : Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              widget.username,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            trailing: widget.currentUser != null &&
                    widget.currentUser != widget.index
                ? TextButton(
                    onPressed: isButtonDisabled
                        ? null
                        : () {
                            if (widget.isBlocked) {
                              unblockUser(widget.parentContext);
                            } else {
                              toggleFollow();
                            }
                          },
                    style: TextButton.styleFrom(
                      backgroundColor: isBlocked
                          ? Colors.orange
                          : (isFriend ? Color(0xFF871C1C) : Color(0xBE17A828)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 9.0, horizontal: 15.0),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: Text(
                      isBlocked
                          ? 'Unblock'
                          : (isFriend ? 'Unfollow' : 'Follow'),
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
