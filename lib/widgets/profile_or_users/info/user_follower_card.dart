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
  final double? distance;
  final int? commonGames;

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
    this.commonGames,
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
        isButtonDisabled = false;
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF212121), Color(0xFF2B2B2B)], // Gradient scuro
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: const Color(0xFF055E14), // Verde brillante per il bordo
              width: 1.8,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF055C13).withOpacity(0.7), // Verde per l'ombra
                blurRadius: 16,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: widget.onTap,
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF3C3C3C), // Sfondo avatar scuro
                child: widget.profilePicture.isNotEmpty
                    ? ClipOval(
                  child: Image.network(
                    widget.profilePicture,
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
                )
                    : const Icon(
                  Icons.person,
                  color: Color(0xFF08931F),
                  size: 28,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.distance != null)
                    Text(
                      'Distance: ${widget.distance?.toStringAsFixed(2)} km',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  if (widget.commonGames != null)
                    Text(
                      'Common Games: ${widget.commonGames}',
                      style: const TextStyle(
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
