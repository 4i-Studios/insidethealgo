import 'package:flutter/material.dart';
import 'dart:async';

class SelectionSortLogic {
  final VoidCallback onStateChanged;
  final TickerProvider vsync;

  SelectionSortLogic({
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
  }

  // State variables
  final List<int> defaultNumbers = const [64, 34, 25, 12, 22, 11, 90, 88, 76, 50];
  List<int> numbers = [64, 34, 25, 12, 22, 11, 90, 88, 76, 50];
  List<int> originalNumbers = [64, 34, 25, 12, 22, 11, 90, 88, 76, 50];

  int currentI = -1;
  int currentJ = -1;
  int minIndex = -1;
  int comparingIndex = -1;
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

    numbers = List.from(nums);
    originalNumbers = List.from(nums);
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
    numbers = List.from(defaultNumbers);
    originalNumbers = List.from(defaultNumbers);
    _resetState();
    inputError = null;
    inputController.clear();
    onStateChanged();
  }

  void _resetState() {
    currentI = -1;
    currentJ = -1;
    minIndex = -1;
    comparingIndex = -1;
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
      startSelectionSort();
    }
    onStateChanged();
  }

  Future<void> _waitIfPaused() async {
    while (isPaused) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> startSelectionSort() async {
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
      currentStep = "Pass ${i + 1}: Finding ${isAscending ? 'minimum' : 'maximum'} element in remaining array";
      operationIndicator = "Starting pass ${i + 1} of ${n - 1} ($orderText order)";
      onStateChanged();

      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (500 / speed).round()));
      if (shouldStop) break;

      // Initialize minIndex
      highlightedLine = 2;
      minIndex = i;
      currentStep = "Setting position $i as current ${isAscending ? 'minimum' : 'maximum'}: ${numbers[i]}";
      operationIndicator = "🎯 Current ${isAscending ? 'min' : 'max'}: ${numbers[i]} at position $i";
      onStateChanged();

      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (800 / speed).round()));
      if (shouldStop) break;

      // Find minimum/maximum in remaining array
      highlightedLine = 3;
      onStateChanged();
      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (300 / speed).round()));

      for (int j = i + 1; j < n; j++) {
        if (shouldStop) break;

        await _waitIfPaused();
        currentJ = j;
        comparingIndex = j;
        highlightedLine = 4;
        currentStep = "Comparing ${numbers[j]} with current ${isAscending ? 'minimum' : 'maximum'} ${numbers[minIndex]}";
        operationIndicator = "🔍 Comparing: ${numbers[j]} vs ${numbers[minIndex]} (current ${isAscending ? 'min' : 'max'})";
        totalComparisons++;
        onStateChanged();

        await _waitIfPaused();
        await Future.delayed(Duration(milliseconds: (1000 / speed).round()));
        if (shouldStop) break;

        bool shouldUpdate = isAscending
            ? numbers[j] < numbers[minIndex]
            : numbers[j] > numbers[minIndex];

        if (shouldUpdate) {
          highlightedLine = 5;
          minIndex = j;
          currentStep = "New ${isAscending ? 'minimum' : 'maximum'} found: ${numbers[j]} at position $j";
          operationIndicator = "✨ New ${isAscending ? 'min' : 'max'}: ${numbers[j]} at position $j";
          onStateChanged();

          await _waitIfPaused();
          await Future.delayed(Duration(milliseconds: (800 / speed).round()));
        } else {
          currentStep = "${numbers[j]} is ${isAscending ? 'not smaller than' : 'not larger than'} ${numbers[minIndex]}";
          operationIndicator = "✓ ${numbers[j]} ${isAscending ? '≥' : '≤'} ${numbers[minIndex]} - no update needed";
          onStateChanged();

          await _waitIfPaused();
          await Future.delayed(Duration(milliseconds: (600 / speed).round()));
        }
      }

      if (shouldStop) break;

      // Check if swap is needed
      highlightedLine = 7;
      onStateChanged();
      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (400 / speed).round()));

      if (minIndex != i) {
        await _performSwap(i, minIndex);
      } else {
        highlightedLine = 8;
        currentStep = "Element ${numbers[i]} is already in correct position";
        operationIndicator = "✓ No swap needed - ${numbers[i]} is already in position $i";
        onStateChanged();

        await _waitIfPaused();
        await Future.delayed(Duration(milliseconds: (800 / speed).round()));
      }

      if (shouldStop) break;

      currentStep = "Pass ${i + 1} completed - ${numbers[i]} is in correct position";
      operationIndicator = "✅ Pass ${i + 1} complete! Element ${numbers[i]} is sorted";
      minIndex = -1;
      comparingIndex = -1;
      onStateChanged();

      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (1000 / speed).round()));
    }

    _finishSorting();
  }

  Future<void> _performSwap(int i, int minIdx) async {
    await _waitIfPaused();

    highlightedLine = 8;
    isSwapping = true;
    currentStep = "Swapping ${numbers[i]} at position $i with ${numbers[minIdx]} at position $minIdx";
    operationIndicator = "🔄 Swapping: ${numbers[i]} ↔ ${numbers[minIdx]} (positions $i ↔ $minIdx)";
    totalSwaps++;
    onStateChanged();

    _animationController.duration = Duration(milliseconds: (800 / speed).round());
    await _animationController.forward();
    if (shouldStop) return;

    int temp = numbers[i];
    numbers[i] = numbers[minIdx];
    numbers[minIdx] = temp;
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
    minIndex = -1;
    comparingIndex = -1;
    isSorting = false;
    highlightedLine = -1;

    if (shouldStop) {
      currentStep = "Sorting stopped by user";
      operationIndicator = "⏹️ Sorting was interrupted";
    } else {
      isSorted = true;
      highlightedLine = 9;
      currentStep = "";
      String orderText = isAscending ? "ascending" : "descending";
      operationIndicator = "🎉 Sorting Complete! All elements are in $orderText order";
    }
    onStateChanged();
  }

  Color getBarColor(int index) {
    if (isSorted) return Colors.green;
    if (isSwapping && (index == currentI || index == minIndex)) {
      return Colors.red;
    }
    if (index == minIndex) {
      return Colors.purple;
    }
    if (index == comparingIndex) {
      return Colors.orange;
    }
    if (currentI >= 0 && index < currentI) {
      return Colors.green.shade300;
    }
    return Colors.blue;
  }
}