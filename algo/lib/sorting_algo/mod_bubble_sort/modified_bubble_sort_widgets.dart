import 'package:flutter/material.dart';
import 'modified_bubble_sort_logic.dart';
import '../../widgets/animated_bubble.dart';
import '../../widgets/input_section.dart';
import '../../widgets/metrics_panel.dart';
import '../../widgets/status_display.dart';
import '../../widgets/code_display.dart';

class ModifiedBubbleSortWidgets {
  final ModifiedBubbleSortLogic logic;

  ModifiedBubbleSortWidgets(this.logic);

  Widget buildInputSection(BuildContext context) {
    return InputSection(
      controller: logic.inputController,
      isDisabled: logic.isSorting,
      onSetPressed: () => logic.setArrayFromInput(context),
      hintText: 'Enter up to 10 numbers (e.g. 5,2,9)',
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
          _buildColorLegend(),
          if (logic.isSorting || logic.isSorted) ...[
            // const SizedBox(height: 8),
            MetricsPanel(
              metrics: [
                MetricItem(label: 'Pass', value: logic.currentI >= 0 ? logic.currentI + 1 : '-', color: Colors.blue),
                MetricItem(label: 'Position', value: logic.currentJ >= 0 ? logic.currentJ + 1 : '-', color: Colors.purple),
                MetricItem(label: 'Comparisons', value: logic.totalComparisons, color: Colors.orange),
                MetricItem(label: 'Swaps', value: logic.totalSwaps, color: Colors.red),
                MetricItem(label: 'Array', value: logic.numbers.map((e) => e.value).toList(), color: Colors.grey, isArray: true),
              ],
              title: 'Metrics',
              height: 48,
            ),
            // const SizedBox(height: 8),
          ],
          Expanded(
            child: Center(
              child: AnimatedBubble(
                numbers: logic.numbers.map((e) => e.value).toList(),
                comparingIndex1: logic.comparingIndex1,
                comparingIndex2: logic.comparingIndex2,
                isSwapping: logic.isSwapping,
                swapFrom: logic.swapFrom,
                swapTo: logic.swapTo,
                swapProgress: logic.swapProgress,
                isSorted: logic.isSorted,
                swapTick: logic.swapTick,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildColorLegendItem(Colors.blue, 'Unsorted'),
            const SizedBox(width: 16),
            _buildColorLegendItem(Colors.orange, 'Comparing'),
            const SizedBox(width: 16),
            _buildColorLegendItem(Colors.red, 'Swapping'),
            const SizedBox(width: 16),
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
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget buildStatusDisplay(BuildContext context) {
    Color bg;
    Color border;
    if (logic.isSwapping) {
      bg = Colors.red.shade100;
      border = Colors.red.shade300;
    } else if (logic.comparingIndex1 >= 0) {
      bg = Colors.orange.shade100;
      border = Colors.orange.shade300;
    } else {
      bg = Colors.blue.shade100;
      border = Colors.blue.shade300;
    }

    String message = logic.operationIndicator.isNotEmpty ? logic.operationIndicator : logic.currentStep;

    return StatusDisplay(
      message: message,
      backgroundColor: bg,
      borderColor: border,
    );
  }

  Widget buildCodeAndControlsArea(BuildContext context) {
    int n = logic.numbers.length;
    String iValue = logic.currentI >= 0 ? '${logic.currentI}' : '0';
    String jValue = logic.currentJ >= 0 ? '${logic.currentJ}' : '0';
    String nValue = '$n';

    List<CodeLine> codeLines = [
      CodeLine(line: 0, text: 'void modifiedBubbleSort(List<int> arr, bool ascending) {', indent: 0),
      CodeLine(line: 1, text: 'for (int i = $iValue; i < $nValue - 1; i++) {', indent: 1),
      CodeLine(line: 2, text: '  bool swapped = false;', indent: 2),
      CodeLine(line: 3, text: '  for (int j = $jValue; j < $nValue - $iValue - 1; j++) {', indent: 2),
      CodeLine(line: 4, text: '    if (arr[j] > arr[j + 1]) {', indent: 3),
      CodeLine(line: 5, text: '      swap(arr[j], arr[j + 1]);', indent: 4),
      CodeLine(line: 6, text: '      swapped = true;', indent: 4),
      CodeLine(line: 7, text: '    }', indent: 3),
      CodeLine(line: 8, text: '  }', indent: 2),
      CodeLine(line: 9, text: '  if (!swapped) break;', indent: 2),
      CodeLine(line: 10, text: '}', indent: 1),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Modified Bubble Sort Code:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
              ElevatedButton.icon(
                onPressed: logic.isSorting ? null : logic.toggleSortOrder,
                icon: Icon(logic.isAscending ? Icons.arrow_upward : Icons.arrow_downward, size: 18),
                label: Text(logic.isAscending ? 'Ascending' : 'Descending'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: logic.isAscending ? Colors.blue : Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          // const SizedBox(height: 8),
          SizedBox(
            height: 320,
            child: CodeDisplay(
              title: 'ModifiedBubbleSort',
              codeLines: codeLines,
              highlightedLine: logic.highlightedLine,
              getTextColor: (text) => Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
