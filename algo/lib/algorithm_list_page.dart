import 'package:flutter/material.dart';
import 'sorting_algo/bubble_sort/bubble_sort_page.dart';
import 'sorting_algo/mod_bubble_sort/modified_bubble_sort.dart';
import 'sorting_algo/selection_sort/selection_sort_page.dart';
import 'sorting_algo/insertion_sort/insertion_sort_page.dart';
import 'sorting_algo/merge_sort/merge_sort_page.dart';
import 'searching_algo/linear_search/linear_search_page.dart';
import 'searching_algo/binary_search/binary_search_page.dart';

class AlgorithmListPage extends StatefulWidget {
  const AlgorithmListPage({super.key});

  @override
  State<AlgorithmListPage> createState() => _AlgorithmListPageState();
}

class _AlgorithmListPageState extends State<AlgorithmListPage> {
  String selectedCategory = 'All Algorithms';

  final Map<String, List<Map<String, dynamic>>> algorithmCategories = {
    'Sorting Algorithms': [
      {
        'name': 'Bubble Sort',
        'description': 'Classic bubble sort visualization',
        'page': const BubbleSortPage(),
        'icon': Icons.bubble_chart,
      },
      {
        'name': 'Modified Bubble Sort',
        'description': 'Optimized bubble sort with early exit',
        'page': const ModifiedBubbleSortPage(),
        'icon': Icons.auto_fix_high,
      },
      {
        'name': 'Selection Sort',
        'description': 'Find minimum and place at beginning',
        'page': const SelectionSortPage(),
        'icon': Icons.touch_app,
      },
      {
        'name': 'Insertion Sort',
        'description': 'Insert each element in correct position',
        'page': const InsertionSortPage(),
        'icon': Icons.input,
      },
      {
        'name': 'Merge Sort',
        'description': 'Efficient, stable, divide and conquer',
        'page': const MergeSortPage(),
        'icon': Icons.merge_type,
      },
      // {
      //   'name': 'Quick Sort',
      //   'description': 'Fast, in-place, divide and conquer',
      //   'page': null, // Placeholder for future implementation
      //   'icon': Icons.flash_on,
      // }
    ],
    'Search Algorithms': [
      {
        'name': 'Linear Search',
        'description': 'Search element by checking each position',
        'page': const LinearSearchPage(),
        'icon': Icons.search,
      },
      {
        'name': 'Binary Search',
        'description': 'Efficient search on sorted arrays using divide and conquer',
        'page': const BinarySearchPage(),
        'icon': Icons.speed,
      },
    ],
  };

  List<Map<String, dynamic>> get currentAlgorithms {
    if (selectedCategory == 'All Algorithms') {
      List<Map<String, dynamic>> allAlgorithms = [];
      algorithmCategories.values.forEach((categoryAlgorithms) {
        allAlgorithms.addAll(categoryAlgorithms);
      });
      return allAlgorithms;
    }
    return algorithmCategories[selectedCategory] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Algorithm Visualizer'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          _buildCategorySelector(),
          Expanded(
            child: _buildAlgorithmList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Algorithm Category',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            items: [
              const DropdownMenuItem(
                value: 'All Algorithms',
                child: Row(
                  children: [
                    Icon(Icons.apps, size: 20),
                    SizedBox(width: 8),
                    Text('All Algorithms'),
                  ],
                ),
              ),
              ...algorithmCategories.keys.map((category) {
                IconData categoryIcon = category == 'Sorting Algorithms'
                    ? Icons.sort
                    : Icons.search;
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Icon(categoryIcon, size: 20),
                      const SizedBox(width: 8),
                      Text(category),
                    ],
                  ),
                );
              }),
            ],
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedCategory = newValue;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAlgorithmList() {
    final algorithms = currentAlgorithms;

    if (algorithms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.code_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No algorithms found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a different category or add new algorithms',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: algorithms.length,
      itemBuilder: (context, index) {
        return _buildAlgorithmCard(algorithms[index]);
      },
    );
  }

  Widget _buildAlgorithmCard(Map<String, dynamic> algorithm) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => algorithm['page'] as Widget,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  algorithm['icon'] as IconData? ?? Icons.code,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      algorithm['name'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      algorithm['description'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}