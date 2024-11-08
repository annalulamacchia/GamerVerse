import 'package:flutter/material.dart';
import '../widgets/videogame_results.dart';
import '../widgets/user_results.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isVideoGameSearch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isVideoGameSearch = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isVideoGameSearch ? Colors.green : Colors.grey,
                ),
                child: Text('Search Video Games'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isVideoGameSearch = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isVideoGameSearch ? Colors.grey : Colors.green,
                ),
                child: Text('Search Users'),
              ),
            ],
          ),
          Expanded(
            child: isVideoGameSearch ? VideoGameResults() : UserResults(),
          ),
        ],
      ),
    );
  }
}
