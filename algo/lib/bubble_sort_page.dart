import 'package:flutter/material.dart';
import 'dart:async';

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

  late AnimationController _animationController;
  late Animation<double> _swapAnimation;

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
      currentStep = isAscending
          ? "Array shuffled - Ready to start sorting (Ascending)"
          : "Array shuffled - Ready to start sorting (Descending)";
      operationIndicator = "";
      totalComparisons = 0;
      totalSwaps = 0;
    });
  }

  Future<void> startBubbleSort() async {
    if (isSorting) return;

    setState(() {
      isSorting = true;
      isSorted = false;
      shouldStop = false;
      totalComparisons = 0;
      totalSwaps = 0;
      operationIndicator = "";
    });

    int n = numbers.length;
    String orderText = isAscending ? "ascending" : "descending";

    for (int i = 0; i < n - 1; i++) {
      if (shouldStop) break;

      setState(() {
        currentI = i;
        currentStep =
            "Pass ${i + 1}: Finding the ${isAscending ? 'largest' : 'smallest'} element in remaining array";
        operationIndicator =
            "Starting pass ${i + 1} of ${n - 1} ($orderText order)";
      });

      await Future.delayed(Duration(milliseconds: (500 / speed).round()));
      if (shouldStop) break;

      for (int j = 0; j < n - i - 1; j++) {
        if (shouldStop) break;

        setState(() {
          currentJ = j;
          comparingIndex1 = j;
          comparingIndex2 = j + 1;
          currentStep = "Comparing ${numbers[j]} and ${numbers[j + 1]}";
          operationIndicator =
              "🔍 Comparing: ${numbers[j]} vs ${numbers[j + 1]}";
          totalComparisons++;
        });

        await Future.delayed(Duration(milliseconds: (1000 / speed).round()));
        if (shouldStop) break;

        // Check condition based on sorting order
        bool shouldSwap = isAscending
            ? numbers[j] > numbers[j + 1]
            : numbers[j] < numbers[j + 1];

        if (shouldSwap) {
          setState(() {
            isSwapping = true;
            currentStep = "Swapping ${numbers[j]} and ${numbers[j + 1]}";
            operationIndicator =
                "🔄 Swapping: ${numbers[j]} ↔ ${numbers[j + 1]} (${isAscending ? '${numbers[j]} > ${numbers[j + 1]}' : '${numbers[j]} < ${numbers[j + 1]}'})";
            totalSwaps++;
          });

          _animationController.forward();
          await Future.delayed(Duration(milliseconds: (800 / speed).round()));
          if (shouldStop) break;

          // Perform the swap
          int temp = numbers[j];
          numbers[j] = numbers[j + 1];
          numbers[j + 1] = temp;

          _animationController.reset();
          setState(() {
            isSwapping = false;
          });

          await Future.delayed(Duration(milliseconds: (300 / speed).round()));
        } else {
          setState(() {
            currentStep =
                "No swap needed - ${isAscending ? '${numbers[j]} ≤ ${numbers[j + 1]}' : '${numbers[j]} ≥ ${numbers[j + 1]}'}";
            operationIndicator =
                "✓ No swap: ${isAscending ? '${numbers[j]} ≤ ${numbers[j + 1]}' : '${numbers[j]} ≥ ${numbers[j + 1]}'} (already in order)";
          });
          await Future.delayed(Duration(milliseconds: (800 / speed).round()));
        }
      }

      if (shouldStop) break;

      setState(() {
        currentStep =
            "Pass ${i + 1} completed - ${numbers[n - i - 1]} is in correct position";
        operationIndicator =
            "✅ Pass ${i + 1} complete! Element ${numbers[n - i - 1]} is sorted";
      });
      await Future.delayed(Duration(milliseconds: (1000 / speed).round()));
    }

    setState(() {
      currentI = -1;
      currentJ = -1;
      comparingIndex1 = -1;
      comparingIndex2 = -1;
      isSorting = false;

      if (shouldStop) {
        currentStep = "Sorting stopped by user";
        operationIndicator = "⏹️ Sorting was interrupted";
      } else {
        isSorted = true;
        currentStep =
            "Sorting completed! Array is now sorted in $orderText order.";
        operationIndicator =
            "🎉 Sorting Complete! All elements are in $orderText order";
      }
    });
  }

  Color getBarColor(int index) {
    if (isSorted) return Colors.green;
    if (isSwapping && (index == comparingIndex1 || index == comparingIndex2)) {
      return Colors.red;
    }
    if (index == comparingIndex1 || index == comparingIndex2) {
      return Colors.orange;
    }
    if (currentI >= 0 && index >= numbers.length - currentI - 1) {
      return Colors.green.shade300;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bubble Sort Algorithm Demo'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Animation Area (Top portion)
          Expanded(
            flex: 5,
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
                  // Current Step Display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade300),
                    ),
                    child: Text(
                      currentStep,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Operation Indicator Box
                  if (operationIndicator.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSwapping
                            ? Colors.red.shade100
                            : comparingIndex1 >= 0
                            ? Colors.orange.shade100
                            : Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSwapping
                              ? Colors.red.shade300
                              : comparingIndex1 >= 0
                              ? Colors.orange.shade300
                              : Colors.green.shade300,
                        ),
                      ),
                      child: Text(
                        operationIndicator,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSwapping
                              ? Colors.red.shade800
                              : comparingIndex1 >= 0
                              ? Colors.orange.shade800
                              : Colors.green.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Loop Status
                  if (isSorting) ...[
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
                                              34; // Bar width + padding
                                        } else if (index == comparingIndex2) {
                                          offset =
                                              -_swapAnimation.value *
                                              34; // Bar width + padding
                                        }
                                      }

                                      // Calculate bar height ensuring it doesn't exceed available space
                                      double minBarHeight = 10.0;
                                      double calculatedHeight =
                                          (value / maxNumber) *
                                          availableBarHeight;

                                      // Ensure the bar height fits within available space
                                      double barHeight = calculatedHeight.clamp(
                                        minBarHeight,
                                        availableBarHeight,
                                      );

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 3,
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
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                // Bar - Use Flexible to take remaining space
                                                Flexible(
                                                  child: Container(
                                                    width: 28,
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

          // Information and Controls Area
          Flexible(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Control Buttons
                    Column(
                      children: [
                        // First row - Main control buttons
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: isSorting ? null : startBubbleSort,
                                icon: const Icon(Icons.play_arrow, size: 18),
                                label: const Text('Start Sort'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: isSorting ? stopSorting : null,
                                icon: const Icon(Icons.stop, size: 18),
                                label: const Text('Stop'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: isSorting ? null : resetArray,
                                icon: const Icon(Icons.refresh, size: 18),
                                label: const Text('Reset'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: isSorting ? null : shuffleArray,
                                icon: const Icon(Icons.shuffle, size: 18),
                                label: const Text('Shuffle'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Second row - Sort order toggle
                        ElevatedButton.icon(
                          onPressed: isSorting ? null : toggleSortOrder,
                          icon: Icon(
                            isAscending
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 18,
                          ),
                          label: Text(isAscending ? 'Ascending' : 'Descending'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isAscending
                                ? Colors.blue
                                : Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Speed control
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Animation Speed: ${speed.toStringAsFixed(1)}x',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Slider(
                                value: speed,
                                min: 0.5,
                                max: 3.0,
                                divisions: 5,
                                onChanged: isSorting ? null : updateSpeed,
                                activeColor: Colors.blue,
                                inactiveColor: Colors.grey.shade300,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Slow',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    'Fast',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Algorithm Information
                    const Text(
                      'Bubble Sort Algorithm',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'How Bubble Sort Works:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      '1. Compare adjacent elements in the array\n'
                      '2. If elements are in wrong order (based on ascending/descending), swap them\n'
                      '3. Continue this process for the entire array\n'
                      '4. After each pass, one element "bubbles" to its correct position\n'
                      '5. Repeat until no more swaps are needed\n\n',

                      style: TextStyle(fontSize: 13, height: 1.5),
                    ),

                    // const SizedBox(height: 4),
                    const Text(
                      'Time Complexity:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      '• Best Case: O(n) - when array is already sorted\n'
                      '• Average Case: O(n²) - random order\n'
                      '• Worst Case: O(n²) - when array is reverse sorted\n'
                      '• Space Complexity: O(1) - only uses constant extra space',
                      style: TextStyle(fontSize: 13, height: 1.5),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Color Legend:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _buildColorLegend(Colors.blue, 'Unsorted'),
                        _buildColorLegend(Colors.orange, 'Comparing'),
                        _buildColorLegend(Colors.red, 'Swapping'),
                        _buildColorLegend(Colors.green, 'Sorted'),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
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
}
