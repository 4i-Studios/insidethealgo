// dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'algorithm_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
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
      home: const AlgorithmListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}