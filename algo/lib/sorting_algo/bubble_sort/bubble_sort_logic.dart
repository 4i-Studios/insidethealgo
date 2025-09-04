import 'package:flutter/material.dart';
import 'dart:async';
import '../insertion_sort/insertion_sort_logic.dart';

class BubbleSortLogic {
  final VoidCallback onStateChanged;
  final TickerProvider vsync;

  BubbleSortLogic({
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

  // Opt-in: use new bubble animation system. Default true
  bool useBubbleAnimation = true;

  bool get useBubbleAnimationEnabled => useBubbleAnimation;

  late AnimationController _animationController;
  late Animation<double> _swapAnimation;

  int _lastSwapTick = 0;
  int get swapTick => _lastSwapTick;

  final TextEditingController inputController = TextEditingController();
  String? inputError;

  // Getters
  Animation<double> get swapAnimation => _swapAnimation;
  int get swapFrom => comparingIndex1;
  int get swapTo => comparingIndex2;
  double get swapProgress => swapAnimation.value;

  void dispose() {
    _animationController.dispose();
    inputController.dispose();
  }

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
  }

  void stopSorting() {
    shouldStop = true;
    isSorting = false;
    highlightedLine = -1;
    currentStep = "Sorting stopped by user";
    operationIndicator = "⏹️ Sorting process halted";
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
    onStateChanged();

    int n = numbers.length;
    String orderText = isAscending ? "ascending" : "descending";

    highlightedLine = 1;
    onStateChanged();
    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (500 / speed).round()));

    for (int i = 0; i < n - 1; i++) {
      if (shouldStop) break;

      currentI = i;
      highlightedLine = 1;
      currentStep = "Pass ${i + 1}: Finding the ${isAscending ? 'largest' : 'smallest'} element in remaining array";
      operationIndicator = "Starting pass ${i + 1} of ${n - 1} ($orderText order)";
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
        highlightedLine = 2;
        onStateChanged();

        await _waitIfPaused();
        await Future.delayed(Duration(milliseconds: (400 / speed).round()));

        highlightedLine = 3;
        comparingIndex1 = j;
        comparingIndex2 = j + 1;
        currentStep = "Comparing ${numbers[j].value} and ${numbers[j + 1].value}";
        operationIndicator = "🔍 Comparing: ${numbers[j].value} vs ${numbers[j + 1].value}";
        totalComparisons++;
        onStateChanged();

        await _waitIfPaused();
        await Future.delayed(Duration(milliseconds: (1000 / speed).round()));
        if (shouldStop) break;

        bool shouldSwap = isAscending
            ? numbers[j].value > numbers[j + 1].value
            : numbers[j].value < numbers[j + 1].value;

        if (shouldSwap) {
          await _performSwap(j);
        } else {
          currentStep = "No swap needed - ${isAscending ? '${numbers[j].value} ≤ ${numbers[j + 1].value}' : '${numbers[j].value} ≥ ${numbers[j + 1].value}'}";
          operationIndicator = "✓ No swap: ${isAscending ? '${numbers[j].value} ≤ ${numbers[j + 1].value}' : '${numbers[j].value} ≥ ${numbers[j + 1].value}'} (already in order)";
          onStateChanged();

          await _waitIfPaused();
          await Future.delayed(Duration(milliseconds: (800 / speed).round()));
        }
      }

      if (shouldStop) break;

      highlightedLine = 5;
      currentStep = "Pass ${i + 1} completed - ${numbers[n - i - 1].value} is in correct position";
      operationIndicator = "✅ Pass ${i + 1} complete! Element ${numbers[n - i - 1].value} is sorted";
      onStateChanged();

      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (1000 / speed).round()));
    }

    _finishSorting();
  }

  Future<void> _performSwap(int j) async {
    await _waitIfPaused();

    highlightedLine = 4;
    isSwapping = true;
    currentStep = "Swapping ${numbers[j].value} and ${numbers[j + 1].value}";
    operationIndicator = "🔄 Swapping: ${numbers[j].value} ↔ ${numbers[j + 1].value} (${isAscending ? '${numbers[j].value} > ${numbers[j + 1].value}' : '${numbers[j].value} < ${numbers[j + 1].value}'})";
    totalSwaps++;
    onStateChanged();

    _animationController.duration = Duration(milliseconds: (800 / speed).round());
    await _animationController.forward();
    if (shouldStop) return;

    // swap SortItem objects
    final tmp = numbers[j];
    numbers[j] = numbers[j + 1];
    numbers[j + 1] = tmp;

    // Signal a recent swap to the UI widgets (increment tick)
    _lastSwapTick++;

    onStateChanged();

    _animationController.reset();
    isSwapping = false;
    onStateChanged();

    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (300 / speed).round()));
  }

  void _finishSorting() {
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