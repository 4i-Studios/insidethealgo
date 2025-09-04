import 'package:flutter/material.dart';

class MergeSortGuide {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const MergeSortGuideDialog(),
    );
  }
}

class MergeSortGuideDialog extends StatelessWidget {
  const MergeSortGuideDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Merge Sort Guide',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      'Algorithm Overview',
                      'Merge Sort is a divide-and-conquer algorithm that recursively divides the array into smaller subarrays until each contains only one element, then merges them back together in sorted order.',
                    ),
                    _buildSection(
                      'How It Works',
                      '1. Divide: Split the array into two halves\n'
                      '2. Conquer: Recursively sort both halves\n'
                      '3. Merge: Combine the sorted halves into a single sorted array',
                    ),
                    _buildSection(
                      'Animation Modes',
                      'Tree View: Shows the divide-and-conquer tree structure\n'
                      'Bubble View: Displays elements as animated bubbles during merge\n'
                      'Bar Chart: Visualizes elements as bars with height representing values\n\n'
                      'Click "Switch View" to cycle between animation modes during sorting!',
                    ),
                    _buildSection(
                      'Time Complexity',
                      'Best Case: O(n log n)\n'
                      'Average Case: O(n log n)\n'
                      'Worst Case: O(n log n)\n\n'
                      'Merge sort has consistent O(n log n) performance regardless of input.',
                    ),
                    _buildSection(
                      'Space Complexity',
                      'O(n) - Requires additional space for temporary arrays during merging.',
                    ),
                    _buildSection(
                      'Key Properties',
                      '• Stable: Maintains relative order of equal elements\n'
                      '• Not in-place: Requires additional memory\n'
                      '• Predictable: Always O(n log n) time complexity\n'
                      '• Parallelizable: Can be optimized for parallel processing',
                    ),
                    _buildSection(
                      'When to Use',
                      '• When you need guaranteed O(n log n) performance\n'
                      '• When stability is required\n'
                      '• For large datasets where consistent performance matters\n'
                      '• When memory usage is not a primary concern',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
