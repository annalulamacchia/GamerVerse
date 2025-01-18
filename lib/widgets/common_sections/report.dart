import 'package:flutter/material.dart';
import 'package:gamerverse/services/report_service.dart';
import 'package:gamerverse/utils/colors.dart';
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
  String reportType = '';

  Future<void> _submitReport() async {
    if (_selectedOption == null) {
      DialogHelper.showErrorDialog(context, "Please, choose a valid reason");
    } else {
      setState(() {
        _isSubmitting = true;
      });

      if (widget.type == 'Comment') {
        reportType = 'Post';
      } else {
        reportType = widget.type;
      }

      final result = await ReportService.addReport(
        reporterId: widget.reporterId!,
        reportedId: widget.reportedId!,
        reason: _selectedOption!,
        type: reportType,
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
              color: Colors.white
            ),
          ),

          //Reasons
          if (widget.type == 'User')
            RadioListTile<String>(
              title: const Text('Offensive Content', style: TextStyle(color: Colors.white)),
              value: 'Offensive Content',
              groupValue: _selectedOption,
              activeColor: AppColors.lightGreen,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
          if (widget.type == 'Review' ||
              widget.type == 'Post' ||
              widget.type == 'Comment')
            RadioListTile<String>(
              title: const Text('Spoiler', style: TextStyle(color: Colors.white)),
              value: 'Spoiler',
              groupValue: _selectedOption,
              activeColor: AppColors.lightGreen,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
          RadioListTile<String>(
            title: const Text('Spam', style: TextStyle(color: Colors.white)),
            value: 'Spam',
            groupValue: _selectedOption,
            activeColor: AppColors.lightGreen,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Abuse', style: TextStyle(color: Colors.white)),
            value: 'Abuse',
            groupValue: _selectedOption,
            activeColor: AppColors.lightGreen,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Other', style: TextStyle(color: Colors.white)),
            value: 'Other',
            groupValue: _selectedOption,
            activeColor: AppColors.lightGreen,
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
                      backgroundColor: AppColors.mediumGreen,
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
