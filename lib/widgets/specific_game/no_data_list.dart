import 'package:flutter/material.dart';

class NoDataList extends StatelessWidget {
  final IconData icon;
  final String message;
  final String subMessage;
  final Color color;
  final Color? containerColor;
  final Color? textColor;

  const NoDataList(
      {super.key,
      required this.textColor,
      required this.icon,
      required this.message,
      required this.subMessage,
      required this.color,
      this.containerColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Icon
            Icon(
              icon,
              size: 60,
              color: color,
            ),
            const SizedBox(height: 16),
            //First Text
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            //SubText
            Text(
              subMessage,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
