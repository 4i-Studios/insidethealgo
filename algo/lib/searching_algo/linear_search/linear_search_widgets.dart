import 'package:flutter/material.dart';
import 'linear_search_logic.dart';
import '../../widgets/animated_search_card.dart';
import '../../widgets/color_legend.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/code_display.dart';
import '../../widgets/input_section.dart';
import '../../widgets/status_display.dart';

class LinearSearchWidgets {
  final LinearSearchLogic logic;

  LinearSearchWidgets(this.logic);

  Widget buildInputSection(BuildContext context) {
    return Container(
      // constraints: const BoxConstraints(maxWidth: 300), // Provide a bounded width
      child: Row(
        mainAxisSize: MainAxisSize.min, // Shrink-wrap the row's width
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.loose, // Loose fit to avoid taking all available space
            child: InputSection(
              controller: logic.arrayController,
              isDisabled: logic.isSearching,
              onSetPressed: () => logic.setArrayFromInput(context),
            ),
          ),
          // const SizedBox(width: 16),
          Container(
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Wrapping the TextField with a SizedBox to set a specific width
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: logic.targetController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      hintText: 'Enter Target',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    onSubmitted: (_) => logic.setTargetFromInput(context),
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: logic.isSearching
                        ? null
                        : () => logic.setTargetFromInput(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('Set', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
      if (!logic.searchCompleted) ...[
          _buildTargetDisplay(),
    ],
          ColorLegend(
            items: [
              ColorLegendItem(color: Colors.blue, label: 'Unsearched'),
              ColorLegendItem(color: Colors.orange, label: 'Checking'),
              ColorLegendItem(color: Colors.grey, label: 'Searched'),
              ColorLegendItem(color: Colors.green, label: 'Found'),
              ColorLegendItem(color: Colors.red, label: 'Not Found'),
            ],
          ),
          if (logic.isSearching || logic.searchCompleted) ...[
            _buildStatusChips(),
            // const SizedBox(height: 8),
          ],
          Expanded(
            child: AnimatedSearchCard(
              numbers: logic.numbers,
              currentIndex: logic.currentIndex,
              foundIndex: logic.foundIndex,
              isSearching: logic.isSearching,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.gps_fixed, color: Colors.blue.shade700, size: 16),
          const SizedBox(width: 6),
          Text(
            'Target: ${logic.targetValue}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StatusChip(
          label: 'Position',
          value: '${logic.currentIndex >= 0 ? logic.currentIndex : '-'}',
          color: Colors.orange,
        ),
        StatusChip(
          label: 'Target',
          value: '${logic.targetValue}',
          color: Colors.blue,
        ),
        StatusChip(
          label: 'Comparisons',
          value: '${logic.totalComparisons}',
          color: Colors.purple,
        ),
        StatusChip(
          label: 'Status',
          value: logic.isFound
              ? 'Found'
              : (logic.searchCompleted ? 'Not Found' : 'Searching'),
          color: logic.isFound
              ? Colors.green
              : (logic.searchCompleted ? Colors.red : Colors.grey),
        ),
      ],
    );
  }

  Widget buildStatusDisplay(BuildContext context) {
    return StatusDisplay(
      message: logic.operationIndicator.isNotEmpty
          ? logic.operationIndicator
          : logic.currentStep,
      backgroundColor: logic.isFound
          ? Colors.green.shade100
          : logic.searchCompleted && !logic.isFound
          ? Colors.red.shade100
          : logic.currentIndex >= 0
          ? Colors.orange.shade100
          : Colors.blue.shade100,
      borderColor: logic.isFound
          ? Colors.green.shade300
          : logic.searchCompleted && !logic.isFound
          ? Colors.red.shade300
          : logic.currentIndex >= 0
          ? Colors.orange.shade300
          : Colors.blue.shade300,
    );
  }

Widget buildCodeAndControlsArea(BuildContext context) {
  // Replace placeholders with dynamic values
  List<CodeLine> dynamicCodeLines = [
    CodeLine(line: 0, text: 'int linearSearch(List<int> arr, int target) {', indent: 0),
    CodeLine(line: 1, text: '  int n = ${logic.numbers.length};', indent: 1),
    CodeLine(line: 2, text: '  for (int i = 0; i < n; i++) {', indent: 1),
    CodeLine(line: 3, text: '    if (arr[i] == ${logic.targetValue}) {', indent: 2),
    CodeLine(line: 4, text: '      return i; // Found at index i', indent: 3),
    CodeLine(line: 5, text: '    }', indent: 2),
    CodeLine(line: 6, text: '  }', indent: 1),
    CodeLine(line: 7, text: '  return -1; // Not found', indent: 1),
    CodeLine(line: 8, text: '}', indent: 0),
  ];

  return CodeDisplay(
    title: 'Linear Search Code',
    highlightedLine: logic.highlightedLine,
    getTextColor: CodeDisplay.getDefaultTextColor(),
    codeLines: dynamicCodeLines,
  );
}
}
