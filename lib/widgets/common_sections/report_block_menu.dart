import 'package:flutter/material.dart';
import 'package:gamerverse/services/Friends/friend_service.dart';
import 'package:gamerverse/widgets/common_sections/dialog_helper.dart';
import 'package:gamerverse/widgets/common_sections/report.dart';

class ReportBlockMenu extends StatefulWidget {
  final String? userId;
  final String? reportedId;
  final BuildContext parentContext;
  final ValueNotifier<bool> blockedNotifier;
  final ValueNotifier<bool> isFollowedNotifier;
  final ValueNotifier<int> followersNotifier;

  const ReportBlockMenu(
      {super.key,
      required this.userId,
      required this.reportedId,
      required this.parentContext,
      required this.blockedNotifier,
      required this.isFollowedNotifier,
      required this.followersNotifier});

  @override
  _ReportBlockMenuState createState() => _ReportBlockMenuState();
}

class _ReportBlockMenuState extends State<ReportBlockMenu> {
  Future<void> _blockUser(BuildContext context) async {
    final result = await FriendService.blockUnblockUser(
        userId: widget.userId!, blockedId: widget.reportedId!, action: 'block');
    if (result) {
      Navigator.of(widget.parentContext).pop();
      DialogHelper.showSuccessDialog(
          widget.parentContext, "The User was blocked successfully!");
      setState(() {
        widget.blockedNotifier.value = true;
        if (widget.isFollowedNotifier.value) {
          widget.followersNotifier.value--;
        }
        widget.isFollowedNotifier.value = false;
      });
    } else {
      DialogHelper.showErrorDialog(
          widget.parentContext, "The user was already blocked!");
    }
  }

  void _showReport(BuildContext context, String type, String? reportedId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return ReportWidget(
            type: type, reportedId: reportedId, reporterId: widget.userId);
      },
    );
  }

  void _showPopUpBlockUser(
      BuildContext context, String? blockedId, String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure that you want to block the user?'),
          actions: [
            TextButton(
              onPressed: () {
                _blockUser(context);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'Report_User') {
          _showReport(widget.parentContext, "User", widget.reportedId);
        } else if (value == 'Block_User') {
          _showPopUpBlockUser(widget.parentContext, widget.reportedId, 'block');
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'Report_User',
          child: Text('Report User'),
        ),
        const PopupMenuItem(
          value: 'Block_User',
          child: Text('Block User'),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.grey),
    );
  }
}
