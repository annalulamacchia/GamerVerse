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
  final double? distance;
  final Future<void> Function()? onFollow;
  final ValueNotifier<int>? followedNotifier;

  const UserCard({
    super.key,
    required this.index,
    required this.onTap,
    required this.username,
    required this.profilePicture,
    this.currentUser,
    required this.isFollowed,
    required this.isBlocked,
    required this.parentContext,
    this.distance,
    this.onFollow,
    this.followedNotifier,
  });

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
          widget.onFollow!();
          if (widget.followedNotifier != null) {
            widget.followedNotifier!.value--;
          }
        } else {
          throw Exception(response['message']);
        }
      } else {
        final response = await FriendService.addFriend(userId: widget.index);
        if (response['success']) {
          widget.onFollow!();
          if (widget.followedNotifier != null) {
            widget.followedNotifier!.value++;
          }
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
              backgroundColor: Colors.grey[200],
              child: ClipOval(
                child: widget.profilePicture != ''
                    ? Image.network(
                        widget.profilePicture,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.person, color: Colors.white),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.username,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                // Aggiungi la riga per la distanza se presente
                if (widget.distance != null)
                  Text(
                    'Distance: ${widget.distance?.toStringAsFixed(2)} km',
                    // Mostra la distanza con 2 decimali
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: FontStyle.italic),
                  ),
              ],
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
