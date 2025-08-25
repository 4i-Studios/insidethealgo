import 'package:flutter/material.dart';
import 'dart:async';

class InsertionSortLogic {
  final VoidCallback onStateChanged;
  final TickerProvider vsync;

  InsertionSortLogic({
    required this.onStateChanged,
    required this.vsync,
  }) {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );
    _insertAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  // State variables
  final List<int> defaultNumbers = const [64, 34, 25, 12, 22, 11, 90, 88, 76, 50];
  List<int> numbers = [64, 34, 25, 12, 22, 11, 90, 88, 76, 50];
  List<int> originalNumbers = [64, 34, 25, 12, 22, 11, 90, 88, 76, 50];

  int currentI = -1;
  int currentJ = -1;
  int keyElement = -1;
  int keyIndex = -1;
  bool isInserting = false;
  bool isSorting = false;
  bool isSorted = false;

  String currentStep = "Ready to start sorting";
  String operationIndicator = "";
  int totalComparisons = 0;
  int totalInsertions = 0;

  bool isAscending = true;
  double speed = 1.0;
  bool shouldStop = false;
  bool isPaused = false;
  int highlightedLine = -1;
  bool isSpeedControlExpanded = false;

  late AnimationController _animationController;
  late Animation<double> _insertAnimation;

  final TextEditingController inputController = TextEditingController();
  String? inputError;

  // Getters
  Animation<double> get insertAnimation => _insertAnimation;

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
    keyElement = -1;
    keyIndex = -1;
    isInserting = false;
    isSorting = false;
    isSorted = false;
    shouldStop = false;
    highlightedLine = -1;
    currentStep = "Ready to start sorting";
    operationIndicator = "";
    totalComparisons = 0;
    totalInsertions = 0;
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
      startInsertionSort();
    }
    onStateChanged();
  }

  Future<void> _waitIfPaused() async {
    while (isPaused) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> startInsertionSort() async {
    if (isSorting) return;

    isSorting = true;
    isSorted = false;
    shouldStop = false;
    totalComparisons = 0;
    totalInsertions = 0;
    operationIndicator = "";
    highlightedLine = 0;
    onStateChanged();

    int n = numbers.length;
    String orderText = isAscending ? "ascending" : "descending";

    highlightedLine = 1;
    onStateChanged();
    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (500 / speed).round()));

    for (int i = 1; i < n; i++) {
      if (shouldStop) break;

      currentI = i;
      highlightedLine = 2;
      keyElement = numbers[i];
      keyIndex = i;
      currentStep = "Pass ${i}: Taking element ${numbers[i]} as key";
      operationIndicator = "🔑 Key element: ${numbers[i]} at position $i ($orderText order)";
      onStateChanged();

      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (800 / speed).round()));
      if (shouldStop) break;

      // Initialize j
      highlightedLine = 3;
      currentJ = i - 1;
      currentStep = "Comparing key ${numbers[i]} with sorted portion";
      operationIndicator = "🔍 Starting comparison from position ${i - 1}";
      onStateChanged();

      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (600 / speed).round()));
      if (shouldStop) break;

      // Find correct position and shift elements
      highlightedLine = 4;
      int j = i - 1;

      while (j >= 0) {
        if (shouldStop) break;

        await _waitIfPaused();
        currentJ = j;

        bool shouldShift = isAscending
            ? numbers[j] > keyElement
            : numbers[j] < keyElement;

        highlightedLine = 4;
        currentStep = "Comparing ${numbers[j]} with key ${keyElement}";
        operationIndicator = "🔍 Comparing: ${numbers[j]} vs ${keyElement} (key)";
        totalComparisons++;
        onStateChanged();

        await _waitIfPaused();
        await Future.delayed(Duration(milliseconds: (1000 / speed).round()));
        if (shouldStop) break;

        if (shouldShift) {
          highlightedLine = 5;
          currentStep = "Shifting ${numbers[j]} one position to the right";
          operationIndicator = "➡️ Shifting: ${numbers[j]} from position $j to ${j + 1}";

          // Perform the shift
          numbers[j + 1] = numbers[j];
          onStateChanged();

          await _waitIfPaused();
          await Future.delayed(Duration(milliseconds: (800 / speed).round()));
          if (shouldStop) break;

          j--;
          currentJ = j;
        } else {
          highlightedLine = 6;
          currentStep = "${numbers[j]} ${isAscending ? '≤' : '≥'} ${keyElement} - correct position found";
          operationIndicator = "✓ Position found - ${numbers[j]} ${isAscending ? '≤' : '≥'} ${keyElement}";
          onStateChanged();

          await _waitIfPaused();
          await Future.delayed(Duration(milliseconds: (600 / speed).round()));
          break;
        }
      }

      if (shouldStop) break;

      // Insert the key at correct position
      highlightedLine = 7;
      int insertPosition = j + 1;
      isInserting = true;
      currentStep = "Inserting key ${keyElement} at position ${insertPosition}";
      operationIndicator = "📍 Inserting: ${keyElement} at position ${insertPosition}";
      totalInsertions++;
      onStateChanged();

      _animationController.duration = Duration(milliseconds: (800 / speed).round());
      await _animationController.forward();
      if (shouldStop) return;

      numbers[insertPosition] = keyElement;
      onStateChanged();

      _animationController.reset();
      isInserting = false;
      onStateChanged();

      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (300 / speed).round()));

      if (shouldStop) break;

      currentStep = "Pass ${i} completed - element ${keyElement} is in correct position";
      operationIndicator = "✅ Pass ${i} complete! Element ${keyElement} is sorted";
      keyElement = -1;
      keyIndex = -1;
      currentJ = -1;
      onStateChanged();

      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (1000 / speed).round()));
    }

    _finishSorting();
  }

  void _finishSorting() {
    currentI = -1;
    currentJ = -1;
    keyElement = -1;
    keyIndex = -1;
    isSorting = false;
    highlightedLine = -1;

    if (shouldStop) {
      currentStep = "Sorting stopped by user";
      operationIndicator = "⏹️ Sorting was interrupted";
    } else {
      isSorted = true;
      highlightedLine = 8;
      currentStep = "";
      String orderText = isAscending ? "ascending" : "descending";
      operationIndicator = "🎉 Sorting Complete! All elements are in $orderText order";
    }
    onStateChanged();
  }

  Color getBarColor(int index) {
    if (isSorted) return Colors.green;
    if (isInserting && index == keyIndex) {
      return Colors.red;
    }
    if (index == keyIndex) {
      return Colors.orange;
    }
    if (index == currentJ) {
      return Colors.blue;
    }
    if (currentI >= 0 && index < currentI) {
      return Colors.purple.shade300;
    }
    return Colors.blue;
  }
}