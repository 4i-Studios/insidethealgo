import 'package:flutter/material.dart';
import 'dart:async';

class SortItem {
  final int id;
  int value;
  SortItem(this.id, this.value);
}

class CountingSortLogic {
  final VoidCallback onStateChanged;
  final TickerProvider vsync;

  CountingSortLogic({
    required this.onStateChanged,
    required this.vsync,
  }) {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );
    _countAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    // Initialize arrays with default items
    numbers = _makeItemsFromInts(_defaultNumbers);
    originalNumbers = List.from(numbers);
    _resetState();
  }

  // State variables
  final List<int> _defaultNumbers = const [64, 34, 25, 12, 22, 11, 90];

  late List<SortItem> numbers;
  late List<SortItem> originalNumbers;

  // Counting sort specific variables
  int minValue = 0;
  int maxValue = 0;
  List<int> countArray = [];
  List<int> cumulativeArray = [];
  int currentPhase = 0; // 0: init, 1: finding range, 2: counting, 3: cumulative, 4: placing, 5: done
  int currentIndex = -1;
  int currentValue = -1;
  int currentCount = -1;
  int placingIndex = -1;

  bool isSorting = false;
  bool isSorted = false;

  String currentStep = "Ready to start sorting";
  String operationIndicator = "";
  int totalComparisons = 0;
  int totalPlacements = 0;

  double speed = 1.0;
  bool shouldStop = false;
  bool isPaused = false;
  int highlightedLine = -1;
  bool isSpeedControlExpanded = false;

  late AnimationController _animationController;
  late Animation<double> _countAnimation;

  final TextEditingController inputController = TextEditingController();
  String? inputError;

  // Getters
  Animation<double> get countAnimation => _countAnimation;

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
    if (parts.length < 2 || parts.length > 15) {
      _showSnackBar(context, 'Enter 2-15 numbers');
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
    numbers = _makeItemsFromInts(_defaultNumbers);
    originalNumbers = _makeItemsFromInts(_defaultNumbers);
    _resetState();
    inputError = null;
    inputController.clear();
    onStateChanged();
  }

  void _resetState() {
    currentPhase = 0;
    currentIndex = -1;
    currentValue = -1;
    currentCount = -1;
    placingIndex = -1;
    minValue = 0;
    maxValue = 0;
    countArray = [];
    cumulativeArray = [];
    isSorting = false;
    isSorted = false;
    shouldStop = false;
    highlightedLine = -1;
    currentStep = "Ready to start sorting";
    operationIndicator = "";
    totalComparisons = 0;
    totalPlacements = 0;
  }

  void stopSorting() {
    shouldStop = true;
    isSorting = false;
    highlightedLine = -1;
    currentStep = "Sorting stopped by user";
    operationIndicator = "⏹️ Sorting process halted";
    onStateChanged();
  }

  void updateSpeed(double newSpeed) {
    speed = newSpeed;
    onStateChanged();
  }

  void shuffleArray() {
    numbers.shuffle();
    originalNumbers = List.from(numbers);
    _resetState();
    currentStep = "Array shuffled - Ready to start sorting";
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
      startCountingSort();
    }
    onStateChanged();
  }

  Future<void> _waitIfPaused() async {
    while (isPaused) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> startCountingSort() async {
    if (isSorting) return;
    if (numbers.isEmpty) return;

    isSorting = true;
    isSorted = false;
    shouldStop = false;
    totalComparisons = 0;
    totalPlacements = 0;
    operationIndicator = "";
    highlightedLine = 0;
    onStateChanged();

    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (500 / speed).round()));

    // Phase 1: Find range (min and max)
    currentPhase = 1;
    highlightedLine = 1;
    currentStep = "Phase 1: Finding the range of values...";
    operationIndicator = "🔍 Scanning array for min and max values";
    onStateChanged();

    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (800 / speed).round()));
    if (shouldStop) return;

    minValue = numbers[0].value;
    maxValue = numbers[0].value;

    for (int i = 0; i < numbers.length; i++) {
      if (shouldStop) return;
      await _waitIfPaused();

      currentIndex = i;
      int val = numbers[i].value;

      if (val < minValue) minValue = val;
      if (val > maxValue) maxValue = val;

      currentStep = "Checking element $val (min: $minValue, max: $maxValue)";
      operationIndicator = "📊 Range: [$minValue, $maxValue]";
      onStateChanged();

      await Future.delayed(Duration(milliseconds: (400 / speed).round()));
    }

    if (shouldStop) return;

    currentIndex = -1;
    highlightedLine = 2;
    currentStep = "Range found: $minValue to $maxValue";
    operationIndicator = "✓ Range: [$minValue, $maxValue], Size: ${maxValue - minValue + 1}";
    onStateChanged();

    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (800 / speed).round()));
    if (shouldStop) return;

    // Phase 2: Initialize count array
    currentPhase = 2;
    int range = maxValue - minValue + 1;
    countArray = List.filled(range, 0);
    cumulativeArray = List.filled(range, 0);

    highlightedLine = 3;
    currentStep = "Phase 2: Initializing count array of size $range";
    operationIndicator = "🔢 Count array created: ${range} positions";
    onStateChanged();

    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (800 / speed).round()));
    if (shouldStop) return;

    // Phase 3: Count occurrences
    currentPhase = 3;
    highlightedLine = 4;
    currentStep = "Phase 3: Counting occurrences of each value...";
    operationIndicator = "📊 Counting frequency of each element";
    onStateChanged();

    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (600 / speed).round()));

    for (int i = 0; i < numbers.length; i++) {
      if (shouldStop) return;
      await _waitIfPaused();

      currentIndex = i;
      currentValue = numbers[i].value;
      int countIndex = currentValue - minValue;

      _animationController.duration = Duration(milliseconds: (600 / speed).round());
      await _animationController.forward();
      if (shouldStop) return;

      countArray[countIndex]++;
      currentCount = countArray[countIndex];

      currentStep = "Element $currentValue counted (count: $currentCount)";
      operationIndicator = "📊 Count[$currentValue] = $currentCount";
      onStateChanged();

      _animationController.reset();

      await Future.delayed(Duration(milliseconds: (500 / speed).round()));
    }

    if (shouldStop) return;

    currentIndex = -1;
    currentValue = -1;
    currentStep = "All elements counted successfully";
    operationIndicator = "✓ Count array completed";
    onStateChanged();

    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (800 / speed).round()));
    if (shouldStop) return;

    // Phase 4: Calculate cumulative counts
    currentPhase = 4;
    highlightedLine = 5;
    currentStep = "Phase 4: Calculating cumulative counts...";
    operationIndicator = "🔢 Building position information";
    onStateChanged();

    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (600 / speed).round()));

    cumulativeArray[0] = countArray[0];

    for (int i = 1; i < countArray.length; i++) {
      if (shouldStop) return;
      await _waitIfPaused();

      currentIndex = i;
      currentValue = minValue + i;

      _animationController.duration = Duration(milliseconds: (500 / speed).round());
      await _animationController.forward();
      if (shouldStop) return;

      cumulativeArray[i] = cumulativeArray[i - 1] + countArray[i];
      currentCount = cumulativeArray[i];

      currentStep = "Cumulative count for value $currentValue: $currentCount";
      operationIndicator = "🔢 Cumulative[$currentValue] = $currentCount";
      onStateChanged();

      _animationController.reset();

      await Future.delayed(Duration(milliseconds: (400 / speed).round()));
    }

    if (shouldStop) return;

    currentIndex = -1;
    currentStep = "Cumulative counts calculated";
    operationIndicator = "✓ Position array ready";
    onStateChanged();

    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (800 / speed).round()));
    if (shouldStop) return;

    // Phase 5: Build sorted output
    currentPhase = 5;
    highlightedLine = 6;
    currentStep = "Phase 5: Placing elements in sorted order...";
    operationIndicator = "📍 Building sorted array";
    onStateChanged();

    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (600 / speed).round()));

    // Create temporary arrays
    final List<SortItem> originalCopy = List.from(numbers);
    final List<SortItem?> sortedArray = List.filled(numbers.length, null);
    final List<int> tempCumulative = List.from(cumulativeArray);

    // Process in reverse for stability
    for (int i = originalCopy.length - 1; i >= 0; i--) {
      if (shouldStop) return;
      await _waitIfPaused();

      currentIndex = i;
      currentValue = originalCopy[i].value;
      int countIndex = currentValue - minValue;
      int position = tempCumulative[countIndex] - 1;
      placingIndex = position;

      _animationController.duration = Duration(milliseconds: (700 / speed).round());
      await _animationController.forward();
      if (shouldStop) return;

      sortedArray[position] = originalCopy[i];
      tempCumulative[countIndex]--;
      totalPlacements++;

      currentStep = "Placing $currentValue at position $position";
      operationIndicator = "📍 $currentValue → Position $position";
      onStateChanged();

      _animationController.reset();

      await Future.delayed(Duration(milliseconds: (600 / speed).round()));
    }

    if (shouldStop) return;

    // Update the numbers array with sorted result
    for (int i = 0; i < sortedArray.length; i++) {
      numbers[i] = sortedArray[i]!;
    }

    _finishSorting();
  }

  void _finishSorting() {
    currentIndex = -1;
    currentValue = -1;
    currentCount = -1;
    placingIndex = -1;
    currentPhase = 6;
    isSorting = false;
    highlightedLine = -1;

    if (shouldStop) {
      currentStep = "Sorting stopped by user";
      operationIndicator = "⏹️ Sorting was interrupted";
    } else {
      isSorted = true;
      highlightedLine = 7;
      currentStep = "Counting sort completed!";
      operationIndicator = "🎉 Sorting Complete! Array is sorted in O(n+k) time";
    }
    onStateChanged();
  }

  Color getBarColor(int index) {
    if (isSorted) return Colors.green;

    switch (currentPhase) {
      case 1: // Finding range
        if (index == currentIndex) return Colors.orange;
        return Colors.blue.shade300;

      case 2: // Initializing
        return Colors.purple.shade300;

      case 3: // Counting
        if (index == currentIndex) {
          return _countAnimation.value > 0.5 ? Colors.red : Colors.orange;
        }
        return Colors.blue.shade300;

      case 4: // Cumulative
        return Colors.teal.shade300;

      case 5: // Placing
        if (index == currentIndex) return Colors.orange;
        if (index == placingIndex) return Colors.green.shade400;
        return Colors.blue.shade300;

      default:
        return Colors.blue.shade300;
    }
  }
}

