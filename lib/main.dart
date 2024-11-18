import 'package:flutter/material.dart';
import 'package:gamerverse/RouteGenerator.dart';
import 'views/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GamerVerse',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
      onGenerateRoute: RouteGenerator.generateRoute,// Now using HomeView from home_view.dart
    );
  }
}
