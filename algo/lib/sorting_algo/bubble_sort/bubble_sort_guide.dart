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
                _sectionHeader('Code Example', Icons.developer_mode),
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
                const SizedBox(height: 16),
                _sectionHeader('Advantages', Icons.thumb_up),
                const SizedBox(height: 8),
                _buildAdvantages(),
                const SizedBox(height: 16),
                _sectionHeader('Disadvantages', Icons.thumb_down),
                const SizedBox(height: 8),
                _buildDisadvantages(),
                const SizedBox(height: 16),
                _sectionHeader('Use Cases', Icons.check_circle),
                const SizedBox(height: 8),
                _buildUseCases(),
                const SizedBox(height: 16),
                _sectionHeader('Additional Notes', Icons.note),
                const SizedBox(height: 8),
                _buildAdditionalNotes(),
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.blue.shade400,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, size: 18, color: Colors.grey.shade800),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // Helper to wrap section content in a card-like container with accent color
  static Widget _infoCard({required Widget child, Color? color}) {
    final bg = color ?? Colors.grey.shade50;
    // use Color.lerp to create a faded border color (avoids deprecated component access)
    final border = (color == null)
        ? Colors.grey.shade200
        : (Color.lerp(color, Colors.transparent, 0.7) ?? Colors.grey.shade200);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            // small subtle shadow using explicit ARGB
            color: Color.fromARGB((0.03 * 255).round(), 0, 0, 0),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: child,
    );
  }

  static Widget _buildOverview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: const Text(
        'Bubble Sort repeatedly steps through the list, compares adjacent '
        'pairs and swaps them if they are in the wrong order. Each full pass '
        'places the next largest element in its final position ("bubbles" up). '
        'It is simple and stable but not efficient for large lists.',
        style: TextStyle(fontSize: 14, height: 1.4),
      ),
    );
  }

  static Widget _buildPseudocode() {
    const pseudocode = '''
      for i from 0 to n-1:
        for j from 0 to n-1-i:
          if a[j] > a[j+1]:
            swap(a[j], a[j+1])
      ''';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: _codeContainer(pseudocode),
    );
  }

  static Widget _buildCodeExample() {
    const javaCode = '''
public class BubbleSort {
    public static void bubbleSort(int[] a) {
        int n = a.length;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n - 1 - i; j++) {
                if (a[j] > a[j + 1]) {
                    int tmp = a[j];
                    a[j] = a[j + 1];
                    a[j + 1] = tmp;
                }
            }
        }
    }
}
''';

    const cppCode = '''
#include <vector>
using namespace std;

void bubbleSort(vector<int>& a) {
    int n = (int)a.size();
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n - 1 - i; ++j) {
            if (a[j] > a[j + 1]) {
                swap(a[j], a[j + 1]);
            }
        }
    }
}
''';

    bool showJava = true;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: StatefulBuilder(builder: (context, setState) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Text('Language:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(width: 10),
            ToggleButtons(
              isSelected: [showJava, !showJava],
              onPressed: (index) {
                setState(() => showJava = index == 0);
              },
              children: const [Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Java')), Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('C++'))],
            ),
          ]),
          const SizedBox(height: 6),
          _codeContainer(showJava ? javaCode : cppCode),
        ]);
      }),
    );
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
    final values = [5, 3, 4, 1, 2];
    final swappedIndices = <int>{0, 3};

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.yellow.shade200),
      ),
      child: Column(
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
      ),
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
    return _infoCard(
      color: Colors.orange.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Optimizations', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('- Early exit: track whether a pass made any swaps; stop early if none.'),
          SizedBox(height: 6),
          Text('- Reduced range: after each pass the largest element is in place; shrink inner loop.'),
          SizedBox(height: 6),
          Text('- Use for nearly-sorted datasets where it performs close to O(n).'),
        ],
      ),
    );
  }

  static Widget _buildComplexityTable() {
    return _infoCard(
      color: Colors.pink.shade50,
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

  static Widget _buildAdvantages() {
    return _infoCard(
      color: Colors.green.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Advantages', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('- Simple to implement and understand.'),
          SizedBox(height: 6),
          Text('- Does not require additional memory (in-place sorting).'),
          SizedBox(height: 6),
          Text('- Stable: maintains the relative order of equal elements.'),
        ],
      ),
    );
  }

  static Widget _buildDisadvantages() {
    return _infoCard(
      color: Colors.red.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Disadvantages', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('- Inefficient for large datasets due to O(n²) time complexity.'),
          SizedBox(height: 6),
          Text('- Performs poorly compared to other algorithms like QuickSort or MergeSort.'),
          SizedBox(height: 6),
          Text('- High number of swaps can lead to performance degradation.'),
        ],
      ),
    );
  }

  static Widget _buildUseCases() {
    return _infoCard(
      color: Colors.purple.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Use Cases', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('- Suitable for small datasets.'),
          SizedBox(height: 6),
          Text('- Useful when the simplicity of implementation is more important than performance.'),
          SizedBox(height: 6),
          Text('- Can be used for educational purposes to demonstrate sorting concepts.'),
        ],
      ),
    );
  }

  static Widget _buildAdditionalNotes() {
    return _infoCard(
      color: Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Additional Notes', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('- Bubble Sort is rarely used in practice due to its inefficiency.'),
          SizedBox(height: 6),
          Text('- Optimized versions (e.g., with early exit) can improve performance slightly.'),
          SizedBox(height: 6),
          Text('- Best suited for nearly sorted datasets where minimal swaps are needed.'),
        ],
      ),
    );
  }
}
