import 'package:flutter/material.dart';
import 'bubble_sort_page.dart';

void main() {
  runApp(const BubbleSortApp());
}

class BubbleSortApp extends StatelessWidget {
  const BubbleSortApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bubble Sort Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BubbleSortPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
