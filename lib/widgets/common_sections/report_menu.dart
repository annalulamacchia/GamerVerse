import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/common_sections/report.dart';

class ReportMenu extends StatelessWidget {
  final String? userId;
  final String? reportedId;
  final String? writerId;
  final BuildContext parentContext;
  final String type;

  const ReportMenu({
    super.key,
    required this.userId,
    required this.reportedId,
    required this.parentContext,
    required this.type,
    required this.writerId,
  });

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
        if (value == 'Report_$type') {
          _showReport(parentContext, type, reportedId);
        } else if (value == 'Report_User') {
          _showReport(parentContext, "User", writerId);
        }
      },
      itemBuilder: (context) => [
        if (type == 'Review')
          const PopupMenuItem(
            value: 'Report_Review',
            child: Text('Report Review'),
          ),
        if (type == 'Post')
          const PopupMenuItem(
            value: 'Report_Post',
            child: Text('Report Post'),
          ),
        const PopupMenuItem(
          value: 'Report_User',
          child: Text('Report User'),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.grey),
    );
  }
}
