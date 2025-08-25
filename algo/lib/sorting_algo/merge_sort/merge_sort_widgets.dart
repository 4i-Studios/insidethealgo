import 'package:flutter/material.dart';
import 'merge_sort_logic.dart';

class MergeSortWidgets {
  final MergeSortLogic logic;

  MergeSortWidgets(this.logic);

  double _getResponsiveSize(
    BuildContext context, {
    required double defaultSize,
    required double minSize,
    double? maxSize,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double size = (screenWidth / 400) * defaultSize;
    return size.clamp(minSize, maxSize ?? defaultSize);
  }

  Widget buildInputSection(BuildContext context) {
    return Container(
      color: Colors.blue.shade50,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: logic.arrayController,
                    decoration: const InputDecoration(
                      labelText: 'Enter numbers (comma separated)',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., 64, 34, 25, 12, 22',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: logic.isSorting
                      ? null
                      : () => logic.setArrayFromInput(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Set'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget buildAnimationArea(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade50, Colors.white],
        ),
      ),
      child: Column(
        children: [
          _buildColorLegend(),
          if (logic.isSorting || logic.sortCompleted) ...[
            _buildStatusChips(context),
            const SizedBox(height: 8),
          ],
          Expanded(
            child: Row(
              children: [
                // Tree visualization - 2/3 of width
                Expanded(flex: 2, child: _buildTreeVisualization(context)),
                const SizedBox(width: 8),
                // Bar chart - 1/3 of width
                Expanded(flex: 1, child: _buildAnimatedBars(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeVisualization(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Divide & Conquer Tree',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _buildTreeStructure(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeStructure() {
    if (logic.numbers.isEmpty) {
      return const Center(child: Text('Start sorting to see the tree'));
    }

    return Column(children: [_buildTreeLevel(logic.numbers, 0)]);
  }

  Widget _buildTreeLevel(List<int> array, int level) {
    if (array.length <= 1 || level > 3) {
      return _buildTreeNode(array, level, true);
    }

    int mid = array.length ~/ 2;
    List<int> left = array.sublist(0, mid);
    List<int> right = array.sublist(mid);

    return Column(
      children: [
        _buildTreeNode(array, level, false),
        if (level < 3) ...[
          const SizedBox(height: 8),
          // Connection lines
          Container(
            height: 16,
            child: CustomPaint(
              painter: TreeLinePainter(),
              size: const Size(100, 16),
            ),
          ),
          // Child nodes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: _buildTreeLevel(left, level + 1)),
              Expanded(child: _buildTreeLevel(right, level + 1)),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTreeNode(List<int> array, int level, bool isLeaf) {
    Color nodeColor;
    if (isLeaf) {
      nodeColor = Colors.green.shade100;
    } else if (logic.isSorting) {
      nodeColor = Colors.orange.shade100;
    } else {
      nodeColor = Colors.blue.shade100;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: nodeColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Text(
        '[${array.join(',')}]',
        style: TextStyle(
          fontSize: (10 - level).clamp(8, 12).toDouble(),
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildColorLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildColorLegendItem(Colors.blue, 'Unsorted'),
            const SizedBox(width: 12),
            _buildColorLegendItem(Colors.orange, 'Dividing'),
            const SizedBox(width: 12),
            _buildColorLegendItem(Colors.red, 'Merging'),
            const SizedBox(width: 12),
            _buildColorLegendItem(Colors.green, 'Sorted'),
          ],
        ),
      ),
    );
  }

  Widget _buildColorLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _buildStatusChips(BuildContext context) {
    return Container(
      height: 32,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStatusChip(
              'Comparisons',
              '${logic.totalComparisons}',
              Colors.blue,
            ),
            const SizedBox(width: 8),
            _buildStatusChip('Moves', '${logic.totalSwaps}', Colors.red),
            if (logic.leftArray.isNotEmpty) ...[
              const SizedBox(width: 8),
              _buildArrayChip('Left', logic.leftArray, Colors.orange),
            ],
            if (logic.rightArray.isNotEmpty) ...[
              const SizedBox(width: 8),
              _buildArrayChip('Right', logic.rightArray, Colors.purple),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildArrayChip(String label, List<int> array, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: [${array.join(',')}]',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildAnimatedBars(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Array State',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (logic.numbers.isEmpty) {
                  return const Center(
                    child: Text('No data', style: TextStyle(fontSize: 12)),
                  );
                }

                double availableHeight = constraints.maxHeight - 20;
                double availableWidth = constraints.maxWidth - 16;
                int maxNumber = logic.numbers.reduce((a, b) => a > b ? a : b);

                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      height: availableHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: logic.numbers.asMap().entries.map((entry) {
                          int index = entry.key;
                          int value = entry.value;

                          double barWidth = _getResponsiveSize(context,
                            defaultSize: availableWidth / logic.numbers.length,
                            minSize: 8.0,
                            maxSize: 25.0,
                          );
                          double barHeight =
                              ((value / maxNumber) * (availableHeight - 20))
                                  .clamp(10.0, availableHeight - 20);

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: barWidth,
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    color: logic.getBarColor(index),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(2),
                                      topRight: Radius.circular(2),
                                    ),
                                    border: Border.all(
                                      color: Colors.black26,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$value',
                                  style: const TextStyle(fontSize: 8),
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatusDisplay(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: logic.mergeIndex >= 0
            ? Colors.red.shade100
            : logic.isSorting
            ? Colors.purple.shade100
            : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: logic.mergeIndex >= 0
              ? Colors.red.shade300
              : logic.isSorting
              ? Colors.purple.shade300
              : Colors.blue.shade300,
        ),
      ),
      child: Column(
        children: [
          logic.operationIndicator.isNotEmpty
              ? Text(
                  logic.operationIndicator,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                )
              : Text(
                  logic.currentStep,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
        ],
      ),
    );
  }

  Widget buildCodeDisplay(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Merge Sort Algorithm:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(child: _buildCodeDisplay(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeDisplay(BuildContext context) {
    List<Map<String, dynamic>> codeLines = [
      {
        'line': 0,
        'text': 'void mergeSort(List<int> arr, int left, int right) {',
        'indent': 0,
      },
      {'line': 1, 'text': '  if (left < right) {', 'indent': 1},
      {'line': 2, 'text': '    int mid = (left + right) ~/ 2;', 'indent': 2},
      {'line': 3, 'text': '    mergeSort(arr, left, mid);', 'indent': 2},
      {'line': 4, 'text': '    mergeSort(arr, mid + 1, right);', 'indent': 2},
      {'line': 5, 'text': '    merge(arr, left, mid, right);', 'indent': 2},
      {'line': 6, 'text': '  }', 'indent': 1},
      {'line': 7, 'text': '}', 'indent': 0},
      {'line': 8, 'text': '', 'indent': 0},
      {
        'line': 9,
        'text': 'void merge(List<int> arr, int left, int mid, int right) {',
        'indent': 0,
      },
      {
        'line': 10,
        'text': '  List<int> leftArr = arr.sublist(left, mid + 1);',
        'indent': 1,
      },
      {
        'line': 11,
        'text': '  List<int> rightArr = arr.sublist(mid + 1, right + 1);',
        'indent': 1,
      },
      {'line': 12, 'text': '  int i = 0, j = 0, k = left;', 'indent': 1},
      {
        'line': 13,
        'text': '  while (i < leftArr.length && j < rightArr.length) {',
        'indent': 1,
      },
      {'line': 14, 'text': '    if (leftArr[i] <= rightArr[j]) {', 'indent': 2},
      {'line': 15, 'text': '      arr[k++] = leftArr[i++];', 'indent': 3},
      {'line': 16, 'text': '    } else {', 'indent': 2},
      {'line': 17, 'text': '      arr[k++] = rightArr[j++];', 'indent': 3},
      {'line': 18, 'text': '    }', 'indent': 2},
      {'line': 19, 'text': '  }', 'indent': 1},
      {
        'line': 20,
        'text': '  while (i < leftArr.length) arr[k++] = leftArr[i++];',
        'indent': 1,
      },
      {
        'line': 21,
        'text': '  while (j < rightArr.length) arr[k++] = rightArr[j++];',
        'indent': 1,
      },
      {'line': 22, 'text': '}', 'indent': 0},
      if (logic.sortCompleted)
        {'line': 23, 'text': '// Sorting Complete! ✨', 'indent': 0},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildCodeHeader(), _buildCodeContent(context, codeLines)],
      ),
    );
  }

  Widget _buildCodeHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D30),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'MergeSort.dart',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeContent(
    BuildContext context,
    List<Map<String, dynamic>> codeLines,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: codeLines.map((codeLine) {
            bool isHighlighted = logic.highlightedLine == codeLine['line'];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 1),
              color: isHighlighted
                  ? Colors.yellow.withOpacity(0.2)
                  : Colors.transparent,
              child: Row(
                children: [
                  SizedBox(width: codeLine['indent'] * 16.0),
                  Text(
                    codeLine['text'],
                    style: TextStyle(
                      color: _getCodeTextColor(codeLine['text']),
                      fontSize: 12,
                      fontFamily: 'Courier',
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getCodeTextColor(String text) {
    if (text.contains('void') ||
        text.contains('int') ||
        text.contains('if') ||
        text.contains('while') ||
        text.contains('else')) {
      return const Color(0xFF569CD6);
    } else if (text.contains('arr[') ||
        text.contains('left') ||
        text.contains('right') ||
        text.contains('mid') ||
        text.contains('merge')) {
      return const Color(0xFFDCDCAA);
    } else if (text.contains('}') || text.contains('//')) {
      return const Color(0xFF808080);
    } else if (text.contains('Sorting Complete!')) {
      return const Color(0xFF4EC9B0);
    }
    return Colors.white;
  }
}

class TreeLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.0;

    // Draw branching lines
    canvas.drawLine(
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.25, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.75, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
