// dart
import 'package:flutter/material.dart';

class BubbleSortGuide {
  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.35,
        maxChildSize: 0.95,
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
                _sectionHeader('Overview', Icons.wifi_tethering),
                const SizedBox(height: 8),
                _buildOverview(),
                const SizedBox(height: 16),
                _sectionHeader('Pseudocode', Icons.code),
                const SizedBox(height: 8),
                _buildPseudocode(),
                const SizedBox(height: 16),
                _sectionHeader('Code Example (Dart)', Icons.developer_mode),
                const SizedBox(height: 8),
                _buildCodeExample(),
                const SizedBox(height: 16),
                _sectionHeader('Example Pass (visual)', Icons.view_array),
                const SizedBox(height: 8),
                _buildExampleVisualization(),
                const SizedBox(height: 16),
                _sectionHeader('Optimizations & Notes', Icons.lightbulb),
                const SizedBox(height: 8),
                _buildOptimizations(),
                const SizedBox(height: 16),
                _sectionHeader('Time & Space Complexity', Icons.timeline),
                const SizedBox(height: 8),
                _buildComplexityTable(),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ),
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
        margin: const EdgeInsets.only(bottom: 14),
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
        Icon(Icons.sort, color: Colors.blue.shade700, size: 26),
        const SizedBox(width: 10),
        const Text(
          'Bubble Sort',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('Stable', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  static Widget _sectionHeader(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade800),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  static Widget _buildOverview() {
    return const Text(
      'Bubble Sort repeatedly steps through the list, compares adjacent '
      'pairs and swaps them if they are in the wrong order. Each full pass '
      'places the next largest element in its final position ("bubbles" up). '
      'It is simple and stable but not efficient for large lists.',
      style: TextStyle(fontSize: 14, height: 1.4),
    );
  }

  static Widget _buildPseudocode() {
    const pseudocode = '''
      for i from 0 to n-2:
        swapped = false
        for j from 0 to n-2-i:
          if a[j] > a[j+1]:
            swap(a[j], a[j+1])
            swapped = true
        if not swapped:
          break  // array is sorted
      ''';
    return _codeContainer(pseudocode);
  }

  static Widget _buildCodeExample() {
    const code = '''
      void bubbleSort(List<int> a) {
        final n = a.length;
        for (int i = 0; i < n - 1; i++) {
          bool swapped = false;
          for (int j = 0; j < n - 1 - i; j++) {
            if (a[j] > a[j + 1]) {
              final tmp = a[j];
              a[j] = a[j + 1];
              a[j + 1] = tmp;
              swapped = true;
            }
          }
          if (!swapped) break;
        }
      }
      ''';
    return _codeContainer(code);
  }

  static Widget _codeContainer(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0E0E10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableText(
          code,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            color: Color(0xFFDCDCDC),
            height: 1.35,
          ),
        ),
      ),
    );
  }

  static Widget _buildExampleVisualization() {
    // Static illustrative example for readability.
    // Shows an array and the first pass swaps for [5, 3, 4, 1, 2]
    final values = [5, 3, 4, 1, 2];
    final swappedIndices = <int>{
      0,
      3,
    }; // pretend we swapped (5,3) and (4,1) in pass for demo

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Example array: [5, 3, 4, 1, 2]\nFirst pass (left-to-right): compare adjacent pairs and swap if needed.',
          style: TextStyle(fontSize: 14, height: 1.4),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(values.length, (i) {
            final isSwapped = swappedIndices.contains(i);
            return _valueChip(values[i], isSwapped);
          }),
        ),
        const SizedBox(height: 8),
        const Text(
          'After first pass: largest element (5) moves to the right end.',
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }

  static Widget _valueChip(int value, bool highlighted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: highlighted ? Colors.orange.shade100 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlighted ? Colors.orange.shade300 : Colors.grey.shade300,
        ),
      ),
      child: Text(
        '$value',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: highlighted ? Colors.orange.shade800 : Colors.black87,
        ),
      ),
    );
  }

  static Widget _buildOptimizations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          '- Early exit: track whether a pass made any swaps; stop early if none.',
        ),
        SizedBox(height: 6),
        Text(
          '- Reduced range: after each pass the largest element is in place; shrink inner loop.',
        ),
        SizedBox(height: 6),
        Text(
          '- Not suitable for large arrays; better alternatives: QuickSort, MergeSort, TimSort.',
        ),
        SizedBox(height: 6),
        Text('- Stable: equal elements keep relative order.'),
      ],
    );
  }

  static Widget _buildComplexityTable() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _complexityRow('Best', 'O(n)'),
          _complexityRow('Average', 'O(n\u00B2)'),
          _complexityRow('Worst', 'O(n\u00B2)'),
          _complexityRow('Space', 'O(1)'),
        ],
      ),
    );
  }

  static Widget _complexityRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
