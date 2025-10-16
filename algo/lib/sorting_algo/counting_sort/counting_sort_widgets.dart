import 'package:flutter/material.dart';
import '../../widgets/animated_bubble.dart';
import '../../widgets/input_section.dart';
import '../../widgets/code_display.dart';
import '../../widgets/metrics_panel.dart';
import '../../widgets/status_display.dart';
import 'counting_sort_logic.dart';

class CountingSortWidgets {
  final CountingSortLogic logic;

  CountingSortWidgets(this.logic);

  Widget buildInputSection(BuildContext context) {
    return InputSection(
      controller: logic.inputController,
      isDisabled: logic.isSorting,
      onSetPressed: () => logic.setArrayFromInput(context),
      hintText: 'Enter up to 15 numbers (e.g. 64,34,25,12)',
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
            _buildMetricsRow(context),
          ],
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              const double bubbleWidth = 40;
              const double spacing = 8;
              final int count = logic.numbers.length;
              final double totalWidth = count * bubbleWidth + (count - 1) * spacing + 10;
              final double screenWidth = MediaQuery.of(context).size.width;
              final double contentWidth = totalWidth < screenWidth ? screenWidth : totalWidth;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: contentWidth,
                  child: Center(
                    child: AnimatedBubble(
                      numbers: logic.numbers.map((e) => e.value).toList(),
                      comparingIndex1: logic.currentIndex >= 0 ? logic.currentIndex : -1,
                      comparingIndex2: logic.placingIndex >= 0 ? logic.placingIndex : -1,
                      isSwapping: false,
                      swapFrom: -1,
                      swapTo: -1,
                      swapProgress: logic.countAnimation.value,
                      isSorted: logic.isSorted,
                      swapTick: logic.totalPlacements,
                    ),
                  ),
                ),
              );
            }),
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
            _legendItem(Colors.blue.shade300, 'Unsorted'),
            const SizedBox(width: 12),
            _legendItem(Colors.orange, 'Current'),
            const SizedBox(width: 12),
            _legendItem(Colors.purple.shade300, 'Initializing'),
            const SizedBox(width: 12),
            _legendItem(Colors.red, 'Counting'),
            const SizedBox(width: 12),
            _legendItem(Colors.teal.shade300, 'Cumulative'),
            const SizedBox(width: 12),
            _legendItem(Colors.green.shade400, 'Placing'),
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
            borderRadius: BorderRadius.circular(3),
          ),
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
          label: 'Phase',
          value: _getPhaseLabel(),
          color: Colors.blue,
        ),
        MetricItem(
          label: 'Range',
          value: logic.currentPhase >= 1 ? '[${logic.minValue},${logic.maxValue}]' : '-',
          color: Colors.purple,
        ),
        MetricItem(
          label: 'Count Size',
          value: logic.countArray.isNotEmpty ? logic.countArray.length : '-',
          color: Colors.orange,
        ),
        MetricItem(
          label: 'Placements',
          value: logic.totalPlacements,
          color: Colors.green,
        ),
        MetricItem(
          label: 'Array',
          value: logic.numbers.map((e) => e.value).toList(),
          color: Colors.grey,
          isArray: true,
        ),
      ],
      title: 'Metrics',
      height: 48,
    );
  }

  String _getPhaseLabel() {
    switch (logic.currentPhase) {
      case 0:
        return 'Init';
      case 1:
        return 'Range';
      case 2:
        return 'Init Count';
      case 3:
        return 'Counting';
      case 4:
        return 'Cumulative';
      case 5:
        return 'Placing';
      case 6:
        return 'Done';
      default:
        return '-';
    }
  }

  Widget buildStatusDisplay(BuildContext context) {
    Color bg;
    Color border;

    switch (logic.currentPhase) {
      case 1:
        bg = Colors.orange.shade100;
        border = Colors.orange.shade300;
        break;
      case 2:
        bg = Colors.purple.shade100;
        border = Colors.purple.shade300;
        break;
      case 3:
        bg = Colors.red.shade100;
        border = Colors.red.shade300;
        break;
      case 4:
        bg = Colors.teal.shade100;
        border = Colors.teal.shade300;
        break;
      case 5:
        bg = Colors.green.shade100;
        border = Colors.green.shade300;
        break;
      default:
        bg = Colors.blue.shade100;
        border = Colors.blue.shade300;
    }

    String message = logic.operationIndicator.isNotEmpty
        ? logic.operationIndicator
        : logic.currentStep;

    return StatusDisplay(
      message: message,
      backgroundColor: bg,
      borderColor: border,
    );
  }

  Widget buildCodeAndControlsArea(BuildContext context) {
    int n = logic.numbers.length;
    String minVal = logic.minValue.toString();
    String maxVal = logic.maxValue.toString();
    String range = logic.countArray.isNotEmpty ? logic.countArray.length.toString() : 'k';

    List<CodeLine> codeLines = [
      CodeLine(line: 0, text: 'void countingSort(List<int> arr) {', indent: 0),
      CodeLine(line: 1, text: '  int min = $minVal, max = $maxVal;', indent: 1),
      CodeLine(line: 2, text: '  int range = max - min + 1; // $range', indent: 1),
      CodeLine(line: 3, text: '  List<int> count = List.filled(range, 0);', indent: 1),
      CodeLine(line: 4, text: '  for (int i = 0; i < $n; i++)', indent: 1),
      CodeLine(line: 5, text: '    count[arr[i] - min]++;', indent: 2),
      CodeLine(line: 6, text: '  for (int i = 1; i < range; i++)', indent: 1),
      CodeLine(line: 7, text: '    count[i] += count[i-1];', indent: 2),
      CodeLine(line: 8, text: '  List<int> output = List.filled($n, 0);', indent: 1),
      CodeLine(line: 9, text: '  for (int i = $n-1; i >= 0; i--) {', indent: 1),
      CodeLine(line: 10, text: '    output[--count[arr[i]-min]] = arr[i];', indent: 2),
      CodeLine(line: 11, text: '  }', indent: 1),
      CodeLine(line: 12, text: '}', indent: 0),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Algorithm Code:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 300,
            child: CodeDisplay(
              title: 'CountingSort',
              codeLines: codeLines,
              highlightedLine: logic.highlightedLine,
              getTextColor: CodeDisplay.getDefaultTextColor(),
            ),
          ),
        ],
      ),
    );
  }
}

