import 'package:flutter/material.dart';
import '../../widgets/color_legend.dart';
import '../../widgets/input_section.dart';
import '../../widgets/metrics_panel.dart';
import '../../widgets/status_display.dart';
import '../../widgets/code_display.dart';
import 'bubble_sort_logic.dart';
import '../../widgets/animated_bubble.dart';

class BubbleSortWidgets {
  final BubbleSortLogic logic;

  BubbleSortWidgets(this.logic);


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
          ColorLegend(
            items: [
              ColorLegendItem(color: Colors.blue, label: 'Unsorted'),
              ColorLegendItem(color: Colors.orange, label: 'Selected'),
              ColorLegendItem(color: Colors.purple, label: 'Compared'),
              ColorLegendItem(color: Colors.red, label: 'Swapping'),
              ColorLegendItem(color: Colors.green, label: 'Sorted'),
            ],
          ),
          if (logic.isSorting || logic.isSorted) ...[
            const SizedBox(height: 8),
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
            const SizedBox(height: 8),
          ],
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              // Estimate content width so we can scroll when bubbles exceed screen width
              const double bubbleWidth = 40;
              const double spacing = 8;
              final int count = logic.numbers.length;
              final double totalWidth =  count * bubbleWidth + (count - 1) * spacing ;
              final double screenWidth = MediaQuery.of(context).size.width;
              final double contentWidth = totalWidth < screenWidth ? screenWidth : totalWidth;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: contentWidth,
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
                    )
                    // : BubbleSortAnimatedStack(
                    //     numbers: logic.numbers,
                    //     comparingIndex1: logic.comparingIndex1,
                    //     comparingIndex2: logic.comparingIndex2,
                    //     isSwapping: logic.isSwapping,
                    //     swapFrom: logic.swapFrom,
                    //     swapTo: logic.swapTo,
                    //     swapProgress: logic.swapProgress,
                    //     isSorted: logic.isSorted,
                    //   ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
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
    // Build CodeDisplay lines using shared CodeDisplay widget
    int n = logic.numbers.length;
    String iValue = logic.currentI >= 0 ? '${logic.currentI}' : '0';
    String jValue = logic.currentJ >= 0 ? '${logic.currentJ}' : '0';
    String nValue = '$n';
    String arrJ = (logic.currentJ >= 0 && logic.currentJ < logic.numbers.length)
        ? '${logic.numbers[logic.currentJ].value}'
        : 'arr[j]';
    String arrJplus1 = (logic.currentJ >= 0 && logic.currentJ + 1 < logic.numbers.length)
        ? '${logic.numbers[logic.currentJ + 1].value}'
        : 'arr[j + 1]';
    String compareOp = logic.isAscending ? '>' : '<';

    List<CodeLine> codeLines = [
      CodeLine(line: 0, text: 'void bubbleSort(List<int> arr, bool ascending) {', indent: 0),
      CodeLine(line: 1, text: 'for (int i = $iValue; i < $nValue - 1; i++) {', indent: 1),
      CodeLine(line: 2, text: '  for (int j = $jValue; j < $nValue - $iValue - 1; j++) {', indent: 2),
      CodeLine(line: 3, text: '    if ($arrJ $compareOp $arrJplus1) {', indent: 3),
      CodeLine(line: 4, text: '      swap(arr[j], arr[j + 1]);', indent: 4),
      CodeLine(line: 5, text: '    }', indent: 3),
      CodeLine(line: 6, text: '  }', indent: 2),
      CodeLine(line: 7, text: '}', indent: 1),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Algorithm Code:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
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
            height: 300,
            child: CodeDisplay(
              title: 'BubbleSort',
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