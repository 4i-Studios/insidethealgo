import 'package:flutter/material.dart';
import 'dart:async';

class MergeSortLogic {
  final VoidCallback onStateChanged;
  final TickerProvider vsync;

  MergeSortLogic({
    required this.onStateChanged,
    required this.vsync,
  }) {
    sortAnimation = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );
    _initializeColors();
    arrayController.text = numbers.join(', ');
  }

  // Controllers
  final TextEditingController arrayController = TextEditingController();

  // Animation
  late AnimationController sortAnimation;

  // State variables
  List<int> numbers = [64, 34, 25, 12, 22, 11, 90, 88, 76, 50];
  List<int> originalNumbers = [64, 34, 25, 12, 22, 11, 90, 88, 76, 50];
  bool isSorting = false;
  bool sortCompleted = false;
  String currentStep = 'Enter numbers and start sorting';
  String operationIndicator = '';
  int totalSwaps = 0;
  int totalComparisons = 0;
  int highlightedLine = -1;

  // Speed control properties to match other sorting algorithms
  double speed = 1.0;
  bool isPaused = false;
  bool isSpeedControlExpanded = false;
  bool shouldStop = false;

  // Merge sort specific
  List<int> leftArray = [];
  List<int> rightArray = [];
  int leftIndex = -1;
  int rightIndex = -1;
  int mergeIndex = -1;
  List<Color> barColors = [];

  void _initializeColors() {
    barColors = List.generate(numbers.length, (index) => Colors.blue);
  }

  void dispose() {
    sortAnimation.dispose();
    arrayController.dispose();
  }

  void updateSpeed(double newSpeed) {
    speed = newSpeed;
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
      startSort();
    }
    onStateChanged();
  }

  void stopSorting() {
    shouldStop = true;
    isSorting = false;
    onStateChanged();
  }

  Future<void> _waitIfPaused() async {
    while (isPaused) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void setArrayFromInput(BuildContext context) {
    try {
      String input = arrayController.text.trim();
      if (input.isEmpty) {
        _showSnackBar(context, 'Please enter some numbers');
        return;
      }

      List<String> parts = input.split(',');
      List<int> newNumbers = parts.map((e) => int.parse(e.trim())).toList();

      if (newNumbers.isEmpty) {
        _showSnackBar(context, 'Please enter valid numbers');
        return;
      }

      if (newNumbers.length > 20) {
        _showSnackBar(context, 'Maximum 20 numbers allowed');
        return;
      }

      numbers = newNumbers;
      originalNumbers = List.from(numbers);
      _resetSortingState();
      _initializeColors();
      onStateChanged();
    } catch (e) {
      _showSnackBar(context, 'Please enter valid numbers separated by commas');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _resetSortingState() {
    isSorting = false;
    sortCompleted = false;
    currentStep = 'Enter numbers and start sorting';
    operationIndicator = '';
    totalSwaps = 0;
    totalComparisons = 0;
    highlightedLine = -1;
    leftArray = [];
    rightArray = [];
    leftIndex = -1;
    rightIndex = -1;
    mergeIndex = -1;
    _initializeColors();
  }

  void resetArray() {
    numbers = List.from(originalNumbers);
    _resetSortingState();
    onStateChanged();
  }

  void shuffleArray() {
    if (!isSorting) {
      numbers.shuffle();
      originalNumbers = List.from(numbers);
      arrayController.text = numbers.join(', ');
      _resetSortingState();
      onStateChanged();
    }
  }

  Future<void> startSort() async {
    if (isSorting || numbers.isEmpty) return;

    isSorting = true;
    sortCompleted = false;
    totalSwaps = 0;
    totalComparisons = 0;
    highlightedLine = 0;
    currentStep = 'Starting merge sort...';
    onStateChanged();

    await _mergeSort(0, numbers.length - 1);

    isSorting = false;
    sortCompleted = true;
    currentStep = 'Sorting completed!';
    operationIndicator = 'Array is now sorted! ✨';
    highlightedLine = -1;
    _initializeColors();
    onStateChanged();
  }

  Future<void> _mergeSort(int left, int right) async {
    if (shouldStop) return;

    if (left < right) {
      highlightedLine = 1;
      int mid = (left + right) ~/ 2;

      operationIndicator = 'Dividing array: [${left}, ${right}] → [${left}, ${mid}] and [${mid + 1}, ${right}]';
      _highlightRange(left, right, Colors.orange);
      onStateChanged();

      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (800 / speed).round()));

      // Recursively sort left and right halves
      await _mergeSort(left, mid);
      await _mergeSort(mid + 1, right);

      // Merge the sorted halves
      await _merge(left, mid, right);
    }
  }

  Future<void> _merge(int left, int mid, int right) async {
    if (shouldStop) return;

    highlightedLine = 5;

    // Create temporary arrays
    List<int> leftArr = numbers.sublist(left, mid + 1);
    List<int> rightArr = numbers.sublist(mid + 1, right + 1);

    leftArray = leftArr;
    rightArray = rightArr;

    operationIndicator = 'Merging: Left[${leftArr.join(',')}] Right[${rightArr.join(',')}]';
    _highlightRange(left, right, Colors.purple);
    onStateChanged();

    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (1000 / speed).round()));

    int i = 0, j = 0, k = left;

    // Merge the arrays
    while (i < leftArr.length && j < rightArr.length && !shouldStop) {
      highlightedLine = 8;
      totalComparisons++;

      leftIndex = i;
      rightIndex = j;
      mergeIndex = k;

      if (leftArr[i] <= rightArr[j]) {
        operationIndicator = 'Comparing: ${leftArr[i]} ≤ ${rightArr[j]} → Take ${leftArr[i]}';
        numbers[k] = leftArr[i];
        i++;
      } else {
        operationIndicator = 'Comparing: ${leftArr[i]} > ${rightArr[j]} → Take ${rightArr[j]}';
        numbers[k] = rightArr[j];
        j++;
      }

      barColors[k] = Colors.green;
      k++;
      totalSwaps++;

      onStateChanged();
      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (600 / speed).round()));
    }

    // Copy remaining elements
    while (i < leftArr.length && !shouldStop) {
      highlightedLine = 13;
      leftIndex = i;
      mergeIndex = k;
      operationIndicator = 'Copying remaining left element: ${leftArr[i]}';
      numbers[k] = leftArr[i];
      barColors[k] = Colors.green;
      i++;
      k++;
      totalSwaps++;
      onStateChanged();
      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (400 / speed).round()));
    }

    while (j < rightArr.length && !shouldStop) {
      highlightedLine = 16;
      rightIndex = j;
      mergeIndex = k;
      operationIndicator = 'Copying remaining right element: ${rightArr[j]}';
      numbers[k] = rightArr[j];
      barColors[k] = Colors.green;
      j++;
      k++;
      totalSwaps++;
      onStateChanged();
      await _waitIfPaused();
      await Future.delayed(Duration(milliseconds: (400 / speed).round()));
    }

    leftIndex = -1;
    rightIndex = -1;
    mergeIndex = -1;
    operationIndicator = 'Merged successfully!';

    onStateChanged();
    await _waitIfPaused();
    await Future.delayed(Duration(milliseconds: (500 / speed).round()));
  }

  void _highlightRange(int start, int end, Color color) {
    for (int i = 0; i < barColors.length; i++) {
      if (i >= start && i <= end) {
        barColors[i] = color;
      } else {
        barColors[i] = Colors.blue;
      }
    }
  }

  Color getBarColor(int index) {
    if (index == mergeIndex && isSorting) return Colors.red;
    if (sortCompleted) return Colors.green;
    return barColors[index];
  }
}