import 'package:flutter/material.dart';

class BinarySearchGuide {
  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
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
                _sectionHeader('Overview', Icons.search),
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
                _sectionHeader('Example (visual)', Icons.view_array),
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
        Icon(Icons.search, color: Colors.blue.shade700, size: 26),
        const SizedBox(width: 10),
        const Text(
          'Binary Search',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('Requires sorted input', style: TextStyle(fontSize: 12)),
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
      color: Colors.orange.shade50,
      child: const Text(
        'Binary Search finds the position of a target value within a sorted array by repeatedly dividing the search interval in half. If the target value is equal to the middle element, the search is done. Otherwise, it continues in the half in which the target must lie. It runs in O(log n) time and requires sorted input.',
        style: TextStyle(fontSize: 14, height: 1.4),
      ),
    );
  }

  static Widget _buildPseudocode() {
    const pseudocode = '''
binarySearch(a, target):
  left = 0
  right = n - 1
  while left <= right:
    mid = (left + right) // 2
    if a[mid] == target: return mid
    else if a[mid] < target: left = mid + 1
    else: right = mid - 1
  return -1  // not found
''';
    return _infoCard(
      color: Colors.purple.shade50,
      child: _codeContainer(pseudocode),
    );
  }

  static Widget _buildCodeExample() {
    const javaCode = '''
public class BinarySearch {
    public static int binarySearch(int[] a, int target) {
        int left = 0, right = a.length - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (a[mid] == target) return mid;
            if (a[mid] < target) left = mid + 1;
            else right = mid - 1;
        }
        return -1;
    }
}
''';

    const cppCode = '''
#include <vector>
using namespace std;

int binarySearch(const vector<int>& a, int target) {
    int left = 0, right = (int)a.size() - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (a[mid] == target) return mid;
        if (a[mid] < target) left = mid + 1;
        else right = mid - 1;
    }
    return -1;
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
    final values = [1, 3, 5, 7, 9, 11, 13];
    int left = 0, right = values.length - 1, mid = (left + right) ~/ 2;
    final midHighlight = mid;

    return _infoCard(
      color: Colors.yellow.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Example: search for 7 in [1,3,5,7,9,11,13].\nFirst mid check is index 3 (value 7) — found immediately (best case).',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(values.length, (i) => _valueChip(values[i], i == midHighlight)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Binary Search inspects the middle element and halves the search range each step.',
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
        color: highlighted ? Colors.green.shade100 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlighted ? Colors.green.shade300 : Colors.grey.shade300,
        ),
      ),
      child: Text(
        '$value',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: highlighted ? Colors.green.shade800 : Colors.black87,
        ),
      ),
    );
  }

  static Widget _buildOptimizations() {
    return _infoCard(
      color: Colors.amber.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Optimizations', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('- Use iterative implementation to avoid recursion overhead.'),
          SizedBox(height: 6),
          Text('- For floating point or large indices, compute mid as left + (right - left) / 2 to avoid overflow.'),
          SizedBox(height: 6),
          Text('- Use library-provided binary search utilities where available (they are well-tested).'),
        ],
      ),
    );
  }

  static Widget _buildComplexityTable() {
    return _infoCard(
      color: Colors.purple.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _complexityRow('Best', 'O(1)'),
          _complexityRow('Average', 'O(log n)'),
          _complexityRow('Worst', 'O(log n)'),
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
          Text('- Very fast on large sorted datasets (O(log n) time).'),
          SizedBox(height: 6),
          Text('- Simple to implement and requires O(1) extra space.'),
          SizedBox(height: 6),
          Text('- Deterministic and predictable.'),
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
          Text('- Requires sorted input; cost of sorting may dominate.'),
          SizedBox(height: 6),
          Text('- Not suitable for linked lists (no random access).'),
          SizedBox(height: 6),
          Text('- Off-by-one and overflow bugs are common; be careful with indices.'),
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
          Text('- Finding items in a sorted array or range.'),
          SizedBox(height: 6),
          Text('- Lookups in read-only sorted datasets or indices.'),
          SizedBox(height: 6),
          Text('- Used as a building block in other algorithms (lower_bound, upper_bound).'),
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
          Text('- Binary search is foundational; many languages provide fast, tested implementations.'),
          SizedBox(height: 6),
          Text('- For approximate searches (closest value) adapt comparisons and return policy.'),
        ],
      ),
    );
  }
}