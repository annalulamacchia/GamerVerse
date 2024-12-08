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
      required this.onPending});

  // Decline Report
  void _declineReport(BuildContext context) async {
    final result = await ReportService.declineReport(report.reportId);
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
    final result = await ReportService.acceptReport(report.reportId);
    if (result) {
      onAccepted();
      onPending();
      DialogHelper.showSuccessDialog(context, "Report Accepted successfully!");
    } else {
      DialogHelper.showErrorDialog(context, "Error in accepting report");
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
                            _declineReport(parentContext);
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
                            _acceptReport(parentContext);
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
      image = report.additionalUserInfo!.profilePicture;
    } else if (title == 'Posts') {
      image = report.additionalPostInfo!.gameCover;
    } else if (title == 'Reviews') {
      image = report.additionalReviewInfo!.gameCover;
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
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),

              //Username in Users section
              if (title == 'Users' ||
                  title == 'Permanently Blocked Users' ||
                  title == 'Temporary Blocked Users')
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      report.additionalUserInfo!.username,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                      backgroundImage: (title == 'Posts'
                                  ? report.additionalPostInfo!.profilePicture
                                  : report
                                      .additionalReviewInfo!.profilePicture) !=
                              ''
                          ? NetworkImage(
                              title == 'Posts'
                                  ? report.additionalPostInfo!.profilePicture
                                  : report.additionalReviewInfo!.profilePicture,
                            )
                          : null,
                      child: (title == 'Posts'
                                  ? report.additionalPostInfo!.profilePicture
                                  : report
                                      .additionalReviewInfo!.profilePicture) ==
                              ''
                          ? Icon(
                              Icons.person,
                              size: 24,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    SizedBox(width: 10),

                    //Username
                    Text(
                      title == 'Posts'
                          ? report.additionalPostInfo!.username
                          : report.additionalReviewInfo!.username,
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
