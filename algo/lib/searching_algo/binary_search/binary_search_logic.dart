import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

class BinarySearchLogic {
  final VoidCallback onStateChanged;
  final TickerProvider vsync;

  BinarySearchLogic({required this.onStateChanged, required this.vsync}) {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync,
    );
    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.addListener(onStateChanged);
  }

  // State variables
  final List<int> defaultNumbers = const [
    11,
    12,
    22,
    25,
    34,
    50,
    64,
    76,
    88,
    90,
  ];
  List<int> numbers = [11, 12, 22, 25, 34, 50, 64, 76, 88, 90];
  List<int> originalNumbers = [11, 12, 22, 25, 34, 50, 64, 76, 88, 90];

  int leftIndex = -1;
  int rightIndex = -1;
  int midIndex = -1;
  int targetValue = 34;
  int foundIndex = -1;
  bool isSearching = false;
  bool isFound = false;
  bool searchCompleted = false;
  bool isArraySorted = true;

  String currentStep = "Ready to start searching";
  String operationIndicator = "";
  int totalComparisons = 0;
  int totalSteps = 0;

  double speed = 1.0;
  bool shouldStop = false;
  bool isPaused = false;
  int highlightedLine = -1;
  bool isSpeedControlExpanded = false;

  late AnimationController _animationController;
  late Animation<double> _searchAnimation;

  final TextEditingController arrayController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  String? inputError;

  final Set<int> _examinedIndices = <int>{};
  final Set<int> _discardedIndices = <int>{};

  UnmodifiableSetView<int> get examinedIndices =>
      UnmodifiableSetView(_examinedIndices);
  UnmodifiableSetView<int> get discardedIndices =>
      UnmodifiableSetView(_discardedIndices);

  // Getters
  Animation<double> get searchAnimation => _searchAnimation;

  bool get isAscending {
    for (int i = 1; i < numbers.length; i++) {
      if (numbers[i] < numbers[i - 1]) {
        return false;
      }
    }
    return true;
  }

  void dispose() {
    _animationController.removeListener(onStateChanged);
    _animationController.dispose();
    arrayController.dispose();
    targetController.dispose();
  }

  void setArrayFromInput(BuildContext context) {
    final input = arrayController.text.trim();
    if (input.isEmpty) {
      _showSnackBar(context, 'Array input required');
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

    numbers = List.from(nums);
    originalNumbers = List.from(nums);
    _checkIfSorted();
    _resetState();
    onStateChanged();
  }

  void setTargetFromInput(BuildContext context) {
    final input = targetController.text.trim();
    if (input.isEmpty) {
      _showSnackBar(context, 'Target value required');
      return;
    }

    final target = int.tryParse(input);
    if (target == null) {
      _showSnackBar(context, 'Target must be an integer');
      return;
    }

    targetValue = target;
    _resetState();
    currentStep = isArraySorted
        ? "Ready to search for $targetValue"
        : "Array must be sorted! Please sort first or enter a sorted array";
    onStateChanged();
  }

  void _checkIfSorted() {
    isArraySorted = true;
    for (int i = 1; i < numbers.length; i++) {
      if (numbers[i] < numbers[i - 1]) {
        isArraySorted = false;
        break;
      }
    }
  }

  void resetArray() {
    numbers = List.from(defaultNumbers);
    originalNumbers = List.from(defaultNumbers);
    targetValue = 34;
    _resetState();
    arrayController.clear();
    targetController.clear();
    onStateChanged();
  }

  void shuffleArray() {
    if (!isSearching) {
      numbers.shuffle();
      originalNumbers = List.from(numbers);
      _resetState();
      currentStep = "Array shuffled - Ready to search for $targetValue";
      isArraySorted = false;
      onStateChanged();
    }
  }

  void sortArray() {
    if (!isSearching) {
      numbers.sort();
      originalNumbers = List.from(numbers);
      _resetState();
      currentStep = "Array sorted - Ready to search for $targetValue";
      isArraySorted = true;
      onStateChanged();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _resetState() {
    leftIndex = -1;
    rightIndex = -1;
    midIndex = -1;
    foundIndex = -1;
    isSearching = false;
    isFound = false;
    searchCompleted = false;
    shouldStop = false;
    highlightedLine = -1;
    currentStep = isArraySorted
        ? "Ready to search for $targetValue"
        : "Array must be sorted! Please sort first";
    operationIndicator = "";
    totalComparisons = 0;
    totalSteps = 0;
    _examinedIndices.clear();
    _discardedIndices.clear();
  }

  void stopSearching() {
    shouldStop = true;
    isSearching = false;
    highlightedLine = -1;
    currentStep = "Search stopped by user";
    operationIndicator = "⏹️ Search process halted";
    onStateChanged();
  }

  void updateSpeed(double newSpeed) {
    speed = newSpeed.clamp(0.1, 6.0).toDouble();
    onStateChanged();
  }

  void toggleSpeedControl() {
    isSpeedControlExpanded = !isSpeedControlExpanded;
    onStateChanged();
  }

  void onPlayPausePressed() {
    if (!isArraySorted) {
      currentStep = "Array must be sorted first! Click 'Sort' button";
      operationIndicator = "⚠️ Binary search requires a sorted array";
      onStateChanged();
      return;
    }

    if (isSearching) {
      isPaused = !isPaused;
    } else {
      startBinarySearch();
    }
    onStateChanged();
  }

  Future<void> _waitIfPaused() async {
    while (isPaused) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Duration _scaledDelay(int baseMilliseconds) {
    final double effectiveSpeed = speed <= 0 ? 0.1 : speed;
    return Duration(milliseconds: (baseMilliseconds / effectiveSpeed).round());
  }

  Future<void> startBinarySearch() async {
    if (isSearching || !isArraySorted) return;

    isSearching = true;
    isFound = false;
    searchCompleted = false;
    shouldStop = false;
    totalComparisons = 0;
    totalSteps = 0;
    operationIndicator = "";
    highlightedLine = 0;
    _examinedIndices.clear();
    _discardedIndices.clear();
    onStateChanged();

    int n = numbers.length;

    // Initialize left and right pointers
    highlightedLine = 1;
    leftIndex = 0;
    rightIndex = n - 1;
    currentStep = "Initialize: left = 0, right = ${n - 1}";
    operationIndicator = "🎯 Searching for: $targetValue in sorted array";
    onStateChanged();

    await _waitIfPaused();
    await Future.delayed(_scaledDelay(1000));

    while (leftIndex <= rightIndex) {
      if (shouldStop) break;
      totalSteps++;
      final int previousLeft = leftIndex;
      final int previousRight = rightIndex;

      // Calculate mid
      highlightedLine = 2;
      midIndex = (leftIndex + rightIndex) ~/ 2;
      currentStep =
          "Step $totalSteps: Calculate mid = ($leftIndex + $rightIndex) ÷ 2 = $midIndex";
      operationIndicator =
          "🔢 Mid index: $midIndex, value: ${numbers[midIndex]}";
      onStateChanged();
      _examinedIndices.add(midIndex);
      _animationController.forward(from: 0.0);

      await _waitIfPaused();
      await Future.delayed(_scaledDelay(1200));
      if (shouldStop) break;

      // Compare with target
      highlightedLine = 3;
      currentStep = "Comparing: ${numbers[midIndex]} vs $targetValue";
      operationIndicator =
          "⚖️ Compare: arr[$midIndex] = ${numbers[midIndex]} vs target = $targetValue";
      totalComparisons++;
      onStateChanged();

      await _waitIfPaused();
      await Future.delayed(_scaledDelay(1200));
      if (shouldStop) break;

      if (numbers[midIndex] == targetValue) {
        // Found the target
        highlightedLine = 4;
        foundIndex = midIndex;
        isFound = true;
        currentStep = "Target found at index $midIndex!";
        operationIndicator =
            "🎉 Success! Found $targetValue at position $midIndex";
        onStateChanged();

        await _waitIfPaused();
        await Future.delayed(_scaledDelay(1500));
        break;
      } else if (numbers[midIndex] < targetValue) {
        // Search right half
        highlightedLine = 5;
        _markDiscardedRange(previousLeft, midIndex);
        leftIndex = midIndex + 1;
        currentStep = "${numbers[midIndex]} < $targetValue, search right half";
        operationIndicator =
            "➡️ Target is larger, search right: left = ${leftIndex}";
        onStateChanged();

        await _waitIfPaused();
        await Future.delayed(_scaledDelay(1000));
      } else {
        // Search left half
        highlightedLine = 6;
        _markDiscardedRange(midIndex, previousRight);
        rightIndex = midIndex - 1;
        currentStep = "${numbers[midIndex]} > $targetValue, search left half";
        operationIndicator =
            "⬅️ Target is smaller, search left: right = ${rightIndex}";
        onStateChanged();

        await _waitIfPaused();
        await Future.delayed(_scaledDelay(1000));
      }

      if (shouldStop) break;

      // Show updated range
      if (leftIndex <= rightIndex) {
        currentStep = "New search range: [$leftIndex, $rightIndex]";
        operationIndicator =
            "🔍 Narrowed search range to indices $leftIndex-$rightIndex";
        onStateChanged();

        await _waitIfPaused();
        await Future.delayed(_scaledDelay(800));
      }
    }

    _finishSearch();
  }

  void _finishSearch() {
    isSearching = false;
    searchCompleted = true;

    if (shouldStop) {
      currentStep = "Search stopped by user";
      operationIndicator = "⏹️ Search was interrupted";
      highlightedLine = -1;
    } else if (isFound) {
      highlightedLine = 5;
      currentStep = "";
      operationIndicator =
          "✅ Success! Found $targetValue at index $foundIndex in $totalSteps steps ($totalComparisons comparisons)";
    } else {
      highlightedLine = 12;
      leftIndex = -1;
      rightIndex = -1;
      midIndex = -1;
      _markDiscardedRange(0, numbers.length - 1);
      currentStep = "";
      operationIndicator =
          "❌ Target $targetValue not found after $totalSteps steps ($totalComparisons comparisons)";
    }
    onStateChanged();
  }

  void _markDiscardedRange(int start, int end) {
    if (start > end) return;
    for (int i = start; i <= end; i++) {
      if (i >= 0 && i < numbers.length) {
        _discardedIndices.add(i);
      }
    }
  }

  Color getBarColor(int index) {
    if (isFound && index == foundIndex) {
      return Colors.green;
    }
    if (midIndex == index && isSearching) {
      return Colors.orange;
    }
    if (_discardedIndices.contains(index)) {
      return Colors.grey.shade400;
    }
    if (isSearching &&
        leftIndex >= 0 &&
        rightIndex >= 0 &&
        index >= leftIndex &&
        index <= rightIndex) {
      if (index == leftIndex) return Colors.blue.shade600;
      if (index == rightIndex) return Colors.purple.shade400;
      return Colors.blue.shade200;
    }
    if (searchCompleted && !isFound) {
      return Colors.grey.shade400;
    }
    return Colors.blue.shade100;
  }

  String getBarLabel(int index) {
    if (isFound && index == foundIndex) return '✓';
    if (index == leftIndex && isSearching) return 'L';
    if (index == rightIndex && isSearching) return 'R';
    if (index == midIndex && isSearching) return 'M';
    return '';
  }
}
