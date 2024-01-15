import 'package:flutservice1/menu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Service',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MenuOption(),
    );
  }
}
