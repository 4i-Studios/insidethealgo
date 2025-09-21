import 'package:flutter/material.dart';

class InsertionSortGuide {
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
                _sectionHeader('Overview', Icons.info_outline),
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
        Icon(Icons.sort_by_alpha, color: Colors.indigo.shade700, size: 26),
        const SizedBox(width: 10),
        const Text(
          'Insertion Sort',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
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
              color: Colors.indigo.shade400,
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

  static Widget _infoCard({required Widget child, Color? color}) {
    final bg = color ?? Colors.grey.shade50;
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
    return _infoCard(
      color: Colors.indigo.shade50,
      child: const Text(
        'Insertion Sort builds the final sorted array one element at a time by taking each element from the unsorted portion and inserting it at the correct position in the sorted portion to its left. It is simple and adaptive for nearly-sorted data.',
        style: TextStyle(fontSize: 14, height: 1.4),
      ),
    );
  }

  static Widget _buildPseudocode() {
    const pseudocode = '''
for i from 1 to n-1:
  key = a[i]
  j = i - 1
  while j >= 0 and a[j] > key:
    a[j+1] = a[j]
    j = j - 1
  a[j+1] = key
''';
    return _infoCard(
      color: Colors.purple.shade50,
      child: _codeContainer(pseudocode),
    );
  }

  static Widget _buildCodeExample() {
    const javaCode = '''
public class InsertionSort {
    public static void insertionSort(int[] a) {
        int n = a.length;
        for (int i = 1; i < n; ++i) {
            int key = a[i];
            int j = i - 1;
            while (j >= 0 && a[j] > key) {
                a[j + 1] = a[j];
                j = j - 1;
            }
            a[j + 1] = key;
        }
    }
}
''';

    const cppCode = '''
#include <vector>
using namespace std;

void insertionSort(vector<int>& a) {
    int n = (int)a.size();
    for (int i = 1; i < n; ++i) {
        int key = a[i];
        int j = i - 1;
        while (j >= 0 && a[j] > key) {
            a[j + 1] = a[j];
            j = j - 1;
        }
        a[j + 1] = key;
    }
}
''';

    bool showJava = true;

    return _infoCard(
      color: Colors.teal.shade50,
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
    final values = [4, 2, 5, 3, 1];
    final keyIndex = 1; // example: inserting 2 into sorted [4]

    return _infoCard(
      color: Colors.yellow.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Example array: [4, 2, 5, 3, 1]\nShow first insertion: key = 2, compare and shift 4 to right, insert 2 at position 0.',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(values.length, (i) {
              final isKey = i == keyIndex;
              return _valueChip(values[i], isKey);
            }),
          ),
          const SizedBox(height: 8),
          const Text(
            'After insertion: [2, 4, 5, 3, 1]',
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
          Text('- Binary insertion: use binary search to find insertion point (reduces comparisons to O(log n) but shifts remain O(n)).'),
          SizedBox(height: 6),
          Text('- Use when array is nearly sorted; very efficient in that case.'),
          SizedBox(height: 6),
          Text('- Adaptive nature can be exploited in hybrid algorithms.'),
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
          _complexityRow('Average', 'O(n²)'),
          _complexityRow('Worst', 'O(n²)'),
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
          Text('- Simple and intuitive implementation.'),
          SizedBox(height: 6),
          Text('- Adaptive: efficient for nearly-sorted data.'),
          SizedBox(height: 6),
          Text('- Stable and in-place.'),
          SizedBox(height: 6),
          Text('- Online: can sort as data arrives.'),
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
          Text('- O(n²) time complexity on average and worst case.'),
          SizedBox(height: 6),
          Text('- Many element shifts for large or reverse-sorted arrays.'),
        ],
      ),
    );
  }

  static Widget _buildUseCases() {
    return _infoCard(
      color: Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Use Cases', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('- Small datasets (typically < 50 elements).'),
          SizedBox(height: 6),
          Text('- Nearly-sorted data.'),
          SizedBox(height: 6),
          Text('- As part of hybrid sorts (e.g., handling small runs in Timsort).'),
          SizedBox(height: 6),
          Text('- Educational purposes and demonstrations.'),
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
          Text('- In practice, Insertion Sort is used where its simplicity and adaptiveness matter more than raw performance.'),
          SizedBox(height: 6),
          Text('- Combining insertion sort for small subarrays with more efficient algorithms gives good real-world performance.'),
        ],
      ),
    );
  }
}
