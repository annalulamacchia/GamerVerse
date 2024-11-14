// widgets/report_bottom_sheet_widget.dart
import 'package:flutter/material.dart';

class ReportWidget extends StatefulWidget {
  const ReportWidget({super.key});

  @override
  ReportWidgetState createState() => ReportWidgetState();
}

class ReportWidgetState extends State<ReportWidget> {
  bool _isSpamChecked = false;
  bool _isAbuseChecked = false;
  bool _isOtherChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reason to Report',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          CheckboxListTile(
            title: const Text('Spam'),
            value: _isSpamChecked,
            onChanged: (value) {
              setState(() {
                _isSpamChecked = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Abuse'),
            value: _isAbuseChecked,
            onChanged: (value) {
              setState(() {
                _isAbuseChecked = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Other'),
            value: _isOtherChecked,
            onChanged: (value) {
              setState(() {
                _isOtherChecked = value ?? false;
              });
            },
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Chiude il bottom sheet
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report submitted')),
                );
              },
              child: const Text('Report', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
