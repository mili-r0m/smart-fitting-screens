import 'package:flutter/material.dart';
import 'screens/idle/idle_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Fitting',
      theme: ThemeData.dark(),
      home: const IdleScreen(),
    );
  }
}
