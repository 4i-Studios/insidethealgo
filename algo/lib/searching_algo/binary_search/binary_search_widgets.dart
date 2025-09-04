import 'package:flutter/material.dart';
import '../../widgets/search_animation.dart';
import '../../widgets/color_legend.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/code_display.dart';
import '../../widgets/input_section.dart';
import '../../widgets/status_display.dart';
import 'binary_search_logic.dart';

class BinarySearchWidgets {
  final BinarySearchLogic logic;

  BinarySearchWidgets(this.logic);

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
    return InputSection(
      controller: logic.arrayController,
      isDisabled: logic.isSearching,
      onSetPressed: () => logic.setArrayFromInput(context),
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
          _buildSearchInfo(),
          ColorLegend(
            items: [
              ColorLegendItem(color: Colors.blue, label: 'Unsearched'),
              ColorLegendItem(color: Colors.lightBlue, label: 'Search Range'),
              ColorLegendItem(color: Colors.orange, label: 'Left (L)'),
              ColorLegendItem(color: Colors.purple, label: 'Mid (M)'),
              ColorLegendItem(color: Colors.red, label: 'Right (R)'),
              ColorLegendItem(color: Colors.green, label: 'Found'),
            ],
          ),
          if (logic.isSearching || logic.searchCompleted) ...[
            _buildStatusChips(context),
            // const SizedBox(height: 8),
          ],
          Expanded(
            child: SearchAnimation(
              numbers: logic.numbers,
              indices: {
                'left': logic.leftIndex,
                'mid': logic.midIndex,
                'right': logic.rightIndex,
              },
              colors: {
                'default': Colors.blue,
                'left': Colors.orange,
                'mid': Colors.purple,
                'right': Colors.red,
                'found': Colors.green,
              },
              maxBarHeight: 100.0,
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
              color: Colors.orange,
            ),
            const SizedBox(width: 8),
            StatusChip(
              label: 'Mid',
              value: '${logic.midIndex >= 0 ? logic.midIndex : '-'}',
              color: Colors.purple,
            ),
            const SizedBox(width: 8),
            StatusChip(
              label: 'Right',
              value: '${logic.rightIndex >= 0 ? logic.rightIndex : '-'}',
              color: Colors.red,
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
      title: 'Binary Search Code:',
      getTextColor: (line) => logic.highlightedLine == line ? Colors.red : Colors.black,
      codeLines: [
        CodeLine(line: 0, text: 'int binarySearch(List<int> arr, int target) {', indent: 0),
        CodeLine(line: 1, text: '  int left = 0, right = arr.length - 1;', indent: 1),
        CodeLine(line: 2, text: '  while (left <= right) {', indent: 1),
        CodeLine(line: 3, text: '    int mid = (left + right) ~/ 2;', indent: 2),
        CodeLine(line: 4, text: '    if (arr[mid] == target) {', indent: 2),
        CodeLine(line: 5, text: '      return mid;', indent: 3),
        CodeLine(line: 6, text: '    } else if (arr[mid] < target) {', indent: 2),
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
