import 'package:flutter/material.dart';
import 'package:gamerverse/services/report_service.dart';
import 'package:gamerverse/widgets/common_sections/dialog_helper.dart';

class ReportWidget extends StatefulWidget {
  final String type;
  final String? reportedId;
  final String? reporterId;

  const ReportWidget({
    super.key,
    required this.type,
    required this.reportedId,
    required this.reporterId,
  });

  @override
  ReportWidgetState createState() => ReportWidgetState();
}

class ReportWidgetState extends State<ReportWidget> {
  String? _selectedOption;
  bool _isSubmitting = false;

  Future<void> _submitReport() async {
    if (_selectedOption == null) {
      DialogHelper.showErrorDialog(context, "Please, choose a valid reason");
    } else {
      setState(() {
        _isSubmitting = true;
      });

      final result = await ReportService.addReport(
        reporterId: widget.reporterId!,
        reportedId: widget.reportedId!,
        reason: _selectedOption!,
        type: widget.type,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (result) {
        Navigator.of(context).pop();
        DialogHelper.showSuccessDialog(context,
            "The ${widget.type.toLowerCase()} was reported successfully!");
      } else {
        DialogHelper.showErrorDialog(context,
            "There was an error during your reporting. Please, try again!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Title
          const Text(
            'Reason to report',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          //Reasons
          if (widget.type == 'User')
            RadioListTile<String>(
              title: const Text('Offensive Content'),
              value: 'Offensive Content',
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
          if (widget.type == 'Review' || widget.type == 'Post')
            RadioListTile<String>(
              title: const Text('Spoiler'),
              value: 'Spoiler',
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
          RadioListTile<String>(
            title: const Text('Spam'),
            value: 'Spam',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Abuse'),
            value: 'Abuse',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Other'),
            value: 'Other',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
            },
          ),
          const SizedBox(height: 10),

          //Report Button
          Center(
            child: _isSubmitting
                ? const CircularProgressIndicator(color: Colors.teal)
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3e6259),
                    ),
                    onPressed: _submitReport,
                    child: const Text(
                      'Report',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
