import 'package:flutter/material.dart';

class MergeSortGuide {
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
                _sectionHeader('Overview', Icons.device_hub),
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
                _sectionHeader('Visualization', Icons.account_tree_outlined),
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
        Icon(Icons.merge_type, color: Colors.deepPurple.shade700, size: 26),
        const SizedBox(width: 10),
        const Text(
          'Merge Sort',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
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
              color: Colors.deepPurple.shade400,
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
      color: Colors.deepPurple.shade50,
      child: const Text(
        'Merge Sort is a divide-and-conquer algorithm that splits the array into halves, recursively sorts each half, and then merges the sorted halves. It guarantees O(n log n) time and is stable, but requires additional memory for merging.',
        style: TextStyle(fontSize: 14, height: 1.4),
      ),
    );
  }

  static Widget _buildPseudocode() {
    const pseudocode = '''
function mergeSort(a, left, right):
  if left >= right: return
  mid = (left + right) // 2
  mergeSort(a, left, mid)
  mergeSort(a, mid+1, right)
  merge(a, left, mid, right)

function merge(a, left, mid, right):
  create temp array
  i = left, j = mid + 1
  while i <= mid and j <= right:
    if a[i] <= a[j]: append a[i++] to temp
    else: append a[j++] to temp
  append remaining elements
  copy temp back to a[left..right]
''';
    return _infoCard(
      color: Colors.purple.shade50,
      child: _codeContainer(pseudocode),
    );
  }

  static Widget _buildCodeExample() {
    const javaCode = '''
public class MergeSort {
    public static void mergeSort(int[] a, int left, int right) {
        if (left >= right) return;
        int mid = (left + right) / 2;
        mergeSort(a, left, mid);
        mergeSort(a, mid + 1, right);
        merge(a, left, mid, right);
    }

    private static void merge(int[] a, int left, int mid, int right) {
        int n1 = mid - left + 1;
        int n2 = right - mid;
        int[] L = new int[n1];
        int[] R = new int[n2];
        System.arraycopy(a, left, L, 0, n1);
        System.arraycopy(a, mid + 1, R, 0, n2);
        int i = 0, j = 0, k = left;
        while (i < n1 && j < n2) {
            if (L[i] <= R[j]) a[k++] = L[i++]; else a[k++] = R[j++];
        }
        while (i < n1) a[k++] = L[i++];
        while (j < n2) a[k++] = R[j++];
    }
}
''';

    const cppCode = '''
#include <vector>
using namespace std;

void merge(vector<int>& a, int left, int mid, int right) {
    vector<int> temp;
    int i = left, j = mid + 1;
    while (i <= mid && j <= right) {
        if (a[i] <= a[j]) temp.push_back(a[i++]); else temp.push_back(a[j++]);
    }
    while (i <= mid) temp.push_back(a[i++]);
    while (j <= right) temp.push_back(a[j++]);
    for (int k = left, t = 0; k <= right; ++k, ++t) a[k] = temp[t];
}

void mergeSort(vector<int>& a, int left, int right) {
    if (left >= right) return;
    int mid = (left + right) / 2;
    mergeSort(a, left, mid);
    mergeSort(a, mid + 1, right);
    merge(a, left, mid, right);
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
    final values = [8, 3, 5, 4, 7, 6, 1];

    return _infoCard(
      color: Colors.yellow.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Visualization: divide the array into halves until single elements remain, then merge sorted subarrays back together.',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values.map((v) => _valueChip(v)).toList(),
          ),
          const SizedBox(height: 8),
          const Text(
            'After merging runs you obtain the fully sorted array.',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  static Widget _valueChip(int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        '$value',
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
          Text('- Bottom-up merge (iterative) to avoid recursion overhead.'),
          SizedBox(height: 6),
          Text('- Switch to insertion sort for small subarrays.'),
          SizedBox(height: 6),
          Text('- Parallel merges for multi-core performance.'),
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
          _complexityRow('Best', 'O(n log n)'),
          _complexityRow('Average', 'O(n log n)'),
          _complexityRow('Worst', 'O(n log n)'),
          _complexityRow('Space', 'O(n)'),
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
          Text('- Predictable O(n log n) performance.'),
          SizedBox(height: 6),
          Text('- Stable: preserves order of equal elements.'),
          SizedBox(height: 6),
          Text('- Well-suited for external sorting and parallelization.'),
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
          Text('- Requires O(n) extra space for merging.'),
          SizedBox(height: 6),
          Text('- Recursive implementations use O(log n) stack space.'),
          SizedBox(height: 6),
          Text('- Not as cache-friendly as some in-place sorts.'),
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
          Text('- Large datasets where O(n log n) worst-case guarantees matter.'),
          SizedBox(height: 6),
          Text('- External sorting when data doesn\'t fit in memory.'),
          SizedBox(height: 6),
          Text('- When stability is required.'),
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
          Text('- Merge Sort is a foundational divide-and-conquer algorithm used widely in practice and education.'),
          SizedBox(height: 6),
          Text('- Many real-world libraries use tuned variants (bottom-up, insertion sort cutoff, parallel merges).'),
        ],
      ),
    );
  }
}
