import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/admin/card_report.dart';

class ReportsCategory extends StatelessWidget {
  final String title;
  final String selectedStatus;

  const ReportsCategory({
    super.key,
    required this.title,
    required this.selectedStatus,
  });

  @override
  Widget build(BuildContext context) {
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
                    color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              String imageUrl =
                  'https://t3.ftcdn.net/jpg/06/24/16/90/360_F_624169025_g8SF8gci4C4JT5f6wZgJ0IcKZ6ZuKM7u.jpg'; // Placeholder immagine
              return Container(
                width: 200,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                child: ReportCardWidget(
                    imageUrl: imageUrl,
                    title: title,
                    selectedStatus: selectedStatus),
              );
            },
          ),
        ),
      ],
    );
  }
}
