import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../widgets/input_section.dart';
import '../../widgets/code_display.dart';
import '../../widgets/metrics_panel.dart';
import '../../widgets/status_display.dart';
import 'merge_sort_logic.dart';

class MergeSortWidgets {
  final MergeSortLogic logic;

  // Approximate width reserved per leaf node
  final double leafNodeWidth = 120.0;
  // Per-level vertical spacing for simple layout + animation positioning
  final double levelHeight = 110.0;

  // Scroll controllers to allow programmatic focus on a node (x and y)
  final ScrollController hController = ScrollController();
  final ScrollController vController = ScrollController();

  MergeSortWidgets(this.logic);

  void dispose() {
    // dispose controllers when the widgets helper is disposed by the page
    hController.dispose();
    vController.dispose();
  }

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
          // _buildAnimationModeHeader(),
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

  // Widget _buildAnimationModeHeader() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         const Text(
  //           'Tree View',
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildCurrentAnimation() => _buildTreeAnimation();

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
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(200),
                minScale: 0.5,
                maxScale: 2.0,
                // allow the child to be larger than the viewport so scrollbars/controllers can work
                constrained: false,
                child: _buildTreeStructure(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeStructure() {
    if (logic.numbers.isEmpty) return const Center(child: Text('Start sorting to see the tree'));

    final int leafCount = logic.numbers.length;
    final double width = (leafCount * leafNodeWidth).clamp(leafNodeWidth, 5000.0);

    // Calculate maximum depth to reserve a reasonable height for the scrollable area
    final int maxDepth = (leafCount <= 1) ? 1 : (math.log(leafCount) / math.log(2)).ceil() + 1;
    final double totalHeight = (maxDepth + 1) * levelHeight + 80;

    // Build tree content inside scroll views so both horizontal and vertical scrolling are possible
    return LayoutBuilder(builder: (context, constraints) {
      final double viewportW = constraints.maxWidth.isFinite ? constraints.maxWidth : 600.0;
      final double viewportH = constraints.maxHeight.isFinite ? constraints.maxHeight : 400.0;

      // Trigger scrolling to the active node after the frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToActiveNodeIfNeeded(width, viewportW, viewportH, maxDepth);
      });

      return Scrollbar(
        child: SingleChildScrollView(
          controller: hController,
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            controller: vController,
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: width,
              height: totalHeight,
              child: _buildTreeLevel(logic.numbers.map((e) => e.value).toList(), 0, 0, logic.numbers.length - 1, width),
            ),
          ),
        ),
      );
    });
  }

  void _scrollToActiveNodeIfNeeded(double contentWidth, double viewportW, double viewportH, int maxDepth) {
    if (logic.activeRangeLeft < 0 || logic.activeRangeRight < logic.activeRangeLeft) return;

    // choose center index of active range
    final double centerIndex = (logic.activeRangeLeft + logic.activeRangeRight) / 2.0;

    final double targetCenterX = centerIndex * leafNodeWidth + leafNodeWidth / 2.0;
    final double desiredScrollX = (targetCenterX - viewportW / 2.0).clamp(0.0, math.max(0.0, contentWidth - viewportW));

    final double level = (logic.activeRangeLevel >= 0) ? logic.activeRangeLevel.toDouble() : 0.0;
    final double targetCenterY = (level * levelHeight) + (levelHeight / 2.0);
    final double contentHeight = (maxDepth + 1) * levelHeight + 80;
    final double desiredScrollY = (targetCenterY - viewportH / 2.0).clamp(0.0, math.max(0.0, contentHeight - viewportH));

    try {
      if (hController.hasClients) {
        hController.animateTo(desiredScrollX, duration: const Duration(milliseconds: 420), curve: Curves.easeInOut);
      }
      if (vController.hasClients) {
        vController.animateTo(desiredScrollY, duration: const Duration(milliseconds: 420), curve: Curves.easeInOut);
      }
    } catch (e) {
      // ignore if controllers are not ready
    }
  }

  Widget _buildTreeLevel(List<int> array, int level, int startIndex, int endIndex, double availableWidth) {
    // If leaf
    if (array.length <= 1) {
      return Align(
        alignment: Alignment.center,
        child: SizedBox(width: leafNodeWidth, child: _buildTreeNode(array, level, true, startIndex, endIndex, leafNodeWidth)),
      );
    }

    // For non-leaf nodes, support progressive expansion based on visitedRanges
    final String rangeKey = '$startIndex-$endIndex';
    int mid = array.length ~/ 2;
    List<int> left = array.sublist(0, mid);
    List<int> right = array.sublist(mid);
    int midIndex = startIndex + left.length - 1;

    final double childWidth = availableWidth / 2;

    final bool isVisited = logic.visitedRanges.contains(rangeKey);

    // Header node always shown
    final Widget header = Align(
      alignment: Alignment.center,
      child: SizedBox(width: availableWidth, child: _buildTreeNode(array, level, false, startIndex, endIndex, availableWidth)),
    );

    // If not yet visited (divided), show collapsed indicator only
    if (!isVisited) {
      return Column(
        children: [
          header,
          const SizedBox(height: 6),
          SizedBox(width: availableWidth, height: 16, child: CustomPaint(painter: TreeLinePainter())),
          // Collapsed placeholder to indicate a split will happen
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
            child: Text('… dividing …', style: TextStyle(color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
          ),
        ],
      );
    }

    // If visited, animate children appearing (divide animation)
    return Column(
      children: [
        header,
        const SizedBox(height: 6),
        SizedBox(width: availableWidth, height: 16, child: CustomPaint(painter: TreeLinePainter())),
        AnimatedSize(
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: childWidth,
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 420),
                  child: _buildTreeLevel(left, level + 1, startIndex, midIndex, childWidth),
                ),
              ),
              SizedBox(
                width: childWidth,
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 420),
                  child: _buildTreeLevel(right, level + 1, midIndex + 1, endIndex, childWidth),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTreeNode(List<int> array, int level, bool isLeaf, int startIndex, int endIndex, double width) {
    // Determine if this node corresponds to the currently active range
    bool isActiveExact = (logic.activeRangeLeft == startIndex && logic.activeRangeRight == endIndex);
    bool isActiveContains = (logic.activeRangeLeft >= startIndex && logic.activeRangeRight <= endIndex && logic.activeRangeLeft != -1);

    final String rangeKey = '$startIndex-$endIndex';
    bool isDividingNode = logic.dividingRanges.contains(rangeKey);
    bool isMergingNode = logic.mergingRanges.contains(rangeKey);
    bool isCompletedNode = logic.completedRanges.contains(rangeKey);

    Color nodeColor;
    if (isLeaf) {
      nodeColor = isCompletedNode ? Colors.green.shade200 : Colors.green.shade100;
    } else if (isActiveExact && logic.isDividing) {
      nodeColor = Colors.orange.shade200;
    } else if (isActiveExact && logic.isMerging) {
      nodeColor = Colors.purple.shade200;
    } else if (isCompletedNode) {
      nodeColor = Colors.green.shade100;
    } else if (isMergingNode) {
      nodeColor = Colors.purple.shade100;
    } else if (isDividingNode) {
      nodeColor = Colors.orange.shade100;
    } else if (isActiveContains) {
      nodeColor = Colors.yellow.shade100;
    } else {
      nodeColor = Colors.blue.shade100;
    }

    // Animate focus for the active node (slight scale + stronger border/shadow)
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: nodeColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActiveExact
            ? Colors.deepPurple.shade400
            : (isCompletedNode ? Colors.green.shade600 : Colors.grey.shade400),
          width: (isActiveExact || isCompletedNode) ? 2.0 : 1
        ),
        boxShadow: isActiveExact ? [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0,4))] : [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0,1))],
      ),
      child: AnimatedScale(
        scale: isActiveExact ? 1.06 : 1.0,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: show whether dividing or merging when active
            // Use Wrap instead of Row to avoid overflow on narrow screens
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              runSpacing: 2,
              children: [
                if (isActiveExact && logic.isDividing) ...[
                  Icon(Icons.call_split, size: 14, color: Colors.orange.shade800),
                ] else if (isActiveExact && logic.isMerging) ...[
                  Icon(Icons.merge_type, size: 14, color: Colors.purple.shade800),
                ] else if (isCompletedNode) ...[
                  Icon(Icons.check_circle, size: 14, color: Colors.green.shade800),
                ],
                Text(
                  '[$startIndex-${endIndex}]',
                  style: TextStyle(fontSize: ((11 - (level ~/ 2)).clamp(8, 12)).toDouble(), fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Values
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width - 20),
              child: Text(
                '[${array.join(', ')}]',
                style: TextStyle(
                  fontSize: (10 - level).clamp(8, 12).toDouble(),
                  fontWeight: isCompletedNode ? FontWeight.w700 : FontWeight.w500,
                  color: isCompletedNode ? Colors.green.shade800 : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
            // Simple animated arrows to suggest movement into parent during merging
            if (isActiveExact && logic.isMerging) ...[
              const SizedBox(height: 8),
              LayoutBuilder(builder: (context, constraints) {
                final double maxW = constraints.maxWidth.isFinite ? constraints.maxWidth : 200.0;
                return SizedBox(
                  height: 18,
                  width: maxW,
                  child: AnimatedBuilder(
                    animation: logic.mergeAnimation,
                    builder: (context, child) {
                      final t = logic.mergeAnimation.value;
                      // Two arrows moving left-to-right with offset
                      final double span = (maxW - 16).clamp(0.0, maxW);
                      final double x1 = (t * span);
                      final double x2 = (((t + 0.5) % 1.0) * span);
                      return Stack(
                        children: [
                          Positioned(left: x1, top: 0, child: Icon(Icons.arrow_forward, size: 14, color: Colors.purple.shade700)),
                          Positioned(left: x2, top: 0, child: Icon(Icons.arrow_forward, size: 14, color: Colors.orange.shade700)),
                        ],
                      );
                    },
                  ),
                );
              }),
            ],
            // Show completion indicator for merged nodes
            if (isCompletedNode && !isActiveExact) ...[
              const SizedBox(height: 4),
              Container(
                height: 2,
                width: width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.green.shade400,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ],
        ),
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
        return Colors.white;
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
