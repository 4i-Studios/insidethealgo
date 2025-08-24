import 'package:flutter/material.dart';

class BinarySearchGuide {
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
                const SizedBox(height: 20),
                _buildComparison(),
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
        Icon(Icons.speed, color: Colors.indigo.shade700, size: 24),
        const SizedBox(width: 8),
        const Text(
          'Binary Search Algorithm',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
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
              'How Binary Search Works',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.indigo.shade100),
          ),
          child: Column(
            children: [
              _buildStepItem(1, 'Start with sorted array and set left=0, right=n-1'),
              _buildStepItem(2, 'Calculate middle index: mid = (left + right) ÷ 2'),
              _buildStepItem(3, 'Compare arr[mid] with target value'),
              _buildStepItem(4, 'If found, return the index'),
              _buildStepItem(5, 'If arr[mid] < target, search right half (left = mid + 1)'),
              _buildStepItem(6, 'If arr[mid] > target, search left half (right = mid - 1)'),
              _buildStepItem(7, 'Repeat until found or left > right'),
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
            Icon(Icons.speed, color: Colors.indigo.shade700, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Time & Space Complexity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.indigo.shade100),
          ),
          child: Column(
            children: [
              _buildComplexityRow('Best Case', 'O(1)', 'Target is at middle'),
              _buildComplexityRow('Average Case', 'O(log n)', 'Eliminates half each time'),
              _buildComplexityRow('Worst Case', 'O(log n)', 'Target at end or not found'),
              _buildComplexityRow('Space Complexity', 'O(1)', 'Uses only few variables'),
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
              'Advantages',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              _buildAdvantageItem('Very fast - O(log n) time complexity'),
              _buildAdvantageItem('Much more efficient than linear search for large datasets'),
              _buildAdvantageItem('Memory efficient - uses constant space'),
              _buildAdvantageItem('Simple to implement and understand'),
              _buildAdvantageItem('Guarantees logarithmic performance'),
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
              'Disadvantages',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              _buildDisadvantageItem('Requires sorted array - preprocessing needed'),
              _buildDisadvantageItem('Not suitable for frequently changing data'),
              _buildDisadvantageItem('Poor performance on small datasets (overhead)'),
              _buildDisadvantageItem('Cannot be used on linked lists efficiently'),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildComparison() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.compare_arrows, color: Colors.blue.shade700, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Binary vs Linear Search',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              _buildComparisonRow('Time Complexity', 'O(log n)', 'O(n)'),
              _buildComparisonRow('Array Requirement', 'Must be sorted', 'Any order'),
              _buildComparisonRow('Best for', 'Large datasets', 'Small/unsorted data'),
              _buildComparisonRow('Implementation', 'Moderate', 'Simple'),
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
              color: Colors.indigo.shade600,
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

  static Widget _buildComplexityRow(String case1, String complexity, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              case1,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              complexity,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              description,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildComparisonRow(String aspect, String binary, String linear) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              aspect,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              binary,
              style: const TextStyle(fontSize: 13, color: Colors.indigo),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              linear,
              style: const TextStyle(fontSize: 13, color: Colors.teal),
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