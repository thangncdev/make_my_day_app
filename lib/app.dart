import 'package:flutter/material.dart';
import 'screens/main_tab_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message Box',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'ShantellSans',
      ),
      home: const MainTabScreen(),
    );
  }
}
