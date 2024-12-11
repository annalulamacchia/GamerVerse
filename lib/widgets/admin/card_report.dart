import 'package:flutter/material.dart';
import 'package:gamerverse/models/report.dart';
import 'package:gamerverse/services/report_service.dart';
import 'package:gamerverse/widgets/admin/post_info_report.dart';
import 'package:gamerverse/widgets/admin/review_info_report.dart';
import 'package:gamerverse/widgets/admin/user_info_report.dart';
import 'package:gamerverse/widgets/common_sections/dialog_helper.dart';

class ReportCardWidget extends StatelessWidget {
  final Report report;
  final String title;
  final String selectedStatus;
  final String userId;
  final BuildContext parentContext;
  final Future<void> Function() onAccepted;
  final Future<void> Function() onDeclined;
  final Future<void> Function() onPending;

  const ReportCardWidget(
      {super.key,
      required this.report,
      required this.title,
      required this.selectedStatus,
      required this.parentContext,
      required this.onAccepted,
      required this.onDeclined,
      required this.onPending,
      required this.userId});

  // Decline Report
  void _declineReport(BuildContext context) async {
    final result = await ReportService.declineReport(
        reportId: report.reportId, userId: userId);
    if (result) {
      onDeclined();
      onPending();
      DialogHelper.showSuccessDialog(context, "Report Declined successfully!");
    } else {
      DialogHelper.showErrorDialog(context, "Error in declining report");
    }
  }

  // Accept Report
  void _acceptReport(BuildContext context) async {
    final result = await ReportService.acceptReport(
        reportId: report.reportId, userId: userId);
    if (result) {
      onAccepted();
      onPending();
      DialogHelper.showSuccessDialog(context, "Report Accepted successfully!");
    } else {
      DialogHelper.showErrorDialog(context, "Error in accepting report");
    }
  }

  void _blockUnblockUser(BuildContext context, String action) async {
    final result = await ReportService.blockUnblockUser(
        userId: userId, action: action, reportedId: report.reportedId);
    if (result) {
      onAccepted();
      onPending();
      DialogHelper.showSuccessDialog(context, "User $action successfully!");
    } else {
      DialogHelper.showErrorDialog(context, "Error in $action user");
    }
  }

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
              if (title == 'Temporarily Blocked Users')
                const Text(
                  'Unblock the user?',
                  style: TextStyle(
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
              Align(
                alignment: Alignment.topLeft,
                child: Text('Reported ${report.counter} times',
                    style: TextStyle(color: Colors.white54)),
              ),
              const SizedBox(height: 5),

              //Users
              if (title == 'Users' || title == 'Temporarily Blocked Users')
                UserInfo(title: title, report: report),

              //Posts
              if (title == 'Posts') PostInfoReport(report: report),

              //Reviews
              if (title == 'Reviews') ReviewInfoReport(report: report),
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
                  child: Text(
                    report.reason,
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
                            if (title == 'Users' ||
                                title == 'Reviews' ||
                                title == 'Posts') {
                              _declineReport(parentContext);
                            } else if (title == 'Temporarily Blocked Users') {
                              _blockUnblockUser(parentContext, 'block');
                            }
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
                            if (title == 'Users' ||
                                title == 'Reviews' ||
                                title == 'Posts') {
                              _acceptReport(parentContext);
                            } else if (title == 'Temporarily Blocked Users') {
                              _blockUnblockUser(parentContext, 'unblock');
                            }
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
    String image = '';
    if (title == 'Users') {
      image = report.profilePicture;
    } else if (title == 'Posts') {
      image = report.gameCover!;
    } else if (title == 'Reviews') {
      image = report.gameCover!;
    }
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
                  child: image != ''
                      ? Image.network(
                          image,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.teal,
                          child: Center(
                            child: Icon(
                              Icons.account_box,
                              size: 50,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),

              //Username in Users section
              if (title == 'Users' || title == 'Temporarily Blocked Users')
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 125,
                      alignment: Alignment.center,
                      child: Text(
                        report.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

              //Avatar and username in Posts or Review Section
              if (title == 'Posts' || title == 'Reviews')
                Row(
                  children: [
                    SizedBox(width: 7.5),

                    //Avatar
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      backgroundImage: report.profilePicture != ''
                          ? NetworkImage(
                              report.profilePicture,
                            )
                          : null,
                      child: report.profilePicture == ''
                          ? Icon(
                              Icons.person,
                              size: 24,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    SizedBox(width: 10),

                    //Username
                    Container(
                      width: 100,
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        report.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
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
