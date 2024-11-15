// widgets/report_bottom_sheet_widget.dart
import 'package:flutter/material.dart';

class ReportUserWidget extends StatefulWidget {
  const ReportUserWidget({super.key});

  @override
  ReportUserWidgetState createState() => ReportUserWidgetState();
}

class ReportUserWidgetState extends State<ReportUserWidget> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            //Title
            'Reason to report',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          //RadioList
          RadioListTile<String>(
            title: const Text('Offensive Content'),
            value: 'offensive',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value; // Update the selected option
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Spam'),
            value: 'spam',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value; // Update the selected option
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Abuse'),
            value: 'abuse',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value; // Update the selected option
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Other'),
            value: 'other',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value; // Update the selected option
              });
            },
          ),

          //Report Button
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3e6259),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report submitted')),
                );
              },
              child:
                  const Text('Report', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
