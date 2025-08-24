import 'package:flutter/material.dart';

class LinearSearchGuide {
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
        Icon(Icons.search, color: Colors.teal.shade700, size: 24),
        const SizedBox(width: 8),
        const Text(
          'Linear Search Algorithm',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
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
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.teal.shade100),
          ),
          child: Column(
            children: [
              _buildStepItem(1, 'Start from the first element (index 0)'),
              _buildStepItem(2, 'Compare current element with target value'),
              _buildStepItem(3, 'If match found, return the index'),
              _buildStepItem(4, 'If no match, move to next element'),
              _buildStepItem(5, 'Repeat until element found or array ends'),
              _buildStepItem(6, 'Return -1 if target not found'),
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
            Icon(Icons.speed, color: Colors.teal.shade700, size: 20),
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
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.teal.shade100),
          ),
          child: Column(
            children: [
              ListTile(
                dense: true,
                leading: const Icon(Icons.trending_up, color: Colors.green),
                title: const Text('Best Case: O(1)'),
                subtitle: const Text('Element found at first position'),
              ),
              ListTile(
                dense: true,
                leading: const Icon(Icons.trending_flat, color: Colors.orange),
                title: const Text('Average Case: O(n)'),
                subtitle: const Text('Element in middle of array'),
              ),
              ListTile(
                dense: true,
                leading: const Icon(Icons.trending_down, color: Colors.red),
                title: const Text('Worst Case: O(n)'),
                subtitle: const Text('Element at end or not present'),
              ),
              ListTile(
                dense: true,
                leading: const Icon(Icons.memory, color: Colors.green),
                title: const Text('Space Complexity: O(1)'),
                subtitle: const Text('Constant extra space'),
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
              _buildAdvantageItem('Simple and easy to implement'),
              _buildAdvantageItem('Works on unsorted arrays'),
              _buildAdvantageItem('No extra memory required'),
              _buildAdvantageItem('Can find multiple occurrences'),
              _buildAdvantageItem('Works well for small datasets'),
              _buildAdvantageItem('Can be terminated early when element found'),
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
              _buildDisadvantageItem('O(n) time complexity - slow for large arrays'),
              _buildDisadvantageItem('Not efficient compared to binary search'),
              _buildDisadvantageItem('Doesn\'t utilize sorted array properties'),
              _buildDisadvantageItem('May need to check every element'),
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
              color: Colors.teal.shade700,
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