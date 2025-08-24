import 'package:flutter/material.dart';
import 'merge_sort_logic.dart';

class MergeSortWidgets {
  final MergeSortLogic logic;

  MergeSortWidgets(this.logic);

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
      color: Colors.blue.shade50,
      child: Column(
        children: [
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
                  child: TextField(
                    controller: logic.arrayController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      hintText: 'Enter up to 20 numbers (e.g. 64,34,25,12)',
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
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.red,
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
                    onPressed: logic.isSorting
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
          _buildColorLegend(),
          if (logic.isSorting || logic.sortCompleted) ...[
            _buildStatusChips(context),
            const SizedBox(height: 8),
          ],
          Expanded(child: _buildAnimatedBars(context)),
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
            _buildColorLegendItem(Colors.orange, 'Dividing'),
            const SizedBox(width: 16),
            _buildColorLegendItem(Colors.purple, 'Merging'),
            const SizedBox(width: 16),
            _buildColorLegendItem(Colors.red, 'Current'),
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
              'Comparisons',
              '${logic.totalComparisons}',
              Colors.orange,
            ),
            const SizedBox(width: 8),
            _buildStatusChip('Moves', '${logic.totalSwaps}', Colors.red),
            if (logic.leftArray.isNotEmpty) ...[
              const SizedBox(width: 8),
              _buildArrayChip('Left', logic.leftArray, Colors.blue),
            ],
            if (logic.rightArray.isNotEmpty) ...[
              const SizedBox(width: 8),
              _buildArrayChip('Right', logic.rightArray, Colors.purple),
            ],
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

  Widget _buildArrayChip(String label, List<int> array, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: [${array.join(',')}]',
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
        double reservedHeight = 30;
        double availableBarHeight = (totalHeight - reservedHeight).clamp(
          20.0,
          double.infinity,
        );
        int maxNumber = logic.numbers.isNotEmpty
            ? logic.numbers.reduce((a, b) => a > b ? a : b)
            : 1;

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
                        Text(
                          '$value',
                          style: TextStyle(
                            fontSize: _getResponsiveSize(
                              context,
                              defaultSize: 12,
                              minSize: 10,
                            ),
                            fontWeight: FontWeight.bold,
                            color: logic.getBarColor(index),
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
                            color: logic.getBarColor(index),
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
  }

  Widget buildStatusDisplay(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: logic.mergeIndex >= 0
            ? Colors.red.shade100
            : logic.isSorting
            ? Colors.purple.shade100
            : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: logic.mergeIndex >= 0
              ? Colors.red.shade300
              : logic.isSorting
              ? Colors.purple.shade300
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
                    color: logic.mergeIndex >= 0
                        ? Colors.red.shade800
                        : logic.isSorting
                        ? Colors.purple.shade800
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

  Widget buildCodeDisplay(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Merge Sort Algorithm:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCodeDisplay(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeDisplay(BuildContext context) {
    List<Map<String, dynamic>> codeLines = [
      {
        'line': 0,
        'text': 'void mergeSort(List<int> arr, int left, int right) {',
        'indent': 0,
      },
      {'line': 1, 'text': '  if (left < right) {', 'indent': 1},
      {'line': 2, 'text': '    int mid = (left + right) ~/ 2;', 'indent': 2},
      {'line': 3, 'text': '    mergeSort(arr, left, mid);', 'indent': 2},
      {'line': 4, 'text': '    mergeSort(arr, mid + 1, right);', 'indent': 2},
      {'line': 5, 'text': '    merge(arr, left, mid, right);', 'indent': 2},
      {'line': 6, 'text': '  }', 'indent': 1},
      {'line': 7, 'text': '}', 'indent': 0},
      {'line': 8, 'text': '', 'indent': 0},
      {
        'line': 9,
        'text': 'void merge(List<int> arr, int left, int mid, int right) {',
        'indent': 0,
      },
      {'line': 10, 'text': '  // Create temporary arrays', 'indent': 1},
      {
        'line': 11,
        'text': '  List<int> leftArr = arr.sublist(left, mid + 1);',
        'indent': 1,
      },
      {
        'line': 12,
        'text': '  List<int> rightArr = arr.sublist(mid + 1, right + 1);',
        'indent': 1,
      },
      {'line': 13, 'text': '  int i = 0, j = 0, k = left;', 'indent': 1},
      {'line': 14, 'text': '  // Merge the arrays', 'indent': 1},
      {
        'line': 15,
        'text': '  while (i < leftArr.length && j < rightArr.length) {',
        'indent': 1,
      },
      {'line': 16, 'text': '    if (leftArr[i] <= rightArr[j]) {', 'indent': 2},
      {'line': 17, 'text': '      arr[k] = leftArr[i++];', 'indent': 3},
      {'line': 18, 'text': '    } else {', 'indent': 2},
      {'line': 19, 'text': '      arr[k] = rightArr[j++];', 'indent': 3},
      {'line': 20, 'text': '    }', 'indent': 2},
      {'line': 21, 'text': '    k++;', 'indent': 2},
      {'line': 22, 'text': '  }', 'indent': 1},
      {'line': 23, 'text': '  // Copy remaining elements', 'indent': 1},
      {
        'line': 24,
        'text': '  while (i < leftArr.length) arr[k++] = leftArr[i++];',
        'indent': 1,
      },
      {
        'line': 25,
        'text': '  while (j < rightArr.length) arr[k++] = rightArr[j++];',
        'indent': 1,
      },
      {'line': 26, 'text': '}', 'indent': 0},
      if (logic.sortCompleted)
        {'line': 27, 'text': 'Sorting Complete!', 'indent': 0},
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
            'MergeSort.dart',
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
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: codeLines.map((codeLine) {
              if (codeLine['line'] == 27 && !logic.sortCompleted) {
                return const SizedBox.shrink();
              }

              bool isHighlighted = logic.highlightedLine == codeLine['line'];

              return Container(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 32,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: _getResponsiveSize(
                    context,
                    defaultSize: 2,
                    minSize: 1,
                  ),
                  horizontal: _getResponsiveSize(
                    context,
                    defaultSize: 4,
                    minSize: 2,
                  ),
                ),
                margin: EdgeInsets.symmetric(
                  vertical: _getResponsiveSize(
                    context,
                    defaultSize: 1,
                    minSize: 0.5,
                  ),
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
                      width: _getResponsiveSize(
                        context,
                        defaultSize: 24,
                        minSize: 20,
                      ),
                      child: Text(
                        '${codeLine['line'] + 1}',
                        style: TextStyle(
                          fontSize: _getResponsiveSize(
                            context,
                            defaultSize: 12,
                            minSize: 10,
                          ),
                          color: const Color(0xFF858585),
                          fontFamily: 'Courier',
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(
                      width: _getResponsiveSize(
                        context,
                        defaultSize: 8,
                        minSize: 4,
                      ),
                    ),
                    SizedBox(
                      width:
                          codeLine['indent'] *
                          _getResponsiveSize(
                            context,
                            defaultSize: 16,
                            minSize: 12,
                          ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        codeLine['text'],
                        style: TextStyle(
                          fontSize: _getResponsiveSize(
                            context,
                            defaultSize: 13,
                            minSize: 11,
                          ),
                          color: _getCodeTextColor(codeLine['text']),
                          fontFamily: 'Courier',
                          height: 1.2,
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
    if (text.contains('void') ||
        text.contains('int') ||
        text.contains('if') ||
        text.contains('while') ||
        text.contains('else')) {
      return const Color(0xFF569CD6);
    } else if (text.contains('arr[') ||
        text.contains('left') ||
        text.contains('right') ||
        text.contains('mid') ||
        text.contains('merge')) {
      return const Color(0xFFDCDCAA);
    } else if (text.contains('}') || text.contains('//')) {
      return const Color(0xFF808080);
    } else if (text.contains('Sorting Complete!')) {
      return const Color(0xFF4EC9B0);
    }
    return Colors.white;
  }
}
