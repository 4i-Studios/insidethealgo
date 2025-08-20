import 'package:flutter/material.dart';

class InsertionSortGuide {
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
                const SizedBox(height: 20),
                _buildHowItWorks(),
                const SizedBox(height: 20),
                _buildTimeComplexity(),
                const SizedBox(height: 20),
                _buildAdvantages(),
                const SizedBox(height: 20),
                _buildDisadvantages(),
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
        Icon(Icons.insert_chart, color: Colors.blue.shade700, size: 24),
        const SizedBox(width: 8),
        const Text(
          'Insertion Sort Algorithm',
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
              _buildStepItem(1, 'Start from the second element (index 1) as the key'),
              _buildStepItem(2, 'Compare the key with elements in the sorted portion (to its left)'),
              _buildStepItem(3, 'Shift larger elements one position to the right'),
              _buildStepItem(4, 'Insert the key at its correct position'),
              _buildStepItem(5, 'Move to the next element and repeat'),
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
                dense: true,
                leading: const Icon(Icons.trending_up, color: Colors.green),
                title: const Text('Best Case: O(n)'),
                subtitle: const Text('Already sorted array'),
              ),
              ListTile(
                dense: true,
                leading: const Icon(Icons.trending_flat, color: Colors.orange),
                title: const Text('Average Case: O(n²)'),
                subtitle: const Text('Random order'),
              ),
              ListTile(
                dense: true,
                leading: const Icon(Icons.trending_down, color: Colors.red),
                title: const Text('Worst Case: O(n²)'),
                subtitle: const Text('Reverse sorted'),
              ),
              ListTile(
                dense: true,
                leading: const Icon(Icons.memory, color: Colors.green),
                title: const Text('Space Complexity: O(1)'),
                subtitle: const Text('In-place sorting'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildAdvantages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.thumb_up, color: Colors.green.shade700, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Advantages:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade100),
          ),
          child: Column(
            children: [
              _buildAdvantageItem('Simple implementation and easy to understand'),
              _buildAdvantageItem('Efficient for small datasets'),
              _buildAdvantageItem('Adaptive - O(n) for nearly sorted arrays'),
              _buildAdvantageItem('Stable - maintains relative order of equal elements'),
              _buildAdvantageItem('In-place - requires only O(1) extra memory'),
              _buildAdvantageItem('Online - can sort array as it receives it'),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildDisadvantages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.thumb_down, color: Colors.red.shade700, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Disadvantages:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.shade100),
          ),
          child: Column(
            children: [
              _buildDisadvantageItem('O(n²) time complexity for average and worst cases'),
              _buildDisadvantageItem('Not efficient for large datasets'),
              _buildDisadvantageItem('More writes compared to Selection Sort'),
              _buildDisadvantageItem('Performance degrades quickly with input size'),
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

  static Widget _buildAdvantageItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade600, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDisadvantageItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.cancel, color: Colors.red.shade600, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}