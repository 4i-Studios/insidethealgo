import 'package:flutter/material.dart';
import '../../widgets/animated_bubble.dart';
import '../../widgets/input_section.dart';
import '../../widgets/code_display.dart';
import '../../widgets/metrics_panel.dart';
import '../../widgets/status_display.dart';
import 'insertion_sort_logic.dart';

class InsertionSortWidgets {
  final InsertionSortLogic logic;

  InsertionSortWidgets(this.logic);

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
          _buildColorLegendRow(),
          if (logic.isSorting || logic.isSorted) ...[
            // const SizedBox(height: 8),
            _buildMetricsRow(context),
          ],
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: AnimatedBubble(
                numbers: logic.numbers.map((e) => e.value).toList(),
                comparingIndex1: logic.currentJ >= 0 ? logic.currentJ : -1,
                comparingIndex2: logic.keyIndex >= 0 ? logic.keyIndex : -1,
                isSwapping: false,
                swapFrom: -1,
                swapTo: -1,
                swapProgress: logic.insertAnimation.value,
                isSorted: logic.isSorted,
                swapTick: logic.totalInsertions, // triggers reposition after insert
              ),
            ),
          ),
        ],
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
            _legendItem(Colors.purple.shade300, 'Key'),
            const SizedBox(width: 12),
            _legendItem(Colors.orange, 'Comparing'),
            const SizedBox(width: 12),
            _legendItem(Colors.red, 'Inserting'),
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
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildMetricsRow(BuildContext context) {
    return MetricsPanel(
      metrics: [
        MetricItem(label: 'Pass', value: logic.currentI >= 0 ? logic.currentI : '-', color: Colors.blue),
        MetricItem(label: 'Key', value: logic.keyItem != null ? logic.keyItem!.value : '-', color: Colors.purple),
        MetricItem(label: 'Comparisons', value: logic.totalComparisons, color: Colors.orange),
        MetricItem(label: 'Insertions', value: logic.totalInsertions, color: Colors.red),
        MetricItem(label: 'Array', value: logic.numbers.map((e) => e.value).toList(), color: Colors.grey, isArray: true),
      ],
      title: 'Metrics',
      height: 48,
    );
  }

  Widget buildStatusDisplay(BuildContext context) {
    Color bg;
    Color border;
    if (logic.isInserting) {
      bg = Colors.red.shade100;
      border = Colors.red.shade300;
    } else if (logic.keyItem != null) {
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
    // Build code lines
    int n = logic.numbers.length;
    String iValue = logic.currentI >= 0 ? '${logic.currentI}' : '1';
    String jValue = logic.currentJ >= 0 ? '${logic.currentJ}' : 'i-1';
    String keyValue = logic.keyItem != null ? '${logic.keyItem!.value}' : 'arr[i]';
    String compareOp = logic.isAscending ? '>' : '<';
    String arrJ = (logic.currentJ >= 0 && logic.currentJ < logic.numbers.length) ? '${logic.numbers[logic.currentJ].value}' : 'arr[j]';

    List<CodeLine> codeLines = [
      CodeLine(line: 0, text: 'void insertionSort(List<int> arr, bool ascending) {', indent: 0),
      CodeLine(line: 1, text: 'for (int i = $iValue; i < $n; i++) {', indent: 1),
      CodeLine(line: 2, text: 'int key = $keyValue;', indent: 2),
      CodeLine(line: 3, text: 'int j = $jValue;', indent: 2),
      CodeLine(line: 4, text: 'while (j >= 0 && $arrJ $compareOp key) {', indent: 2),
      CodeLine(line: 5, text: 'arr[j + 1] = arr[j];', indent: 3),
      CodeLine(line: 6, text: 'j--;', indent: 3),
      CodeLine(line: 7, text: '}', indent: 2),
      CodeLine(line: 8, text: 'arr[j + 1] = key;', indent: 2),
      CodeLine(line: 9, text: '}', indent: 1),
      CodeLine(line: 10, text: '}', indent: 0),
    ];

    if (logic.isSorted) {
      codeLines.add(CodeLine(line: 11, text: '// Sorting Complete! ✨', indent: 0));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Insertion Algorithm Code:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
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
          const SizedBox(height: 8),
          SizedBox(
            height: 400,
            child: CodeDisplay(
              title: 'InsertionSort',
              codeLines: codeLines,
              highlightedLine: logic.highlightedLine,
              getTextColor: (text) {
                if (logic.highlightedLine >= 0 && text.contains('while')) return Colors.yellow.shade200;
                return Colors.white;
              },
            ),
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}