import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/common_sections/report.dart';

class ReportBlockMenu extends StatelessWidget {
  final String? userId;
  final String? reportedId;
  final BuildContext parentContext;

  const ReportBlockMenu(
      {super.key,
      required this.userId,
      required this.reportedId,
      required this.parentContext});

  void _showReport(BuildContext context, String type, String? reportedId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return ReportWidget(
            type: type, reportedId: reportedId, reporterId: userId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'Report_User') {
          _showReport(parentContext, "User", reportedId);
        } else if (value == 'Block_User') {}
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
