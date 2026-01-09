import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/debug/debug_home_screen.dart';

import 'screens/idle/idle_screen.dart';
import 'theme/brands.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //  Modo tótem
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: blackWhiteBrand.toThemeData(),
      home: const DebugHomeScreen(),
    );
  }
}



