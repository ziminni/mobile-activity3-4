import 'package:flutter/material.dart';
import 'package:why/views/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'CrimsonText',
        primarySwatch: Colors.green,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'CrimsonText'),
          displayMedium: TextStyle(fontFamily: 'CrimsonText'),
      ),
      ),
      home: HomePage()
    );
  }
}
