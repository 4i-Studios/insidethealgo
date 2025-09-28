import 'package:flutter/material.dart';
import '../../widgets/animated_search_card.dart';
import '../../widgets/color_legend.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/code_display.dart';
import '../../widgets/input_section.dart';
import '../../widgets/status_display.dart';
import 'binary_search_logic.dart';

class BinarySearchWidgets {
  final BinarySearchLogic logic;

  BinarySearchWidgets(this.logic);
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade50, Colors.white],
        ),
      ),
      child: Column(
        children: [
          if (!logic.searchCompleted) ...[_buildSearchInfo()],
          ColorLegend(
            items: [
              ColorLegendItem(color: Colors.blue.shade100, label: 'Unsearched'),
              ColorLegendItem(
                color: Colors.blue.shade200,
                label: 'Active Range',
              ),
              ColorLegendItem(color: Colors.blue.shade600, label: 'Left (L)'),
              ColorLegendItem(color: Colors.orange.shade400, label: 'Mid (M)'),
              ColorLegendItem(
                color: Colors.purple.shade400,
                label: 'Right (R)',
              ),
              ColorLegendItem(color: Colors.grey.shade400, label: 'Discarded'),
              ColorLegendItem(color: Colors.green.shade500, label: 'Found'),
            ],
          ),
          if (logic.isSearching || logic.searchCompleted) ...[
            _buildStatusChips(context),
            // const SizedBox(height: 8),
          ],
          Expanded(
            child: AnimatedSearchCard(
              numbers: logic.numbers,
              currentIndex: logic.midIndex,
              foundIndex: logic.foundIndex,
              isSearching: logic.isSearching,
              searchCompleted: logic.searchCompleted,
              isFound: logic.isFound,
              leftIndex: logic.leftIndex >= 0 ? logic.leftIndex : null,
              rightIndex: logic.rightIndex >= 0 ? logic.rightIndex : null,
              colorBuilder: logic.getBarColor,
              labelBuilder: logic.getBarLabel,
              examinedIndices: logic.examinedIndices,
              discardedIndices: logic.discardedIndices,
              focusAnimation: logic.searchAnimation,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInfo() {
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
          // const SizedBox(width: 6),
          Text(
            'Target: ${logic.targetValue}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          if (logic.isSearching &&
              logic.leftIndex >= 0 &&
              logic.rightIndex >= 0) ...[
            const SizedBox(width: 16),
            Icon(Icons.search, color: Colors.blue.shade700, size: 16),
            const SizedBox(width: 6),
            Text(
              'Range: [${logic.leftIndex}, ${logic.rightIndex}]',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChips(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatusChip(
              label: 'Left',
              value: '${logic.leftIndex >= 0 ? logic.leftIndex : '-'}',
              color: Colors.blue.shade600,
            ),
            const SizedBox(width: 8),
            StatusChip(
              label: 'Mid',
              value: '${logic.midIndex >= 0 ? logic.midIndex : '-'}',
              color: Colors.orange.shade400,
            ),
            const SizedBox(width: 8),
            StatusChip(
              label: 'Right',
              value: '${logic.rightIndex >= 0 ? logic.rightIndex : '-'}',
              color: Colors.purple.shade400,
            ),
            const SizedBox(width: 8),
            StatusChip(
              label: 'Target',
              value: '${logic.targetValue}',
              color: Colors.blue,
            ),
            const SizedBox(width: 8),
            StatusChip(
              label: 'Steps',
              value: '${logic.totalSteps}',
              color: Colors.teal,
            ),
            const SizedBox(width: 8),
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
        ),
      ),
    );
  }

  Widget buildStatusDisplay(BuildContext context) {
    String message = logic.operationIndicator.isNotEmpty
        ? logic.operationIndicator
        : logic.currentStep;
    Color backgroundColor = logic.isFound
        ? Colors.green.shade100
        : logic.searchCompleted && !logic.isFound
        ? Colors.red.shade100
        : !logic.isArraySorted
        ? Colors.red.shade100
        : logic.midIndex >= 0
        ? Colors.orange.shade100
        : Colors.blue.shade100;
    Color borderColor = logic.isFound
        ? Colors.green.shade300
        : logic.searchCompleted && !logic.isFound
        ? Colors.red.shade300
        : !logic.isArraySorted
        ? Colors.red.shade300
        : logic.midIndex >= 0
        ? Colors.orange.shade300
        : Colors.blue.shade300;
    return StatusDisplay(
      message: message,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
    );
  }

  Widget buildCodeAndControlsArea(BuildContext context) {
    return CodeDisplay(
      title: 'Binary Search Code',
      highlightedLine: logic.highlightedLine,
      getTextColor: CodeDisplay.getDefaultTextColor(),
      codeLines: [
        CodeLine(
          line: 0,
          text: 'int binarySearch(List<int> arr, int target) {',
          indent: 0,
        ),
        CodeLine(
          line: 1,
          text: '  int left = 0, right = arr.length - 1;',
          indent: 1,
        ),
        CodeLine(line: 2, text: '  while (left <= right) {', indent: 1),
        CodeLine(
          line: 3,
          text: '    int mid = (left + right) ~/ 2;',
          indent: 2,
        ),
        CodeLine(line: 4, text: '    if (arr[mid] == target) {', indent: 2),
        CodeLine(line: 5, text: '      return mid;', indent: 3),
        CodeLine(
          line: 6,
          text: '    } else if (arr[mid] < target) {',
          indent: 2,
        ),
        CodeLine(line: 7, text: '      left = mid + 1;', indent: 3),
        CodeLine(line: 8, text: '    } else {', indent: 2),
        CodeLine(line: 9, text: '      right = mid - 1;', indent: 3),
        CodeLine(line: 10, text: '    }', indent: 2),
        CodeLine(line: 11, text: '  }', indent: 1),
        CodeLine(line: 12, text: '  return -1;', indent: 1),
        CodeLine(line: 13, text: '}', indent: 0),
      ],
    );
  }
}
