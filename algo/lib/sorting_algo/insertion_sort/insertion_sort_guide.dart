import 'package:flutter/material.dart';

class InsertionSortGuide {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const InsertionSortGuideDialog(),
    );
  }
}

class InsertionSortGuideDialog extends StatelessWidget {
  const InsertionSortGuideDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Insertion Sort Guide'),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSection('What is Insertion Sort?', [
                'Insertion Sort is a simple sorting algorithm that builds the final sorted array one element at a time.',
                'It works by taking each element from the unsorted portion and inserting it into its correct position in the sorted portion.',
                'Similar to how you might sort playing cards in your hands.',
              ]),
              const SizedBox(height: 16),
              _buildSection('How it Works', [
                '1. Start with the second element (index 1) as the first element is considered sorted',
                '2. Store the current element as "key"',
                '3. Compare the key with elements in the sorted portion (to the left)',
                '4. Shift larger elements one position to the right',
                '5. Insert the key at its correct position',
                '6. Repeat for all remaining elements',
              ]),
              const SizedBox(height: 16),
              _buildSection('Time Complexity', [
                'Best Case: O(n) - when array is already sorted',
                'Average Case: O(n²) - typical random input',
                'Worst Case: O(n²) - when array is reverse sorted',
              ]),
              const SizedBox(height: 16),
              _buildSection('Space Complexity', [
                'O(1) - constant extra space needed',
                'It sorts in-place, only using a constant amount of additional space',
              ]),
              const SizedBox(height: 16),
              _buildSection('Color Legend', [
                '🟦 Blue: Unsorted elements',
                '🟩 Green: Sorted portion',
                '🟠 Orange: Current key being inserted',
                '🟥 Red: Element being compared with key',
              ]),
              const SizedBox(height: 16),
              _buildSection('Advantages', [
                'Simple implementation',
                'Efficient for small datasets',
                'Adaptive - performs well on nearly sorted data',
                'Stable - maintains relative order of equal elements',
                'In-place - requires only O(1) memory',
                'Online - can sort a list as it receives it',
              ]),
              const SizedBox(height: 16),
              _buildSection('Disadvantages', [
                'Inefficient for large datasets due to O(n²) complexity',
                'More writes compared to selection sort',
                'Not suitable for large arrays',
              ]),
              const SizedBox(height: 16),
              _buildSection('Use Cases', [
                'Small datasets (typically < 50 elements)',
                'Nearly sorted data',
                'As a subroutine in hybrid algorithms (like Timsort)',
                'When simplicity is more important than efficiency',
                'Real-time sorting of small incoming data',
              ]),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        ...points.map((point) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(
                  point,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
