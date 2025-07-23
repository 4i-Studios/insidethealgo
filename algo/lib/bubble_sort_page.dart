import 'package:flutter/material.dart';
import 'dart:async';
import 'widgets/expandable_speed_control.dart';

class BubbleSortPage extends StatefulWidget {
  const BubbleSortPage({super.key});

  @override
  State<BubbleSortPage> createState() => _BubbleSortPageState();
}

class _BubbleSortPageState extends State<BubbleSortPage>
    with TickerProviderStateMixin {
  List<int> numbers = [64, 34, 25, 12, 22, 11, 90, 88, 76, 50];
  List<int> originalNumbers = [64, 34, 25, 12, 22, 11, 90, 88, 76, 50];

  int currentI = -1;
  int currentJ = -1;
  int comparingIndex1 = -1;
  int comparingIndex2 = -1;
  bool isSwapping = false;
  bool isSorting = false;
  bool isSorted = false;

  String currentStep = "Ready to start sorting";
  String operationIndicator = "";
  int totalComparisons = 0;
  int totalSwaps = 0;

  // New state variables
  bool isAscending = true; // true for ascending, false for descending
  double speed = 1.0; // Speed multiplier (0.5 = slow, 1.0 = normal, 2.0 = fast)
  bool shouldStop = false; // Flag to stop sorting
  bool isPaused = false;

  // Code highlighting variables
  int highlightedLine = -1; // -1 means no highlight, 0-5 for different lines

  late AnimationController _animationController;
  late Animation<double> _swapAnimation;

  bool isSpeedControlExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _swapAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void resetArray() {
    setState(() {
      numbers = List.from(originalNumbers);
      currentI = -1;
      currentJ = -1;
      comparingIndex1 = -1;
      comparingIndex2 = -1;
      isSwapping = false;
      isSorting = false;
      isSorted = false;
      shouldStop = false;
      highlightedLine = -1;
      currentStep = "Ready to start sorting";
      operationIndicator = "";
      totalComparisons = 0;
      totalSwaps = 0;
    });
  }

  void stopSorting() {
    setState(() {
      shouldStop = true;
      isSorting = false;
      highlightedLine = -1;
      currentStep = "Sorting stopped by user";
      operationIndicator = "⏹️ Sorting process halted";
    });
  }

  void toggleSortOrder() {
    if (!isSorting) {
      setState(() {
        isAscending = !isAscending;
        currentStep = isAscending
            ? "Ready to start sorting (Ascending)"
            : "Ready to start sorting (Descending)";
      });
    }
  }

  void updateSpeed(double newSpeed) {
    setState(() {
      speed = newSpeed;
    });
  }

  void shuffleArray() {
    setState(() {
      numbers.shuffle();
      originalNumbers = List.from(numbers);
      currentI = -1;
      currentJ = -1;
      comparingIndex1 = -1;
      comparingIndex2 = -1;
      isSwapping = false;
      isSorting = false;
      isSorted = false;
      shouldStop = false;
      highlightedLine = -1;
      currentStep = isAscending
          ? "Array shuffled - Ready to start sorting (Ascending)"
          : "Array shuffled - Ready to start sorting (Descending)";
      operationIndicator = "";
      totalComparisons = 0;
      totalSwaps = 0;
    });
  }

  Future<void> _waitIfPaused() async {
    while (isPaused && mounted) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> startBubbleSort() async {
    if (isSorting) return;

    if (!mounted) return;
    setState(() {
      isSorting = true;
      isSorted = false;
      shouldStop = false;
      totalComparisons = 0;
      totalSwaps = 0;
      operationIndicator = "";
      highlightedLine = 0;
    });

    int n = numbers.length;
    String orderText = isAscending ? "ascending" : "descending";

    if (!mounted) return;
    setState(() {
      highlightedLine = 1;
    });
    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (500 / speed).round()));

    for (int i = 0; i < n - 1; i++) {
      if (shouldStop || !mounted) break;

      if (!mounted) break;
      setState(() {
        currentI = i;
        highlightedLine = 1;
        currentStep =
            "Pass ${i + 1}: Finding the ${isAscending ? 'largest' : 'smallest'} element in remaining array";
        operationIndicator =
            "Starting pass ${i + 1} of ${n - 1} ($orderText order)";
      });

      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (500 / speed).round()));
      if (shouldStop || !mounted) break;

      if (!mounted) break;
      setState(() {
        highlightedLine = 2;
      });
      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (300 / speed).round()));

      for (int j = 0; j < n - i - 1; j++) {
        if (shouldStop || !mounted) break;

        await _waitIfPaused();
        setState(() {
          highlightedLine = 2;
          currentJ = j;
        });
        await _waitIfPaused();
        await Future.delayed(Duration(milliseconds: (400 / speed).round()));

        await _waitIfPaused();
        setState(() {
          highlightedLine = 3;
          comparingIndex1 = j;
          comparingIndex2 = j + 1;
          currentStep = "Comparing ${numbers[j]} and ${numbers[j + 1]}";
          operationIndicator =
              "🔍 Comparing: ${numbers[j]} vs ${numbers[j + 1]}";
          totalComparisons++;
        });

        await _waitIfPaused();
        await Future.delayed(Duration(milliseconds: (1000 / speed).round()));
        if (shouldStop || !mounted) break;

        bool shouldSwap = isAscending
            ? numbers[j] > numbers[j + 1]
            : numbers[j] < numbers[j + 1];

        if (shouldSwap) {
          await _waitIfPaused();
          setState(() {
            highlightedLine = 4;
            isSwapping = true;
            currentStep = "Swapping ${numbers[j]} and ${numbers[j + 1]}";
            operationIndicator =
                "🔄 Swapping: ${numbers[j]} ↔ ${numbers[j + 1]} (${isAscending ? '${numbers[j]} > ${numbers[j + 1]}' : '${numbers[j]} < ${numbers[j + 1]}'})";
            totalSwaps++;
          });
          _animationController.duration = Duration(milliseconds: (800 / speed).round());
          await _animationController.forward();
          if (shouldStop || !mounted) break;

          if (!mounted) break;
          setState(() {
            int temp = numbers[j];
            numbers[j] = numbers[j + 1];
            numbers[j + 1] = temp;
          });

          _animationController.reset();
          setState(() {
            isSwapping = false;
          });

          await _waitIfPaused();
          await Future.delayed(Duration(milliseconds: (300 / speed).round()));
        } else {
          await _waitIfPaused();
          setState(() {
            currentStep =
                "No swap needed - ${isAscending ? '${numbers[j]} ≤ ${numbers[j + 1]}' : '${numbers[j]} ≥ ${numbers[j + 1]}'}";
            operationIndicator =
                "✓ No swap: ${isAscending ? '${numbers[j]} ≤ ${numbers[j + 1]}' : '${numbers[j]} ≥ ${numbers[j + 1]}'} (already in order)";
          });
          await _waitIfPaused();
          await Future.delayed(Duration(milliseconds: (800 / speed).round()));
        }
      }

      if (shouldStop || !mounted) break;

      if (mounted) {
        setState(() {
          highlightedLine = 5;
          currentStep =
              "Pass ${i + 1} completed - ${numbers[n - i - 1]} is in correct position";
          operationIndicator =
              "✅ Pass ${i + 1} complete! Element ${numbers[n - i - 1]} is sorted";
        });
        await _waitIfPaused();
        await Future.delayed(Duration(milliseconds: (1000 / speed).round()));
      }
    }

    if (mounted) {
      setState(() {
        currentI = -1;
        currentJ = -1;
        comparingIndex1 = -1;
        comparingIndex2 = -1;
        isSorting = false;
        highlightedLine = -1;

        if (shouldStop) {
          currentStep = "Sorting stopped by user";
          operationIndicator = "⏹️ Sorting was interrupted";
        } else {
          isSorted = true;
          highlightedLine = 6;
          currentStep =
              "Sorting completed! Array is now sorted in $orderText order.";
          operationIndicator =
              "🎉 Sorting Complete! All elements are in $orderText order";
        }
      });
    }
  }

  Color getBarColor(int index) {
    if (isSorted) return Colors.green;
    if (isSwapping && (index == comparingIndex1 || index == comparingIndex2)) {
      return Colors.red;
    }
    if (index == comparingIndex1 || index == comparingIndex2) {
      return Colors.orange;
    }
    if (currentI >= 0 && index >= numbers.length - currentI) {
      return Colors.green.shade300;
    }
    return Colors.blue;
  }

  // Add helper method for responsive sizes
  double _getResponsiveSize(BuildContext context, {
    required double defaultSize,
    required double minSize,
    double? maxSize,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double size = (screenWidth / 400) * defaultSize; // 400 is a reference width
    return size.clamp(minSize, maxSize ?? defaultSize);
  }

  // Update the bar visualization with responsive sizes
  // Inside AnimatedBuilder for bars
  Widget _buildCodeDisplay() {
    int n = numbers.length;
    // Prepare dynamic values for code simulation
    String iValue = currentI >= 0 ? '$currentI' : '0';
    String jValue = currentJ >= 0 ? '$currentJ' : '0';
    String nValue = '$n';
    String nMinus1Value = '${n - 1}';
    String nMinusIValue = currentI >= 0 ? '${n - currentI}' : 'n - i';
    String nMinusIminus1Value = (currentI >= 0)
        ? '${n - currentI - 1}'
        : 'n - i - 1';

    // For arr[j] and arr[j+1]
    String arrJ = (currentJ >= 0 && currentJ < numbers.length)
        ? '${numbers[currentJ]}'
        : 'arr[j]';
    String arrJplus1 = (currentJ >= 0 && currentJ + 1 < numbers.length)
        ? '${numbers[currentJ + 1]}'
        : 'arr[j + 1]';

    // For comparison operator
    String compareOp = isAscending ? '>' : '<';

    // For swap line
    String swapText = (currentJ >= 0 && currentJ + 1 < numbers.length)
        ? '    swap($arrJ, $arrJplus1);'
        : '    swap(arr[j], arr[j + 1]);';

    // Dynamic code lines
    List<Map<String, dynamic>> codeLines = [
      {
        'line': 0,
        'text': 'void bubbleSort(List<int> arr, bool ascending) {',
        'indent': 0,
      },
      {
        'line': 1,
        'text': 'for (int i = $iValue; i < $nValue - 1; i++) {',
        'indent': 1,
      },
      {
        'line': 2,
        'text': 'for (int j = $jValue; j < $nValue - $iValue - 1; j++) {',
        'indent': 2,
      },
      {'line': 3, 'text': 'if ($arrJ $compareOp $arrJplus1) {', 'indent': 3},
      {'line': 4, 'text': swapText, 'indent': 3},
      {'line': 5, 'text': '}', 'indent': 2},
      {'line': 6, 'text': 'Sorting Complete!', 'indent': 0},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // VS Code dark theme
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // VS Code-like header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D30),
              borderRadius: const BorderRadius.only(
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
                  'BubbleSort.dart',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Code content
          Container(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: codeLines.map((codeLine) {
                  if (codeLine['line'] == 6 && !isSorted) {
                    return const SizedBox.shrink(); // Don't show completion line until sorted
                  }

                  bool isHighlighted = highlightedLine == codeLine['line'];

                  return Container(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - 32,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: _getResponsiveSize(context, defaultSize: 2, minSize: 1),
                      horizontal: _getResponsiveSize(context, defaultSize: 4, minSize: 2),
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: _getResponsiveSize(context, defaultSize: 1, minSize: 0.5),
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
                        // Line number
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
                        // Indentation
                        SizedBox(
                          width: codeLine['indent'] * _getResponsiveSize(context, defaultSize: 16, minSize: 12),
                        ),
                        // Code text
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
          ),
        ],
      ),
    );
  }

  Color _getCodeTextColor(String text) {
    if (text.contains('void') || text.contains('for') || text.contains('if')) {
      return const Color(0xFF569CD6); // VS Code keyword blue
    } else if (text.contains('arr[') || text.contains('swap')) {
      return const Color(0xFFDCDCAA); // VS Code variable yellow
    } else if (text.contains('}')) {
      return const Color(0xFF808080); // VS Code bracket gray
    } else if (text.contains('Sorting Complete!')) {
      return const Color(0xFF4EC9B0); // VS Code string teal
    }
    return Colors.white; // Default white
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bubble Sort Algorithm Demo'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  minChildSize: 0.3,
                  maxChildSize: 0.9,
                  builder: (_, controller) => Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Handle bar
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          // Title
                          Row(
                            children: [
                              Icon(Icons.sort, color: Colors.blue.shade700, size: 24),
                              const SizedBox(width: 8),
                              const Text(
                                'Bubble Sort Algorithm',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          
                          // How it Works Section
                          Row(
                            children: [
                              Icon(Icons.tips_and_updates, color: Colors.orange.shade700, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'How it Works:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade100),
                            ),
                            child: Column(
                              children: [
                                _buildStepItem(1, 'Compare adjacent elements in the array'),
                                _buildStepItem(2, 'If elements are in wrong order, swap them'),
                                _buildStepItem(3, 'Continue this process for the entire array'),
                                _buildStepItem(4, 'After each pass, one element "bubbles" to its position'),
                                _buildStepItem(5, 'Repeat until no more swaps are needed'),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Time Complexity Section
                          Row(
                            children: [
                              Icon(Icons.speed, color: Colors.purple.shade700, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Time Complexity:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.purple.shade100),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.check_circle, color: Colors.green.shade700),
                                  title: const Text('Best Case: O(n)'),
                                  subtitle: const Text('Array is already sorted'),
                                  dense: true,
                                ),
                                ListTile(
                                  leading: Icon(Icons.info, color: Colors.orange.shade700),
                                  title: const Text('Average Case: O(n²)'),
                                  subtitle: const Text('Random order'),
                                  dense: true,
                                ),
                                ListTile(
                                  leading: Icon(Icons.error_outline, color: Colors.red.shade700),
                                  title: const Text('Worst Case: O(n²)'),
                                  subtitle: const Text('Array is reverse sorted'),
                                  dense: true,
                                ),
                                ListTile(
                                  leading: Icon(Icons.memory, color: Colors.blue.shade700),
                                  title: const Text('Space Complexity: O(1)'),
                                  subtitle: const Text('Uses constant extra space'),
                                  dense: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
        children: [
          // Animation Area (Top portion)
          Expanded(
            flex: 3,
            child: Container(
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
                  // Color Legend
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildColorLegend(Colors.blue, 'Unsorted'),
                        const SizedBox(width: 16),
                        _buildColorLegend(Colors.orange, 'Comparing'),
                        const SizedBox(width: 16),
                        _buildColorLegend(Colors.red, 'Swapping'),
                        const SizedBox(width: 16),
                        _buildColorLegend(Colors.green, 'Sorted'),
                      ],
                          ),
                    ),
                  ),
                  
                  // Loop Status
                  if (isSorting || isSorted) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatusChip(
                              'Pass',
                              '${currentI + 1}',
                              Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            _buildStatusChip(
                              'Position',
                              '${currentJ + 1}',
                              Colors.purple,
                            ),
                            const SizedBox(width: 8),
                            _buildStatusChip(
                              'Comparisons',
                              '$totalComparisons',
                              Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            _buildStatusChip(
                              'Swaps',
                              '$totalSwaps',
                              Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Animated Bars
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Calculate available height for bars
                        double totalHeight = constraints.maxHeight;
                        double reservedHeight = 30; // For text and spacing
                        double availableBarHeight =
                            totalHeight - reservedHeight;

                        // Ensure minimum available height
                        availableBarHeight = availableBarHeight.clamp(
                          20.0,
                          double.infinity,
                        );

                        int maxNumber = numbers.reduce((a, b) => a > b ? a : b);

                        return AnimatedBuilder(
                          animation: _swapAnimation,
                          builder: (context, child) {
                            return Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  height: totalHeight,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: _getResponsiveSize(context, defaultSize: 16, minSize: 8),
                                  ),
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: numbers.asMap().entries.map((
                                      entry,
                                    ) {
                                      int index = entry.key;
                                      int value = entry.value;

                                      double offset = 0;
                                      if (isSwapping) {
                                        if (index == comparingIndex1) {
                                          offset =
                                              _swapAnimation.value *
                                              _getResponsiveSize(context, defaultSize: 34, minSize: 24);
                                        } else if (index == comparingIndex2) {
                                          offset =
                                              -_swapAnimation.value *
                                              _getResponsiveSize(context, defaultSize: 34, minSize: 24);
                                        }
                                      }

                                      // Calculate bar height ensuring it doesn't exceed available space
                                      double minBarHeight = _getResponsiveSize(context, defaultSize: 10, minSize: 6);
                                      double calculatedHeight =
                                          (value / maxNumber) *
                                          availableBarHeight;

                                      // Ensure the bar height fits within available space
                                      double barHeight = calculatedHeight.clamp(
                                        minBarHeight,
                                        availableBarHeight,
                                      );

                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: _getResponsiveSize(context, defaultSize: 3, minSize: 2),
                                        ),
                                        child: Transform.translate(
                                          offset: Offset(offset, 0),
                                          child: SizedBox(
                                            height: totalHeight,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                // Number label on top
                                                Text(
                                                  value.toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: _getResponsiveSize(context, defaultSize: 11, minSize: 9),
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                // Bar - Use Flexible to take remaining space
                                                Container(
                                                  width: _getResponsiveSize(context, defaultSize: 28, minSize: 20),
                                                  height: barHeight,
                                                  decoration: BoxDecoration(
                                                    color: getBarColor(index),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                    // Removed boxShadow to prevent overflow
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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
                    ),
                  ),
                ],
              ),
            ),
          ),

                  // Combined Status Display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSwapping
                          ? Colors.red.shade100
                          : comparingIndex1 >= 0
                              ? Colors.orange.shade100
                              : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSwapping
                            ? Colors.red.shade300
                            : comparingIndex1 >= 0
                                ? Colors.orange.shade300
                                : Colors.blue.shade300,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          currentStep,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (operationIndicator.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            operationIndicator,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSwapping
                                  ? Colors.red.shade800
                                  : comparingIndex1 >= 0
                                      ? Colors.orange.shade800
                                      : Colors.blue.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Information and Controls Area
          Flexible(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Code Display Section
                    const Text(
                      'Algorithm Code:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCodeDisplay(),

                    const SizedBox(height: 16),

                    // Controls Section
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          // Main Controls Card
                          Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Action Buttons Row
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _buildControlButton(
                                          onPressed: isSorting ? null : startBubbleSort,
                                          icon: Icons.play_arrow,
                                          label: 'Start Sort',
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 12),
                                        _buildControlButton(
                                          onPressed: isSorting ? stopSorting : null,
                                          icon: Icons.stop,
                                          label: 'Stop',
                                          color: Colors.red,
                                        ),
                                        const SizedBox(width: 12),
                                        _buildControlButton(
                                          onPressed: isSorting ? null : resetArray,
                                          icon: Icons.refresh,
                                          label: 'Reset',
                                          color: Colors.orange,
                                        ),
                                        const SizedBox(width: 12),
                                        _buildControlButton(
                                          onPressed: isSorting ? null : shuffleArray,
                                          icon: Icons.shuffle,
                                          label: 'Shuffle',
                                          color: Colors.purple,
                                        ),
                                        const SizedBox(width: 12),
                                        _buildControlButton(
                                          onPressed: isSorting
                                              ? () {
                                                  setState(() {
                                                    isPaused = !isPaused;
                                                  });
                                                }
                                              : null,
                                          icon: isPaused ? Icons.play_arrow : Icons.pause,
                                          label: isPaused ? 'Play' : 'Pause',
                                          color: Colors.blueGrey,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Sort Order Button - Centered
                                  Center(
                                    child: ElevatedButton.icon(
                                      onPressed: isSorting ? null : toggleSortOrder,
                                      icon: Icon(
                                        isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                                        size: 18,
                                      ),
                                      label: Text(isAscending ? 'Ascending' : 'Descending'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isAscending ? Colors.blue : Colors.indigo,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      ExpandableSpeedControl(
        speed: speed,
        onSpeedChanged: updateSpeed,
        isExpanded: isSpeedControlExpanded,
        onTap: () {
          setState(() {
            isSpeedControlExpanded = !isSpeedControlExpanded;
          });
        },
      ),
    ],
  ));
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
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildColorLegend(Color color, String label) {
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

  Widget _buildControlButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildStepItem(int stepNumber, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplexityItem(String label, String complexity, String description, Color color) {
    return Row(
      children: [
        Container(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        Container(
          width: 50,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            complexity,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '- $description',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}
