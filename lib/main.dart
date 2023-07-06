import 'package:barter_it2/splashscreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData( 
        primarySwatch: Colors.brown,
        cardColor: Color.fromARGB(255, 233, 214, 203),
      ),
      home: const SplashScreen(),
      );
  }
}
 