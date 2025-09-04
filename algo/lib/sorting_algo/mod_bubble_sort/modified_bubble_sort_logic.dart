import 'package:flutter/material.dart';
import 'dart:async';
import '../insertion_sort/insertion_sort_logic.dart';

class ModifiedBubbleSortLogic {
  final VoidCallback onStateChanged;
  final TickerProvider vsync;

  ModifiedBubbleSortLogic({
    required this.onStateChanged,
    required this.vsync,
  }) {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );
    _swapAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Notify UI during animation frames so AnimatedBubble can read swapProgress
    _animationController.addListener(() {
      onStateChanged();
    });

    // initialize with default items
    numbers = _makeItemsFromInts(defaultNumbers);
    originalNumbers = List.from(numbers);
    _resetState();
  }

  // State variables
  final List<int> defaultNumbers = const [64, 34, 25, 12, 22, 11, 90, 88, 76, 50];
  late List<SortItem> numbers;
  late List<SortItem> originalNumbers;

  int currentI = -1;
  int currentJ = -1;
  int comparingIndex1 = -1;
  int comparingIndex2 = -1;
  bool isSwapping = false;
  bool isSorting = false;
  bool isSorted = false;
  bool currentSwapped = false;

  // New swap state fields for AnimatedBubble component
  int swapFrom = -1;
  int swapTo = -1;
  int swapTick = 0;
  double get swapProgress => _animationController.value;

  String currentStep = "Ready to start sorting";
  String operationIndicator = "";
  int totalComparisons = 0;
  int totalSwaps = 0;

  bool isAscending = true;
  double speed = 1.0;
  bool shouldStop = false;
  bool isPaused = false;
  int highlightedLine = -1;
  bool isSpeedControlExpanded = false;

  late AnimationController _animationController;
  late Animation<double> _swapAnimation;

  final TextEditingController inputController = TextEditingController();
  String? inputError;

  // Getters
  Animation<double> get swapAnimation => _swapAnimation;

  void dispose() {
    _animationController.dispose();
    inputController.dispose();
  }

  // Helper to create SortItem list
  List<SortItem> _makeItemsFromInts(List<int> list) {
    int id = 0;
    return list.map((v) => SortItem(id++, v)).toList();
  }

  void setArrayFromInput(BuildContext context) {
    final input = inputController.text.trim();
    if (input.isEmpty) {
      _showSnackBar(context, 'Input required');
      return;
    }

    final parts = input.split(',').map((e) => e.trim()).toList();
    if (parts.length < 2 || parts.length > 10) {
      _showSnackBar(context, 'Enter 2-10 numbers');
      return;
    }

    final nums = <int>[];
    for (final part in parts) {
      final n = int.tryParse(part);
      if (n == null) {
        _showSnackBar(context, 'Only integers allowed');
        return;
      }
      nums.add(n);
    }

    numbers = _makeItemsFromInts(nums);
    originalNumbers = _makeItemsFromInts(nums);
    _resetState();
    onStateChanged();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void resetArray() {
    numbers = _makeItemsFromInts(defaultNumbers);
    originalNumbers = _makeItemsFromInts(defaultNumbers);
    _resetState();
    inputError = null;
    inputController.clear();
    onStateChanged();
  }

  void _resetState() {
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
    currentSwapped = false;
    swapFrom = -1;
    swapTo = -1;
  }

  void stopSorting() {
    shouldStop = true;
    isSorting = false;
    highlightedLine = -1;
    currentStep = "Sorting stopped by user";
    operationIndicator = "⏹️ Sorting process halted";
    currentSwapped = false;
    onStateChanged();
  }

  void toggleSortOrder() {
    if (!isSorting) {
      isAscending = !isAscending;
      currentStep = isAscending
          ? "Ready to start sorting (Ascending)"
          : "Ready to start sorting (Descending)";
      onStateChanged();
    }
  }

  void updateSpeed(double newSpeed) {
    speed = newSpeed;
    onStateChanged();
  }

  void shuffleArray() {
    numbers.shuffle();
    originalNumbers = List.from(numbers);
    _resetState();
    currentStep = isAscending
        ? "Array shuffled - Ready to start sorting (Ascending)"
        : "Array shuffled - Ready to start sorting (Descending)";
    onStateChanged();
  }

  void toggleSpeedControl() {
    isSpeedControlExpanded = !isSpeedControlExpanded;
    onStateChanged();
  }

  void onPlayPausePressed() {
    if (isSorting) {
      isPaused = !isPaused;
    } else {
      startBubbleSort();
    }
    onStateChanged();
  }

  Future<void> _waitIfPaused() async {
    while (isPaused) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> startBubbleSort() async {
    if (isSorting) return;

    isSorting = true;
    isSorted = false;
    shouldStop = false;
    totalComparisons = 0;
    totalSwaps = 0;
    operationIndicator = "";
    highlightedLine = 0;
    currentSwapped = false;
    onStateChanged();

    int n = numbers.length;
    String orderText = isAscending ? "ascending" : "descending";

    highlightedLine = 1;
    onStateChanged();
    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (500 / speed).round()));

    for (int i = 0; i < n - 1; i++) {
      if (shouldStop) break;

      bool swapped = false;
      currentI = i;
      highlightedLine = 1;
      currentStep = "Pass ${i + 1}: Finding the ${isAscending ? 'largest' : 'smallest'} element in remaining array";
      operationIndicator = "Starting pass ${i + 1} of ${n - 1} ($orderText order)";
      currentSwapped = false;
      onStateChanged();

      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (500 / speed).round()));
      if (shouldStop) break;

      highlightedLine = 2;
      onStateChanged();
      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (300 / speed).round()));

      for (int j = 0; j < n - i - 1; j++) {
        if (shouldStop) break;

        await _waitIfPaused();
        currentJ = j;
        highlightedLine = 3;
        onStateChanged();

        await _waitIfPaused();
        await Future.delayed(Duration(milliseconds: (400 / speed).round()));

        highlightedLine = 4;
        comparingIndex1 = j;
        comparingIndex2 = j + 1;
        currentStep = "Comparing ${numbers[j].value} and ${numbers[j + 1].value}";
        operationIndicator = "🔍 Comparing: ${numbers[j].value} vs ${numbers[j + 1].value}";
        totalComparisons++;
        onStateChanged();

        await _waitIfPaused();
        await Future.delayed(Duration(milliseconds: (700 / speed).round()));
        if (shouldStop) break;

        bool shouldSwap = isAscending
            ? numbers[j].value > numbers[j + 1].value
            : numbers[j].value < numbers[j + 1].value;

        if (shouldSwap) {
          await _performSwap(j);
          swapped = true;
        } else {
          currentStep = "No swap needed - ${isAscending ? '${numbers[j].value} ≤ ${numbers[j + 1].value}' : '${numbers[j].value} ≥ ${numbers[j + 1].value}'}";
          operationIndicator = "✓ No swap: ${isAscending ? '${numbers[j].value} ≤ ${numbers[j + 1].value}' : '${numbers[j].value} ≥ ${numbers[j + 1].value}'} (already in order)";
          onStateChanged();

          await _waitIfPaused();
          await Future.delayed(Duration(milliseconds: (400 / speed).round()));
        }
      }

      if (shouldStop) break;

      // Check if no swaps occurred - early termination optimization
      highlightedLine = 9;
      onStateChanged();
      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (400 / speed).round()));

      highlightedLine = 10;
      onStateChanged();
      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (600 / speed).round()));

      if (!swapped) {
        currentStep = "No swaps in this pass - array is already sorted!";
        operationIndicator = "🎉 Early termination: Array is sorted! (Optimization working)";
        onStateChanged();
        await _waitIfPaused();
        await Future.delayed(Duration(milliseconds: (1200 / speed).round()));
        break;
      }
    }

    _finishSorting();
  }

  Future<void> _performSwap(int j) async {
    await _waitIfPaused();

    highlightedLine = 5;

    // set up swap endpoints and notify UI
    swapFrom = j;
    swapTo = j + 1;
    swapTick++; // signal a new swap cycle to the AnimatedBubble
    isSwapping = true;
    currentStep = "Swapping ${numbers[j].value} and ${numbers[j + 1].value}";
    operationIndicator = "🔄 Swapping: ${numbers[j].value} ↔ ${numbers[j + 1].value} (${isAscending ? '${numbers[j].value} > ${numbers[j + 1].value}' : '${numbers[j].value} < ${numbers[j + 1].value}'})";
    totalSwaps++;
    currentSwapped = true;
    onStateChanged();

    _animationController.duration = Duration(milliseconds: (800 / speed).round());
    await _animationController.forward();
    if (shouldStop) return;

    // swap the underlying array (visual will follow)
    final tmp = numbers[j];
    numbers[j] = numbers[j + 1];
    numbers[j + 1] = tmp;
    onStateChanged();

    // reset animation controller and swap state
    _animationController.reset();
    isSwapping = false;
    swapFrom = -1;
    swapTo = -1;

    highlightedLine = 6;
    onStateChanged();
    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (500 / speed).round()));

    highlightedLine = 7;
    onStateChanged();
    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (400 / speed).round()));

    highlightedLine = 8;
    onStateChanged();
    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (800 / speed).round()));
  }

  void _finishSorting() {
    currentI = -1;
    currentJ = -1;
    comparingIndex1 = -1;
    comparingIndex2 = -1;
    isSorting = false;
    highlightedLine = -1;
    currentSwapped = false;

    if (shouldStop) {
      currentStep = "Sorting stopped by user";
      operationIndicator = "⏹️ Sorting was interrupted";
    } else {
      isSorted = true;
      highlightedLine = 11;
      currentStep = "";
      String orderText = isAscending ? "ascending" : "descending";
      operationIndicator = "🎉 Sorting Complete! All elements are in $orderText order";
    }
    onStateChanged();
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
}