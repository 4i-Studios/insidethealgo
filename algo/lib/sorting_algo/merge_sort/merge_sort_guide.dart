import 'package:flutter/material.dart';

class MergeSortGuide {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Merge Sort Guide'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Merge Sort Algorithm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Overview:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Merge Sort is a divide-and-conquer algorithm that divides the input array into two halves, recursively sorts them, and then merges the sorted halves.',
                ),
                SizedBox(height: 16),
                Text(
                  'How it works:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('1. Divide the array into two halves'),
                Text('2. Recursively sort both halves'),
                Text('3. Merge the sorted halves back together'),
                SizedBox(height: 16),
                Text(
                  'Time Complexity: O(n log n)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Space Complexity: O(n)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Advantages:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• Stable sorting algorithm'),
                Text('• Guaranteed O(n log n) performance'),
                Text('• Works well for large datasets'),
                Text('• Predictable performance'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
