import 'package:flutter/material.dart';
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
    return Container(
      color: logic.isArraySorted ? Colors.blue.shade50 : Colors.red.shade50,
      child: Column(
        children: [
          if (!logic.isArraySorted)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.red.shade100,
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red.shade700, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Array must be sorted for binary search!',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 8,
              bottom: 0,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: logic.arrayController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 13),
                    enabled: !logic.isSearching,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      hintText: 'Enter sorted numbers (e.g. 11,12,22,25,34)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      errorText: logic.inputError,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: logic.isSearching
                        ? null
                        : () => logic.setArrayFromInput(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
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
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    controller: logic.targetController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 13),
                    enabled: !logic.isSearching,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      hintText: 'Target (e.g. 34)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                    ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
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
                const SizedBox(width: 6),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: logic.isSearching ? null : logic.sortArray,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: logic.isArraySorted
                          ? Colors.green
                          : Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                      minimumSize: const Size(0, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('Sort', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
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
          _buildSearchInfo(),
          _buildColorLegend(),
          if (logic.isSearching || logic.searchCompleted) ...[
            _buildStatusChips(context),
            const SizedBox(height: 8),
          ],
          Expanded(child: _buildAnimatedBars(context)),
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
          const SizedBox(width: 6),
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

  Widget _buildColorLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildColorLegendItem(Colors.blue, 'Unsearched'),
            const SizedBox(width: 16),
            _buildColorLegendItem(Colors.lightBlue, 'Search Range'),
            const SizedBox(width: 16),
            _buildColorLegendItem(Colors.orange, 'Left (L)'),
            const SizedBox(width: 16),
            _buildColorLegendItem(Colors.purple, 'Mid (M)'),
            const SizedBox(width: 16),
            _buildColorLegendItem(Colors.red, 'Right (R)'),
            const SizedBox(width: 16),
            _buildColorLegendItem(Colors.green, 'Found'),
          ],
        ),
      ),
    );
  }

  Widget _buildColorLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
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
            _buildStatusChip(
              'Left',
              '${logic.leftIndex >= 0 ? logic.leftIndex : '-'}',
              Colors.orange,
            ),
            const SizedBox(width: 8),
            _buildStatusChip(
              'Mid',
              '${logic.midIndex >= 0 ? logic.midIndex : '-'}',
              Colors.purple,
            ),
            const SizedBox(width: 8),
            _buildStatusChip(
              'Right',
              '${logic.rightIndex >= 0 ? logic.rightIndex : '-'}',
              Colors.red,
            ),
            const SizedBox(width: 8),
            _buildStatusChip('Target', '${logic.targetValue}', Colors.blue),
            const SizedBox(width: 8),
            _buildStatusChip('Steps', '${logic.totalSteps}', Colors.teal),
            const SizedBox(width: 8),
            _buildStatusChip(
              'Status',
              logic.isFound
                  ? 'Found'
                  : (logic.searchCompleted ? 'Not Found' : 'Searching'),
              logic.isFound
                  ? Colors.green
                  : (logic.searchCompleted ? Colors.red : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildAnimatedBars(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double totalHeight = constraints.maxHeight;
        double reservedHeight = 40;
        double availableBarHeight = (totalHeight - reservedHeight).clamp(
          20.0,
          double.infinity,
        );
        int maxNumber = logic.numbers.isNotEmpty
            ? logic.numbers.reduce((a, b) => a > b ? a : b)
            : 1;

        return AnimatedBuilder(
          animation: logic.searchAnimation,
          builder: (context, child) {
            return Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: totalHeight,
                  padding: EdgeInsets.symmetric(
                    horizontal: _getResponsiveSize(
                      context,
                      defaultSize: 16,
                      minSize: 8,
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: logic.numbers.asMap().entries.map((entry) {
                      int index = entry.key;
                      int value = entry.value;
                      Color barColor = logic.getBarColor(index);
                      String label = logic.getBarLabel(index);

                      double minBarHeight = _getResponsiveSize(
                        context,
                        defaultSize: 10,
                        minSize: 6,
                      );
                      double calculatedHeight =
                          (value / maxNumber) * availableBarHeight;
                      double barHeight = calculatedHeight.clamp(
                        minBarHeight,
                        availableBarHeight,
                      );

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: _getResponsiveSize(
                            context,
                            defaultSize: 4,
                            minSize: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (label.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: barColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            Text(
                              '$value',
                              style: TextStyle(
                                fontSize: _getResponsiveSize(
                                  context,
                                  defaultSize: 12,
                                  minSize: 10,
                                ),
                                fontWeight: FontWeight.bold,
                                color: barColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: _getResponsiveSize(
                                context,
                                defaultSize: 30,
                                minSize: 20,
                              ),
                              height: barHeight,
                              decoration: BoxDecoration(
                                color: barColor,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$index',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildStatusDisplay(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: logic.isFound
            ? Colors.green.shade100
            : logic.searchCompleted && !logic.isFound
            ? Colors.red.shade100
            : !logic.isArraySorted
            ? Colors.red.shade100
            : logic.midIndex >= 0
            ? Colors.orange.shade100
            : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: logic.isFound
              ? Colors.green.shade300
              : logic.searchCompleted && !logic.isFound
              ? Colors.red.shade300
              : !logic.isArraySorted
              ? Colors.red.shade300
              : logic.midIndex >= 0
              ? Colors.orange.shade300
              : Colors.blue.shade300,
        ),
      ),
      child: Column(
        children: [
          logic.operationIndicator.isNotEmpty
              ? Text(
                  logic.operationIndicator,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: logic.isFound
                        ? Colors.green.shade800
                        : logic.searchCompleted && !logic.isFound
                        ? Colors.red.shade800
                        : logic.midIndex >= 0
                        ? Colors.orange.shade800
                        : Colors.blue.shade800,
                  ),
                  textAlign: TextAlign.center,
                )
              : Text(
                  logic.currentStep,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
        ],
      ),
    );
  }

Widget buildCodeAndControlsArea(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Binary Search Code:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            constraints: const BoxConstraints(maxHeight: double.infinity),
            child: SingleChildScrollView(
              child: _buildCodeDisplay(context),
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildCodeDisplay(BuildContext context) {
    int n = logic.numbers.length;
    String leftVal = logic.leftIndex >= 0 ? '${logic.leftIndex}' : '0';
    String rightVal = logic.rightIndex >= 0
        ? '${logic.rightIndex}'
        : '${n - 1}';
    String midVal = logic.midIndex >= 0 ? '${logic.midIndex}' : 'mid';
    String targetStr = '${logic.targetValue}';
    String arrMid =
        (logic.midIndex >= 0 && logic.midIndex < logic.numbers.length)
        ? '${logic.numbers[logic.midIndex]}'
        : 'arr[mid]';

    List<Map<String, dynamic>> codeLines = [
      {
        'line': 0,
        'text': 'int binarySearch(List<int> arr, int target) {',
        'indent': 0,
      },
      {
        'line': 1,
        'text': '  int left = $leftVal, right = $rightVal;',
        'indent': 1,
      },
      {'line': 2, 'text': '  while (left <= right) {', 'indent': 1},
      {
        'line': 3,
        'text': '    int mid = ($leftVal + $rightVal) ~/ 2;',
        'indent': 2,
      },
      {'line': 4, 'text': '    if ($arrMid == $targetStr) {', 'indent': 2},
      {
        'line': 5,
        'text': '      return mid; // Found at index mid',
        'indent': 3,
      },
      {
        'line': 6,
        'text': '    } else if ($arrMid < $targetStr) {',
        'indent': 2,
      },
      {
        'line': 7,
        'text': '      left = mid + 1; // Search right half',
        'indent': 3,
      },
      {'line': 8, 'text': '    } else {', 'indent': 2},
      {
        'line': 9,
        'text': '      right = mid - 1; // Search left half',
        'indent': 3,
      },
      {'line': 10, 'text': '    }', 'indent': 2},
      {'line': 11, 'text': '  }', 'indent': 1},
      {'line': 12, 'text': '  return -1; // Not found', 'indent': 1},
      {'line': 13, 'text': '}', 'indent': 0},
      if (logic.searchCompleted)
        {
          'line': 14,
          'text': logic.isFound ? '// Found! ✨' : '// Not found ❌',
          'indent': 0,
        },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildCodeHeader(), _buildCodeContent(context, codeLines)],
      ),
    );
  }

  Widget _buildCodeHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D30),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'BinarySearch.dart',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

Widget _buildCodeContent(
  BuildContext context,
  List<Map<String, dynamic>> codeLines,
) {
  return Container(
    padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8), // Reduced padding
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: codeLines.map((codeLine) {
            if (codeLine['line'] == 14 && !logic.searchCompleted) {
              return const SizedBox.shrink();
            }

            bool isHighlighted = logic.highlightedLine == codeLine['line'];

            return Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 64, // Adjusted for padding
              ),
              padding: EdgeInsets.symmetric(
                vertical: _getResponsiveSize(context, defaultSize: 1.5, minSize: 1), // Reduced
                horizontal: _getResponsiveSize(context, defaultSize: 4, minSize: 2),
              ),
              margin: EdgeInsets.symmetric(
                vertical: _getResponsiveSize(context, defaultSize: 0.5, minSize: 0.25), // Reduced
              ),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? const Color(0xFF264F78).withOpacity(0.8)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(3),
                border: isHighlighted
                    ? Border.all(color: const Color(0xFF0E639C), width: 1)
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: _getResponsiveSize(context, defaultSize: 24, minSize: 20),
                    child: Text(
                      '${codeLine['line'] + 1}',
                      style: TextStyle(
                        fontSize: _getResponsiveSize(context, defaultSize: 12, minSize: 10),
                        color: const Color(0xFF858585),
                        fontFamily: 'Courier',
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(width: _getResponsiveSize(context, defaultSize: 8, minSize: 4)),
                  SizedBox(
                    width: codeLine['indent'] *
                        _getResponsiveSize(context, defaultSize: 16, minSize: 12),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      codeLine['text'],
                      style: TextStyle(
                        fontSize: _getResponsiveSize(context, defaultSize: 13, minSize: 11),
                        color: _getCodeTextColor(codeLine['text']),
                        fontFamily: 'Courier',
                        height: 1.2, // Reduced line height
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    ),
  );
}

  Color _getCodeTextColor(String text) {
    if (text.contains('int') ||
        text.contains('while') ||
        text.contains('if') ||
        text.contains('return') ||
        text.contains('else')) {
      return const Color(0xFF569CD6);
    } else if (text.contains('arr[') ||
        text.contains('target') ||
        text.contains('left') ||
        text.contains('right') ||
        text.contains('mid')) {
      return const Color(0xFFDCDCAA);
    } else if (text.contains('}') || text.contains('//')) {
      return const Color(0xFF808080);
    } else if (text.contains('Found!') || text.contains('Not found')) {
      return const Color(0xFF4EC9B0);
    }
    return Colors.white;
  }
}
