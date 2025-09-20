import 'package:flutter/material.dart';
import 'dart:async';

class LinearSearchLogic {
  final VoidCallback onStateChanged;
  final TickerProvider vsync;

  LinearSearchLogic({
    required this.onStateChanged,
    required this.vsync,
  }) {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync,
    );
    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  // State variables
  final List<int> defaultNumbers = const [64, 34, 25, 12, 22, 11, 90, 88, 76, 50];
  List<int> numbers = [64, 34, 25, 12, 22, 11, 90, 88, 76, 50];
  List<int> originalNumbers = [64, 34, 25, 12, 22, 11, 90, 88, 76, 50];

  int currentIndex = -1;
  int targetValue = 22;
  int foundIndex = -1;
  bool isSearching = false;
  bool isFound = false;
  bool searchCompleted = false;

  String currentStep = "Ready to start searching";
  String operationIndicator = "";
  int totalComparisons = 0;

  double speed = 1.0;
  bool shouldStop = false;
  bool isPaused = false;
  int highlightedLine = -1;
  bool isSpeedControlExpanded = false;

  // Opt-in flag for new search card animation. Default false to preserve existing UI.
  bool useSearchCardAnimation = true; // Changed to true to enable by default

  late AnimationController _animationController;
  late Animation<double> _searchAnimation;

  final TextEditingController arrayController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  String? inputError;

  // Getters
  Animation<double> get searchAnimation => _searchAnimation;

  void dispose() {
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
    currentStep = "Ready to search for $targetValue";
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
    targetValue = 22;
    _resetState();
    inputError = null;
    arrayController.clear();
    targetController.clear();
    onStateChanged();
  }

  void _resetState() {
    currentIndex = -1;
    foundIndex = -1;
    isSearching = false;
    isFound = false;
    searchCompleted = false;
    shouldStop = false;
    highlightedLine = -1;
    currentStep = "Ready to search for $targetValue";
    operationIndicator = "";
    totalComparisons = 0;
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
    speed = newSpeed;
    onStateChanged();
  }

  void shuffleArray() {
    numbers.shuffle();
    originalNumbers = List.from(numbers);
    _resetState();
    currentStep = "Array shuffled - Ready to search for $targetValue";
    onStateChanged();
  }

  void toggleSpeedControl() {
    isSpeedControlExpanded = !isSpeedControlExpanded;
    onStateChanged();
  }

  void onPlayPausePressed() {
    if (isSearching) {
      isPaused = !isPaused;
    } else {
      startLinearSearch();
    }
    onStateChanged();
  }

  Future<void> _waitIfPaused() async {
    while (isPaused) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> startLinearSearch() async {
    if (isSearching) return;

    isSearching = true;
    isFound = false;
    searchCompleted = false;
    shouldStop = false;
    totalComparisons = 0;
    operationIndicator = "";
    highlightedLine = 0;
    onStateChanged();

    int n = numbers.length;

    highlightedLine = 1;
    currentStep = "Starting linear search for target value: $targetValue";
    operationIndicator = "🎯 Searching for: $targetValue in array of $n elements";
    onStateChanged();

    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (800 / speed).round()));

    for (int i = 0; i < n; i++) {
      if (shouldStop) break;

      currentIndex = i;
      highlightedLine = 2;
      currentStep = "Checking element at index $i: ${numbers[i]}";
      operationIndicator = "🔍 Checking position $i: ${numbers[i]}";
      onStateChanged();

      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (800 / speed).round()));
      if (shouldStop) break;

      // Compare with target
      highlightedLine = 3;
      currentStep = "Comparing ${numbers[i]} with target $targetValue";
      operationIndicator = "⚖️ Comparing: ${numbers[i]} == $targetValue ?";
      totalComparisons++;
      onStateChanged();

      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (1000 / speed).round()));
      if (shouldStop) break;

      if (numbers[i] == targetValue) {
        // Found the target
        highlightedLine = 4;
        foundIndex = i;
        isFound = true;
        currentStep = "Target found at index $i!";
        operationIndicator = "🎉 Found! Target $targetValue is at position $i";
        onStateChanged();

        await _waitIfPaused();
        await Future.delayed(Duration(milliseconds: (1200 / speed).round()));
        break;
      } else {
        // Not found, continue
        highlightedLine = 5;
        currentStep = "${numbers[i]} ≠ $targetValue, continue searching...";
        operationIndicator = "❌ No match: ${numbers[i]} ≠ $targetValue";
        onStateChanged();

        await _waitIfPaused();
        await Future.delayed(Duration(milliseconds: (600 / speed).round()));
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
      highlightedLine = 4;
      currentStep = "";
      operationIndicator = "✅ Success! Found $targetValue at index $foundIndex after $totalComparisons comparisons";
    } else {
      highlightedLine = 7;
      currentIndex = -1;
      currentStep = "";
      operationIndicator = "❌ Target $targetValue not found in array after $totalComparisons comparisons";
    }
    onStateChanged();
  }

  Color getBarColor(int index) {
    if (isFound && index == foundIndex) {
      return Colors.green;
    }
    if (currentIndex == index && isSearching) {
      return Colors.orange;
    }
    if (searchCompleted && index <= currentIndex && !isFound) {
      return Colors.red.shade300;
    }
    if (isSearching && index < currentIndex) {
      return Colors.grey.shade400;
    }
    return Colors.blue.shade200;
  }
}