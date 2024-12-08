import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/admin/card_report.dart';

class ReportsCategory extends StatelessWidget {
  final String title;
  final String selectedStatus;
  final List<dynamic> reports;
  final BuildContext parentContext;
  final String userId;
  final Future<void> Function() onAccepted;
  final Future<void> Function() onDeclined;
  final Future<void> Function() onPending;

  const ReportsCategory({
    super.key,
    required this.title,
    required this.selectedStatus,
    required this.reports,
    required this.parentContext,
    required this.onAccepted,
    required this.onDeclined,
    required this.onPending,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return Container();
    }

    // List of reports retrieved successfully
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: reports.length,
            itemBuilder: (context, index) {
              var report = reports[index];
              return Container(
                width: 200,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                child: ReportCardWidget(
                  report: report,
                  title: title,
                  selectedStatus: selectedStatus,
                  parentContext: parentContext,
                  onAccepted: onAccepted,
                  onDeclined: onDeclined,
                  onPending: onPending,
                  userId: userId,
                ),
              );
            },
          ),
        ),
        if (selectedStatus == 'Pending')
          const SizedBox(height: 10),
      ],
    );
  }
}
