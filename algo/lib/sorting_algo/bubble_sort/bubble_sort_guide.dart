import 'package:flutter/material.dart';

class BubbleSortGuide {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHandle(),
                _buildTitle(),
                const Divider(height: 24),
                _buildHowItWorks(),
                const SizedBox(height: 20),
                _buildTimeComplexity(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  static Widget _buildTitle() {
    return Row(
      children: [
        Icon(Icons.sort, color: Colors.blue.shade700, size: 24),
        const SizedBox(width: 8),
        const Text(
          'Bubble Sort Algorithm',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  static Widget _buildHowItWorks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.tips_and_updates, color: Colors.orange.shade700, size: 20),
            const SizedBox(width: 8),
            const Text(
              'How it Works:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Column(
            children: [
              _buildStepItem(1, 'Compare adjacent elements in the array'),
              _buildStepItem(2, 'If elements are in wrong order, swap them'),
              _buildStepItem(3, 'Continue this process for the entire array'),
              _buildStepItem(4, 'After each pass, one element "bubbles" to its position'),
              _buildStepItem(5, 'Repeat until no more swaps are needed'),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildTimeComplexity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.speed, color: Colors.purple.shade700, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Time Complexity:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purple.shade100),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green.shade700),
                title: const Text('Best Case: O(n)'),
                subtitle: const Text('Array is already sorted'),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.info, color: Colors.orange.shade700),
                title: const Text('Average Case: O(n²)'),
                subtitle: const Text('Random order'),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.error_outline, color: Colors.red.shade700),
                title: const Text('Worst Case: O(n²)'),
                subtitle: const Text('Array is reverse sorted'),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.memory, color: Colors.blue.shade700),
                title: const Text('Space Complexity: O(1)'),
                subtitle: const Text('Uses constant extra space'),
                dense: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildStepItem(int stepNumber, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}