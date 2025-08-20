import 'package:flutter/material.dart';
import 'sorting_algo/bubble_sort/bubble_sort_page.dart';
import 'sorting_algo/mod_bubble_sort/modified_bubble_sort.dart';
import 'sorting_algo/selection_sort/selection_sort_page.dart';
import 'sorting_algo/insertion_sort/insertion_sort_page.dart';

class AlgorithmListPage extends StatelessWidget {
  const AlgorithmListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final algorithms = [
      {
        'name': 'Bubble Sort',
        'description': 'Classic bubble sort visualization',
        'page': const BubbleSortPage(),
      },
      {
        'name': 'Modified Bubble Sort',
        'description': 'Optimized bubble sort with early exit',
        'page': const ModifiedBubbleSortPage(),
      },
      {
        'name': 'Selection Sort',
        'description': 'Find minimum and place at beginning',
        'page': const SelectionSortPage(),
      },
      {
        'name': 'Insertion Sort',
        'description': 'Insert each element in correct position',
        'page': const InsertionSortPage(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Algorithm Visualizer'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: algorithms.length,
        itemBuilder: (context, index) {
          final algo = algorithms[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              title: Text(
                algo['name'] as String,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(algo['description'] as String),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => algo['page'] as Widget,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
