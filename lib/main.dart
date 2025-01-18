import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'views/home_page.dart';
import 'RouteGenerator.dart'; // Assuming your RouteGenerator is defined here

void main() async {
  // Ensure Firebase is initialized before the app starts
  WidgetsFlutterBinding.ensureInitialized(); // Ensures that all widgets are initialized first
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp()); // Then run the app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [],
      title: 'GamerVerse',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
      onGenerateRoute: RouteGenerator.generateRoute, // Use the route generator for navigation
    );
  }
}
