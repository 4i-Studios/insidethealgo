import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../widgets/input_section.dart';
import '../../widgets/code_display.dart';
import '../../widgets/metrics_panel.dart';
import '../../widgets/status_display.dart';
import 'merge_sort_logic.dart' hide NodeState;

class MergeSortWidgets {
  final MergeSortLogic logic;
  final double leafNodeWidth = 120.0;
  final double levelHeight = 110.0;
  final ScrollController hController = ScrollController();
  final ScrollController vController = ScrollController();

  MergeSortWidgets(this.logic);

  void dispose() {
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
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.blue.shade50, Colors.white]),
      ),
      child: Column(children: [
        _buildColorLegendRow(),
        if (logic.isSorting || logic.isSorted) _buildMetricsRow(context),
        const SizedBox(height: 8),
        Expanded(child: Center(child: _buildDynamicTreeAnimation())),
      ]),
    );
  }

  Widget _buildDynamicTreeAnimation() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
      child: Column(children: [
        const Padding(padding: EdgeInsets.all(8.0), child: Text('Dynamic Merge Sort Tree', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(200),
              minScale: 0.5,
              maxScale: 2.0,
              constrained: false,
              child: _buildDynamicTreeStructure(),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildDynamicTreeStructure() {
    if (logic.numbers.isEmpty) return const Center(child: Text('Start sorting to see the dynamic tree'));

    final int leafCount = logic.numbers.length;
    final double leafSpacing = leafNodeWidth;

    // Only build nodes that have been visited during the algorithm
    final Map<String, _DynamicNodeInfo> visibleNodes = {};
    int maxDepth = 0;

    // Build positions for all possible nodes (for layout calculation)
    final Map<String, _DynamicNodeInfo> allPossibleNodes = {};

    double buildAllPositions(int start, int end, int level) {
      maxDepth = math.max(maxDepth, level);
      final String key = '$start-$end';

      if (start == end) {
        final double x = start * leafSpacing + leafSpacing / 2.0 + 40;
        final double y = level * levelHeight + 40;
        allPossibleNodes[key] = _DynamicNodeInfo(start: start, end: end, level: level, x: x, y: y);
        return x;
      }

      final int mid = start + (end - start) ~/ 2;
      final double leftCenter = buildAllPositions(start, mid, level + 1);
      final double rightCenter = buildAllPositions(mid + 1, end, level + 1);
      final double cx = (leftCenter + rightCenter) / 2.0;
      final double y = level * levelHeight + 40;
      allPossibleNodes[key] = _DynamicNodeInfo(start: start, end: end, level: level, x: cx, y: y);
      return cx;
    }

    buildAllPositions(0, leafCount - 1, 0);

    // Only show nodes that have been visited or are currently being processed
    for (final entry in allPossibleNodes.entries) {
      final String key = entry.key;
      if (logic.visitedRanges.contains(key) ||
          logic.dividingRanges.contains(key) ||
          logic.mergingRanges.contains(key) ||
          logic.completedRanges.contains(key) ||
          (logic.activeRangeLeft != -1 && key == '${logic.activeRangeLeft}-${logic.activeRangeRight}')) {
        visibleNodes[key] = entry.value;
      }
    }

    final double contentWidth = math.max((leafCount * leafSpacing) + 80,
        visibleNodes.values.map((n) => n.x).fold(0.0, math.max) + leafSpacing);
    final double contentHeight = (maxDepth + 2) * levelHeight + 120; // Extra space for merge results

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToActiveNodeIfNeeded(contentWidth, contentHeight, visibleNodes));

    return Scrollbar(
      controller: hController,
      child: SingleChildScrollView(
        controller: hController,
        scrollDirection: Axis.horizontal,
        child: Scrollbar(
          controller: vController,
          child: SingleChildScrollView(
            controller: vController,
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: contentWidth,
              height: contentHeight,
              child: Stack(clipBehavior: Clip.none, children: [
                // Dynamic connection lines
                Positioned.fill(
                  child: CustomPaint(
                    painter: _DynamicTreeLinesPainter(
                      nodes: visibleNodes,
                      visitedRanges: logic.visitedRanges,
                      mergingRanges: logic.mergingRanges,
                      completedRanges: logic.completedRanges,
                      mergeAnimationValue: logic.mergeAnimation.value,
                    ),
                  ),
                ),

                // Dynamic nodes (only visible ones)
                for (final entry in visibleNodes.entries)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutQuart,
                    left: entry.value.x - (entry.value.isLeaf ? leafNodeWidth / 2 : entry.value.widthForLevel / 2),
                    top: entry.value.y - 28,
                    child: AnimatedScale(
                      scale: logic.visitedRanges.contains(entry.key) ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutBack,
                      child: AnimatedOpacity(
                        opacity: logic.visitedRanges.contains(entry.key) ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        child: SizedBox(
                          width: entry.value.isLeaf ? leafNodeWidth : entry.value.widthForLevel.clamp(100, 300),
                          child: _buildDynamicTreeNode(
                            _getCurrentArrayState(entry.value.start, entry.value.end),
                            entry.value.level,
                            entry.value.isLeaf,
                            entry.value.start,
                            entry.value.end,
                            entry.value.isLeaf ? leafNodeWidth : entry.value.widthForLevel
                          ),
                        ),
                      ),
                    ),
                  ),

                // Merge result nodes (appear below their parent nodes during merge phase)
                for (final merged in logic.mergedNodes.entries)
                  if (visibleNodes.containsKey(merged.key))
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      left: visibleNodes[merged.key]!.x - visibleNodes[merged.key]!.widthForLevel / 2,
                      top: visibleNodes[merged.key]!.y + levelHeight / 2,
                      child: AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                        child: AnimatedScale(
                          scale: 1.0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutBack,
                          child: SizedBox(
                            width: visibleNodes[merged.key]!.widthForLevel.clamp(100, 300),
                            child: _buildMergeResultNode(merged.key, visibleNodes[merged.key]!.widthForLevel)
                          ),
                        ),
                      ),
                    ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToActiveNodeIfNeeded(double contentWidth, double contentHeight, Map<String, _DynamicNodeInfo> nodes) {
    if (logic.activeRangeLeft < 0 || logic.activeRangeRight < logic.activeRangeLeft) return;

    final String rangeKey = '${logic.activeRangeLeft}-${logic.activeRangeRight}';
    if (!nodes.containsKey(rangeKey)) return;

    final _DynamicNodeInfo node = nodes[rangeKey]!;

    final double viewportW = hController.hasClients ? hController.position.viewportDimension : 600.0;
    final double viewportH = vController.hasClients ? vController.position.viewportDimension : 400.0;

    final double targetCenterX = node.x;
    final double desiredScrollX = (targetCenterX - viewportW / 2.0).clamp(0.0, math.max(0.0, contentWidth - viewportW));

    final double targetCenterY = node.y;
    final double desiredScrollY = (targetCenterY - viewportH / 2.0).clamp(0.0, math.max(0.0, contentHeight - viewportH));

    try {
      if (hController.hasClients) hController.animateTo(desiredScrollX, duration: const Duration(milliseconds: 420), curve: Curves.easeInOut);
      if (vController.hasClients) vController.animateTo(desiredScrollY, duration: const Duration(milliseconds: 420), curve: Curves.easeInOut);
    } catch (_) {}
  }

  Widget _buildDynamicTreeNode(List<int> array, int level, bool isLeaf, int startIndex, int endIndex, double width) {
    final bool isActiveExact = (logic.activeRangeLeft == startIndex && logic.activeRangeRight == endIndex);
    final String rangeKey = '$startIndex-$endIndex';

    final bool isDividingNode = logic.dividingRanges.contains(rangeKey);
    final bool isMergingNode = logic.mergingRanges.contains(rangeKey);
    final bool isCompletedNode = logic.completedRanges.contains(rangeKey);

    Color nodeColor;
    IconData? statusIcon;
    Color? iconColor;

    if (isLeaf) {
      nodeColor = isCompletedNode ? Colors.green.shade200 : Colors.green.shade100;
      if (isCompletedNode) {
        statusIcon = Icons.check_circle;
        iconColor = Colors.green;
      }
    } else if (isActiveExact && logic.isDividing) {
      nodeColor = Colors.orange.shade200;
      statusIcon = Icons.call_split;
      iconColor = Colors.orange;
    } else if (isActiveExact && logic.isMerging) {
      nodeColor = Colors.purple.shade200;
      statusIcon = Icons.merge_type;
      iconColor = Colors.purple;
    } else if (isCompletedNode) {
      nodeColor = Colors.green.shade100;
      statusIcon = Icons.check_circle;
      iconColor = Colors.green;
    } else if (isMergingNode) {
      nodeColor = Colors.purple.shade100;
      statusIcon = Icons.merge_type;
      iconColor = Colors.purple;
    } else if (isDividingNode) {
      nodeColor = Colors.orange.shade100;
      statusIcon = Icons.call_split;
      iconColor = Colors.orange;
    } else {
      nodeColor = Colors.blue.shade100;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: nodeColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActiveExact ? Colors.deepPurple.shade400 :
                 (isCompletedNode ? Colors.green.shade600 : Colors.grey.shade400),
          width: (isActiveExact || isCompletedNode) ? 2.0 : 1
        ),
        boxShadow: isActiveExact ?
          [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 6))] :
          [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (statusIcon != null) ...[
              Icon(statusIcon, size: 16, color: iconColor),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                '[$startIndex-$endIndex]',
                style: TextStyle(
                  fontSize: ((11 - (level ~/ 2)).clamp(8, 12)).toDouble(),
                  fontWeight: FontWeight.w700
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width - 20),
          child: Text(
            '[${array.join(', ')}]',
            style: TextStyle(
              fontSize: (10 - level * 0.5).clamp(8, 12).toDouble(),
              fontWeight: isCompletedNode ? FontWeight.w700 : FontWeight.w500,
              color: isCompletedNode ? Colors.green.shade800 : Colors.black87
            ),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 1,
            textAlign: TextAlign.center
          ),
        ),

        // Dividing animation
        if (isActiveExact && logic.isDividing) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.arrow_downward, size: 16, color: Colors.orange.shade700),
              Text('DIVIDING', style: TextStyle(fontSize: 10, color: Colors.orange.shade700, fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_downward, size: 16, color: Colors.orange.shade700),
            ],
          ),
        ],

        // Merging animation
        if (isActiveExact && logic.isMerging) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 20,
            child: AnimatedBuilder(
              animation: logic.mergeAnimation,
              builder: (context, child) {
                final t = logic.mergeAnimation.value;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Text('MERGING', style: TextStyle(fontSize: 10, color: Colors.purple.shade700, fontWeight: FontWeight.bold)),
                    Positioned(
                      left: (t * (width - 40)).clamp(0, width - 40),
                      child: AnimatedOpacity(
                        opacity: (1.0 - (t - 0.5).abs() * 2).clamp(0.5, 1.0),
                        duration: const Duration(milliseconds: 100),
                        child: Icon(Icons.merge, size: 14, color: Colors.purple.shade600),
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
        ],
      ]),
    );
  }

  Widget _buildMergeResultNode(String rangeKey, double width) {
    final mergedData = logic.mergedNodes[rangeKey]!;
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade100, Colors.teal.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.shade400, width: 2),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB((0.5 * 255).round(), Colors.teal.shade200.red, Colors.teal.shade200.green, Colors.teal.shade200.blue),
            blurRadius: 10,
            offset: const Offset(0, 4)
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(Icons.auto_awesome, size: 10, color: Colors.teal.shade700),
              // const SizedBox(width: 2),
              Text(
                'MERGED RESULT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                  fontSize: 10,
                )
              ),
            ]
          ),
          const SizedBox(height: 6),
          Text(
            '[${mergedData.join(', ')}]',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.teal.shade800,
              fontSize: 13,
            )
          )
        ]
      ),
    );
  }

  List<int> _getCurrentArrayState(int startIndex, int endIndex) {
    final List<int> currentState = [];
    for (int i = startIndex; i <= endIndex && i < logic.numbers.length; i++) {
      currentState.add(logic.numbers[i].value);
    }
    return currentState;
  }

  Widget _buildColorLegendRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _legendItem(Colors.blue, 'Unsorted'),
          const SizedBox(width: 12),
          _legendItem(Colors.orange, 'Dividing'),
          const SizedBox(width: 12),
          _legendItem(Colors.purple, 'Merging'),
          const SizedBox(width: 12),
          _legendItem(Colors.teal, 'Merged Result'),
          const SizedBox(width: 12),
          _legendItem(Colors.green, 'Completed'),
        ]),
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 14, height: 14, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 12))
    ]);
  }

  Widget _buildMetricsRow(BuildContext context) {
    return MetricsPanel(metrics: [
      MetricItem(label: 'Phase', value: logic.isMerging ? 'Conquer' : (logic.isDividing ? 'Divide' : '-'), color: logic.isMerging ? Colors.purple : Colors.orange),
      MetricItem(label: 'Comparisons', value: logic.totalComparisons, color: Colors.red),
      MetricItem(label: 'Merges', value: logic.totalMerges, color: Colors.purple),
      MetricItem(label: 'Order', value: logic.isAscending ? 'Asc' : 'Desc', color: Colors.blue),
    ]);
  }

  Widget buildStatusDisplay(BuildContext context) {
    return StatusDisplay(
      message: logic.currentStep,
      backgroundColor: logic.isSorting ? Colors.blue.shade50 : (logic.isSorted ? Colors.green.shade50 : Colors.grey.shade50),
      borderColor: logic.isSorting ? Colors.blue : (logic.isSorted ? Colors.green : Colors.grey)
    );
  }

  Widget buildCodeAndControlsArea(BuildContext context) {
    return CodeDisplay(
      title: 'Merge Sort Algorithm',
      codeLines: _getMergeSortCodeLines(),
      highlightedLine: logic.highlightedLine,
      getTextColor: CodeDisplay.getDefaultTextColor()
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

class _DynamicNodeInfo {
  final int start;
  final int end;
  final int level;
  final double x;
  final double y;

  _DynamicNodeInfo({required this.start, required this.end, required this.level, required this.x, required this.y});

  bool get isLeaf => start == end;
  double get widthForLevel => (140.0 - level * 8).clamp(80.0, 240.0);
}

class _DynamicTreeLinesPainter extends CustomPainter {
  final Map<String, _DynamicNodeInfo> nodes;
  final Set<String> visitedRanges;
  final Set<String> mergingRanges;
  final Set<String> completedRanges;
  final double mergeAnimationValue;

  _DynamicTreeLinesPainter({
    required this.nodes,
    required this.visitedRanges,
    required this.mergingRanges,
    required this.completedRanges,
    required this.mergeAnimationValue
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 3.0..style = PaintingStyle.stroke;

    for (final entry in nodes.entries) {
      final node = entry.value;
      if (!node.isLeaf) {
        final int mid = node.start + (node.end - node.start) ~/ 2;
        final leftKey = '${node.start}-$mid';
        final rightKey = '${mid + 1}-${node.end}';

        // Only draw connections if both child nodes exist (are visible)
        if (!nodes.containsKey(leftKey) || !nodes.containsKey(rightKey)) continue;

        final left = nodes[leftKey]!;
        final right = nodes[rightKey]!;

        // Dynamic line coloring based on algorithm state
        if (mergingRanges.contains(entry.key)) {
          paint.color = Colors.purple.shade600;
          paint.strokeWidth = 4.0;
        } else if (completedRanges.contains(entry.key)) {
          paint.color = Colors.green.shade600;
          paint.strokeWidth = 3.5;
        } else if (visitedRanges.contains(entry.key)) {
          paint.color = Colors.blue.shade400;
          paint.strokeWidth = 3.0;
        } else {
          paint.color = Colors.grey.shade400;
          paint.strokeWidth = 2.0;
        }

        final pTop = Offset(node.x, node.y + 18);
        final pLeft = Offset(left.x, left.y - 8);
        final pRight = Offset(right.x, right.y - 8);

        // Animated connection lines
        final pathL = Path();
        pathL.moveTo(pTop.dx, pTop.dy);
        pathL.quadraticBezierTo(
          (pTop.dx + pLeft.dx) / 2,
          (pTop.dy + pLeft.dy) / 2,
          pLeft.dx,
          pLeft.dy
        );
        canvas.drawPath(pathL, paint);

        final pathR = Path();
        pathR.moveTo(pTop.dx, pTop.dy);
        pathR.quadraticBezierTo(
          (pTop.dx + pRight.dx) / 2,
          (pTop.dy + pRight.dy) / 2,
          pRight.dx,
          pRight.dy
        );
        canvas.drawPath(pathR, paint);

        // Add visual indicators for active operations
        if (mergingRanges.contains(entry.key)) {
          paint.style = PaintingStyle.fill;
          paint.color = Color.fromARGB((0.3 * 255).round(), Colors.purple.shade300.red, Colors.purple.shade300.green, Colors.purple.shade300.blue);
          canvas.drawCircle(pTop, 8, paint);
          paint.style = PaintingStyle.stroke;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
