import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  final String title;

  CategorySection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
        Container(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: EdgeInsets.all(8),
                color: Colors.grey[300],
                child: Center(child: Text('Image ${index + 1}')),
              );
            },
          ),
        ),
      ],
    );
  }
}
