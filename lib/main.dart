import 'package:flutter/material.dart';
import 'views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GamerVerse',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),  // Now using HomeView from home_view.dart
    );
  }
}
