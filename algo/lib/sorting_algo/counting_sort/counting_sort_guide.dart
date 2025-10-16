/// Counting Sort Algorithm Guide
///
/// Educational guide explaining counting sort algorithm with examples,
/// complexity analysis, and when to use it.
library;

import 'package:flutter/material.dart';

/// Guide for counting sort algorithm
class CountingSortGuide {
  /// Show the counting sort guide dialog
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
                _sectionHeader('How It Works', Icons.settings),
                const SizedBox(height: 8),
                _buildHowItWorks(),
                const SizedBox(height: 16),
                _sectionHeader('Pseudocode', Icons.code),
                const SizedBox(height: 8),
                _buildPseudocode(),
                const SizedBox(height: 16),
                _sectionHeader('Code Example', Icons.developer_mode),
                const SizedBox(height: 8),
                _buildCodeExample(),
                const SizedBox(height: 16),
                _sectionHeader('Example Walkthrough', Icons.view_array),
                const SizedBox(height: 8),
                _buildExampleVisualization(),
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
                _sectionHeader('When to Use', Icons.check_circle),
                const SizedBox(height: 8),
                _buildWhenToUse(),
                const SizedBox(height: 16),
                _sectionHeader('Comparison with Other Algorithms', Icons.compare),
                const SizedBox(height: 8),
                _buildComparison(),
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
        Icon(Icons.calculate, color: Colors.deepPurple.shade700, size: 26),
        const SizedBox(width: 10),
        const Text(
          'Counting Sort',
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
        'Counting Sort is a non-comparison sorting algorithm that works by counting the occurrences of each unique element. Unlike comparison-based algorithms like QuickSort or MergeSort, counting sort determines element positions by using the count of smaller elements, achieving linear time complexity for integer values within a known range.',
        style: TextStyle(fontSize: 14, height: 1.4),
      ),
    );
  }

  static Widget _buildHowItWorks() {
    return _infoCard(
      color: Colors.cyan.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Steps:', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('1. Find the Range: Determine minimum and maximum values'),
          SizedBox(height: 6),
          Text('2. Initialize Count Array: Create array of size (max - min + 1)'),
          SizedBox(height: 6),
          Text('3. Count Elements: For each element, increment count[element - min]'),
          SizedBox(height: 6),
          Text('4. Calculate Cumulative: Compute cumulative counts for positioning'),
          SizedBox(height: 6),
          Text('5. Build Output: Place elements in sorted order using cumulative counts'),
        ],
      ),
    );
  }

  static Widget _buildPseudocode() {
    const pseudocode = '''
// Find range
min = find_min(array)
max = find_max(array)
range = max - min + 1

// Count occurrences
count = array[range] initialized to 0
for each element in array:
  count[element - min]++

// Calculate cumulative counts
for i from 1 to range-1:
  count[i] += count[i-1]

// Build output array
output = array[n]
for i from n-1 down to 0:
  output[count[array[i] - min] - 1] = array[i]
  count[array[i] - min]--
''';
    return _infoCard(
      color: Colors.purple.shade50,
      child: _codeContainer(pseudocode),
    );
  }

  static Widget _buildCodeExample() {
    const javaCode = '''
public class CountingSort {
    public static void countingSort(int[] arr) {
        int n = arr.length;
        int min = arr[0], max = arr[0];
        
        // Find range
        for (int num : arr) {
            min = Math.min(min, num);
            max = Math.max(max, num);
        }
        
        int range = max - min + 1;
        int[] count = new int[range];
        int[] output = new int[n];
        
        // Count occurrences
        for (int num : arr) {
            count[num - min]++;
        }
        
        // Cumulative count
        for (int i = 1; i < range; i++) {
            count[i] += count[i - 1];
        }
        
        // Build output
        for (int i = n - 1; i >= 0; i--) {
            output[count[arr[i] - min] - 1] = arr[i];
            count[arr[i] - min]--;
        }
        
        // Copy back
        System.arraycopy(output, 0, arr, 0, n);
    }
}
''';

    const cppCode = '''
#include <vector>
#include <algorithm>
using namespace std;

void countingSort(vector<int>& arr) {
    int n = arr.size();
    int minVal = *min_element(arr.begin(), arr.end());
    int maxVal = *max_element(arr.begin(), arr.end());
    
    int range = maxVal - minVal + 1;
    vector<int> count(range, 0);
    vector<int> output(n);
    
    // Count occurrences
    for (int num : arr) {
        count[num - minVal]++;
    }
    
    // Cumulative count
    for (int i = 1; i < range; i++) {
        count[i] += count[i - 1];
    }
    
    // Build output
    for (int i = n - 1; i >= 0; i--) {
        output[count[arr[i] - minVal] - 1] = arr[i];
        count[arr[i] - minVal]--;
    }
    
    // Copy back
    arr = output;
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
              children: const [
                Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Java')),
                Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('C++'))
              ],
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
    return _infoCard(
      color: Colors.yellow.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Example: Sort [4, 2, 2, 8, 3, 3, 1]',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text('Step 1 - Find range: min=1, max=8', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 8),
          const Text('Step 2 - Count array for values 1-8:', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _countChip('1', '1'),
              _countChip('2', '2'),
              _countChip('3', '2'),
              _countChip('4', '1'),
              _countChip('5', '0'),
              _countChip('6', '0'),
              _countChip('7', '0'),
              _countChip('8', '1'),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Step 3 - Cumulative counts: [1,3,5,6,6,6,6,7]', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 8),
          const Text('Step 4 - Output: [1, 2, 2, 3, 3, 4, 8]', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
    );
  }

  static Widget _countChip(String value, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Text(
        '$value:$count',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: Colors.blue.shade800,
        ),
      ),
    );
  }

  static Widget _buildComplexityTable() {
    return _infoCard(
      color: Colors.pink.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _complexityRow('Best', 'O(n+k)'),
              _complexityRow('Average', 'O(n+k)'),
              _complexityRow('Worst', 'O(n+k)'),
              _complexityRow('Space', 'O(n+k)'),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'n = number of elements, k = range (max - min + 1)',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black54),
          ),
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
          Text('- Linear time complexity O(n + k)'),
          SizedBox(height: 6),
          Text('- Stable sorting algorithm'),
          SizedBox(height: 6),
          Text('- No element comparisons needed'),
          SizedBox(height: 6),
          Text('- Excellent performance for small value ranges'),
          SizedBox(height: 6),
          Text('- Predictable performance'),
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
          Text('- Requires extra space O(n + k)'),
          SizedBox(height: 6),
          Text('- Only works with integer values or values that can be mapped to integers'),
          SizedBox(height: 6),
          Text('- Poor performance when k >> n (large value range)'),
          SizedBox(height: 6),
          Text('- Not suitable for large value ranges'),
          SizedBox(height: 6),
          Text('- Memory intensive for sparse data'),
        ],
      ),
    );
  }

  static Widget _buildWhenToUse() {
    return _infoCard(
      color: Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('When to Use', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('- When the range of values (k) is small compared to n'),
          SizedBox(height: 6),
          Text('- When elements are integers or can be mapped to integers'),
          SizedBox(height: 6),
          Text('- When stability is important'),
          SizedBox(height: 6),
          Text('- When you need guaranteed linear time performance'),
          SizedBox(height: 6),
          Text('- As a subroutine in Radix Sort'),
        ],
      ),
    );
  }

  static Widget _buildComparison() {
    return _infoCard(
      color: Colors.amber.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('vs QuickSort/MergeSort:', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text('• Counting sort is faster when k is small'),
          Text('• Comparison sorts are better for general-purpose sorting'),
          SizedBox(height: 8),
          Text('vs Radix Sort:', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text('• Counting sort works with any integer range'),
          Text('• Radix sort is better for large numbers (uses counting sort internally)'),
          SizedBox(height: 8),
          Text('vs Bucket Sort:', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text('• Counting sort is deterministic'),
          Text('• Bucket sort works better with uniform distributions'),
        ],
      ),
    );
  }
}
