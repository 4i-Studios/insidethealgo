import 'package:flutter/material.dart';
import '../../widgets/animated_bubble.dart';
import '../../widgets/input_section.dart';
import '../../widgets/code_display.dart';
import '../../widgets/metrics_panel.dart';
import '../../widgets/status_display.dart';
import 'merge_sort_logic.dart';

class MergeSortWidgets {
  final MergeSortLogic logic;

  MergeSortWidgets(this.logic);

  Widget buildInputSection(BuildContext context) {
    return InputSection(
      controller: logic.inputController,
      isDisabled: logic.isSorting,
      onSetPressed: () => logic.setArrayFromInput(context),
      hintText: 'Enter up to 10 numbers (e.g. 64,34,25)',
    );
  }

  Widget buildAnimationArea(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade50, Colors.white],
        ),
      ),
      child: Column(
        children: [
          _buildAnimationModeHeader(),
          _buildColorLegendRow(),
          if (logic.isSorting || logic.isSorted) ...[
            _buildMetricsRow(context),
          ],
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: _buildCurrentAnimation(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimationModeHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Animation Mode: ${logic.animationModeLabel}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: logic.cycleAnimationMode,
            icon: Icon(_getAnimationModeIcon()),
            label: const Text('Switch View'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAnimationModeIcon() {
    switch (logic.animationMode) {
      case AnimationMode.tree:
        return Icons.account_tree;
      case AnimationMode.bubble:
        return Icons.bubble_chart;
      case AnimationMode.bars:
        return Icons.bar_chart;
    }
  }

  Widget _buildCurrentAnimation() {
    switch (logic.animationMode) {
      case AnimationMode.tree:
        return _buildTreeAnimation();
      case AnimationMode.bubble:
        return _buildBubbleAnimation();
      case AnimationMode.bars:
        return _buildBarAnimation();
    }
  }

  Widget _buildTreeAnimation() {
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
              'Merge Sort Tree Structure',
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

  Widget _buildBubbleAnimation() {
    return AnimatedBubble(
      numbers: logic.numbers.map((e) => e.value).toList(),
      comparingIndex1: logic.leftIndex >= 0 ? logic.leftIndex : -1,
      comparingIndex2: logic.rightIndex >= 0 ? logic.rightIndex : -1,
      isSwapping: logic.isMerging,
      swapFrom: logic.leftIndex,
      swapTo: logic.mergeIndex,
      swapProgress: logic.mergeAnimation.value,
      isSorted: logic.isSorted,
      swapTick: logic.totalMerges,
    );
  }

  Widget _buildBarAnimation() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Bar Chart View',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: logic.numbers.asMap().entries.map((entry) {
                int index = entry.key;
                SortItem item = entry.value;

                Color barColor = Colors.blue;
                if (logic.isMerging) {
                  if (index == logic.leftIndex) {
                    barColor = Colors.orange;
                  } else if (index == logic.rightIndex) {
                    barColor = Colors.purple;
                  } else if (index == logic.mergeIndex) {
                    barColor = Colors.red;
                  }
                }
                if (logic.isSorted) {
                  barColor = Colors.green;
                }

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 30,
                  height: (item.value / 100) * 200 + 20,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      '${item.value}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
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

    return _buildTreeLevel(logic.numbers.map((e) => e.value).toList(), 0);
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
    } else if (logic.isSorting && logic.isDividing) {
      nodeColor = Colors.orange.shade100;
    } else if (logic.isSorting && logic.isMerging) {
      nodeColor = Colors.purple.shade100;
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

  Widget _buildColorLegendRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _legendItem(Colors.blue, 'Unsorted'),
            const SizedBox(width: 12),
            _legendItem(Colors.orange, 'Dividing'),
            const SizedBox(width: 12),
            _legendItem(Colors.purple, 'Merging'),
            const SizedBox(width: 12),
            _legendItem(Colors.red, 'Comparing'),
            const SizedBox(width: 12),
            _legendItem(Colors.green, 'Sorted'),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3)
          )
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildMetricsRow(BuildContext context) {
    return MetricsPanel(
      metrics: [
        MetricItem(
          label: 'Step',
          value: logic.isMerging ? 'Merge' : (logic.isDividing ? 'Divide' : '-'),
          color: logic.isMerging ? Colors.purple : Colors.orange
        ),
        MetricItem(
          label: 'Comparisons',
          value: logic.totalComparisons,
          color: Colors.red
        ),
        MetricItem(
          label: 'Merges',
          value: logic.totalMerges,
          color: Colors.purple
        ),
        MetricItem(
          label: 'Order',
          value: logic.isAscending ? 'Asc' : 'Desc',
          color: Colors.blue
        ),
      ],
    );
  }

  Widget buildStatusDisplay(BuildContext context) {
    return StatusDisplay(
      message: logic.currentStep,
      backgroundColor: logic.isSorting
          ? Colors.blue.shade50
          : (logic.isSorted ? Colors.green.shade50 : Colors.grey.shade50),
      borderColor: logic.isSorting
          ? Colors.blue
          : (logic.isSorted ? Colors.green : Colors.grey),
    );
  }

  Widget buildCodeAndControlsArea(BuildContext context) {
    return CodeDisplay(
      title: 'Merge Sort Algorithm',
      codeLines: _getMergeSortCodeLines(),
      highlightedLine: logic.highlightedLine,
      getTextColor: (String text) {
        if (text.contains('function') || text.contains('if') || text.contains('while')) {
          return Colors.purple;
        } else if (text.contains('return')) {
          return Colors.blue;
        } else if (text.contains('//')) {
          return Colors.green;
        }
        return Colors.black87;
      },
    );
  }

  List<CodeLine> _getMergeSortCodeLines() {
    return [
      const CodeLine(line: 0, text: 'function mergeSort(arr):', indent: 0),
      const CodeLine(line: 1, text: 'if arr.length <= 1:', indent: 1),
      const CodeLine(line: 2, text: 'return arr', indent: 2),
      const CodeLine(line: 3, text: '', indent: 0),
      const CodeLine(line: 4, text: 'mid = arr.length / 2', indent: 1),
      const CodeLine(line: 5, text: 'left = mergeSort(arr[0...mid])', indent: 1),
      const CodeLine(line: 6, text: 'right = mergeSort(arr[mid...end])', indent: 1),
      const CodeLine(line: 7, text: '', indent: 0),
      const CodeLine(line: 8, text: 'return merge(left, right)', indent: 1),
      const CodeLine(line: 9, text: '', indent: 0),
      const CodeLine(line: 10, text: 'function merge(left, right):', indent: 0),
      const CodeLine(line: 11, text: 'result = []', indent: 1),
      const CodeLine(line: 12, text: 'i = 0, j = 0', indent: 1),
      const CodeLine(line: 13, text: '', indent: 0),
      const CodeLine(line: 14, text: 'while i < left.length AND j < right.length:', indent: 1),
      const CodeLine(line: 15, text: 'if left[i] <= right[j]:', indent: 2),
      const CodeLine(line: 16, text: 'result.add(left[i])', indent: 3),
      const CodeLine(line: 17, text: 'i++', indent: 3),
      const CodeLine(line: 18, text: 'else:', indent: 2),
      const CodeLine(line: 19, text: 'result.add(right[j])', indent: 3),
      const CodeLine(line: 20, text: 'j++', indent: 3),
      const CodeLine(line: 21, text: '', indent: 0),
      const CodeLine(line: 22, text: '// Add remaining elements', indent: 1),
      const CodeLine(line: 23, text: 'while i < left.length:', indent: 1),
      const CodeLine(line: 24, text: 'result.add(left[i])', indent: 2),
      const CodeLine(line: 25, text: 'i++', indent: 2),
      const CodeLine(line: 26, text: 'while j < right.length:', indent: 1),
      const CodeLine(line: 27, text: 'result.add(right[j])', indent: 2),
      const CodeLine(line: 28, text: 'j++', indent: 2),
      const CodeLine(line: 29, text: '', indent: 0),
      const CodeLine(line: 30, text: 'return result', indent: 1),
    ];
  }
}

class TreeLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;

    final double centerX = size.width / 2;
    final double quarterX = size.width / 4;
    final double threeQuarterX = 3 * size.width / 4;

    // Draw lines from center to quarters
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(quarterX, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(threeQuarterX, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
