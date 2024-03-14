import 'package:flutter/material.dart';
import 'package:login_app_shared_prefrences/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'login using shared prefrences',
      home: LoginScreen(),
    );
  }
}
