import 'package:flutter/material.dart';
import '../../widgets/color_legend.dart';
import '../../widgets/status_chip.dart';
import 'bubble_sort_logic.dart';
import '../../widgets/animated_bubble.dart';

class BubbleSortWidgets {
  final BubbleSortLogic logic;

  BubbleSortWidgets(this.logic);

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
            padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: logic.inputController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      hintText: 'Enter up to 10 numbers (e.g. 5,2,9)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      errorText: null,
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: logic.isSorting ? null : () => logic.setArrayFromInput(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      minimumSize: const Size(0, 36),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatusChip(label: 'Pass', value: '${logic.currentI + 1}', color: Colors.blue),
            StatusChip(label: 'Position', value: '${logic.currentJ + 1}', color: Colors.purple),
            StatusChip(label: 'Comparisons', value: '${logic.totalComparisons}', color: Colors.orange),
            StatusChip(label: 'Swaps', value: '${logic.totalSwaps}', color: Colors.red),
          ],
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
                        numbers: logic.numbers,
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: logic.isSwapping
            ? Colors.red.shade100
            : logic.comparingIndex1 >= 0
            ? Colors.orange.shade100
            : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: logic.isSwapping
              ? Colors.red.shade300
              : logic.comparingIndex1 >= 0
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
              color: logic.isSwapping
                  ? Colors.red.shade800
                  : logic.comparingIndex1 >= 0
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Algorithm Code:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: logic.isSorting ? null : logic.toggleSortOrder,
                  icon: Icon(
                    logic.isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 18,
                  ),
                  label: Text(logic.isAscending ? 'Ascending' : 'Descending'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: logic.isAscending ? Colors.blue : Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildCodeDisplay(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeDisplay(context) {
    int n = logic.numbers.length;
    String iValue = logic.currentI >= 0 ? '${logic.currentI}' : '0';
    String jValue = logic.currentJ >= 0 ? '${logic.currentJ}' : '0';
    String nValue = '$n';
    String arrJ = (logic.currentJ >= 0 && logic.currentJ < logic.numbers.length)
        ? '${logic.numbers[logic.currentJ]}'
        : 'arr[j]';
    String arrJplus1 = (logic.currentJ >= 0 && logic.currentJ + 1 < logic.numbers.length)
        ? '${logic.numbers[logic.currentJ + 1]}'
        : 'arr[j + 1]';
    String compareOp = logic.isAscending ? '>' : '<';
    String swapText = (logic.currentJ >= 0 && logic.currentJ + 1 < logic.numbers.length)
        ? '    swap($arrJ, $arrJplus1);'
        : '    swap(arr[j], arr[j + 1]);';

    List<Map<String, dynamic>> codeLines = [
      {'line': 0, 'text': 'void bubbleSort(List<int> arr, bool ascending) {', 'indent': 0},
      {'line': 1, 'text': 'for (int i = $iValue; i < $nValue - 1; i++) {', 'indent': 1},
      {'line': 2, 'text': 'for (int j = $jValue; j < $nValue - $iValue - 1; j++) {', 'indent': 2},
      {'line': 3, 'text': 'if ($arrJ $compareOp $arrJplus1) {', 'indent': 3},
      {'line': 4, 'text': swapText, 'indent': 3},
      {'line': 5, 'text': '}', 'indent': 2},
      {'line': 6, 'text': 'Sorting Complete!', 'indent': 0},
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
        children: [
          _buildCodeHeader(),
          _buildCodeContent(context, codeLines),
        ],
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
          Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
          const SizedBox(width: 16),
          const Text('BubbleSort.dart', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCodeContent(BuildContext context, List<Map<String, dynamic>> codeLines) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: codeLines.map((codeLine) {
              if (codeLine['line'] == 6 && !logic.isSorted) {
                return const SizedBox.shrink();
              }

              bool isHighlighted = logic.highlightedLine == codeLine['line'];

              return Container(
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 32),
                padding: EdgeInsets.symmetric(
                  vertical: _getResponsiveSize(context, defaultSize: 2, minSize: 1),
                  horizontal: _getResponsiveSize(context, defaultSize: 4, minSize: 2),
                ),
                margin: EdgeInsets.symmetric(
                  vertical: _getResponsiveSize(context, defaultSize: 1, minSize: 0.5),
                ),
                decoration: BoxDecoration(
                  color: isHighlighted ? const Color(0xFF264F78).withValues(alpha: 204) : Colors.transparent,
                  borderRadius: BorderRadius.circular(3),
                  border: isHighlighted ? Border.all(color: const Color(0xFF0E639C), width: 1) : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: _getResponsiveSize(context, defaultSize: 24, minSize: 20),
                      child: Text(
                        '${codeLine['line'] + 1}',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: _getResponsiveSize(context, defaultSize: 12, minSize: 10),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    SizedBox(width: _getResponsiveSize(context, defaultSize: 8, minSize: 4)),
                    SizedBox(width: codeLine['indent'] * _getResponsiveSize(context, defaultSize: 16, minSize: 12)),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        codeLine['text'],
                        style: TextStyle(
                          color: isHighlighted ? Colors.white : _getCodeTextColor(codeLine['text']),
                          fontSize: _getResponsiveSize(context, defaultSize: 12, minSize: 10),
                          fontFamily: 'monospace',
                          fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
                        ),
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
    if (text.contains('void') || text.contains('for') || text.contains('if')) {
      return const Color(0xFF569CD6);
    } else if (text.contains('arr[') || text.contains('swap')) {
      return const Color(0xFFDCDCAA);
    } else if (text.contains('}')) {
      return const Color(0xFF808080);
    } else if (text.contains('Sorting Complete!')) {
      return const Color(0xFF4EC9B0);
    }
    return Colors.white;
  }
}