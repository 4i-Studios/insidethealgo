import 'package:flutter/material.dart';
import 'dart:async';

class SortItem {
  final int id;
  int value;
  SortItem(this.id, this.value);
}

enum AnimationMode { tree, bubble, bars }

class MergeSortLogic {
  final VoidCallback onStateChanged;
  final TickerProvider vsync;

  MergeSortLogic({
    required this.onStateChanged,
    required this.vsync,
  }) {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );
    _mergeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        movingFromIndex = -1;
        movingToIndex = -1;
        movingValue = null;
        onStateChanged();
      }
    });
    numbers = _makeItemsFromInts(_defaultNumbers);
    originalNumbers = List.from(numbers);
    _resetState();
  }

  final List<int> _defaultNumbers = const [64, 34, 25, 12, 22, 11, 90, 88, 76, 50];

  late List<SortItem> numbers;
  late List<SortItem> originalNumbers;

  List<SortItem> leftArray = [];
  List<SortItem> rightArray = [];
  List<SortItem> mergedArray = [];
  int leftIndex = -1;
  int rightIndex = -1;
  int mergeIndex = -1;
  bool isMerging = false;
  bool isDividing = false;

  int activeRangeLeft = -1;
  int activeRangeRight = -1;
  int activeRangeLevel = -1;

  String currentStep = "Ready to start sorting";
  String operationIndicator = "";
  int totalComparisons = 0;
  int totalMerges = 0;

  bool isSorting = false;
  bool isSorted = false;
  bool isAscending = true;
  double speed = 1.0;
  bool shouldStop = false;
  bool isPaused = false;
  int highlightedLine = -1;
  bool isSpeedControlExpanded = false;

  AnimationMode _animationMode = AnimationMode.tree;
  AnimationMode get animationMode => _animationMode;

  List<TreeLevel> treeLevels = [];
  final Set<String> visitedRanges = <String>{};
  final Set<String> dividingRanges = <String>{};
  final Set<String> mergingRanges = <String>{};
  final Set<String> completedRanges = <String>{};
  int movingFromIndex = -1;
  int movingToIndex = -1;
  int? movingValue;
  int mergeLeftStart = -1;
  int mergeRightStart = -1;

  late AnimationController _animationController;
  late Animation<double> _mergeAnimation;

  final TextEditingController inputController = TextEditingController();
  String? inputError;

  Animation<double> get mergeAnimation => _mergeAnimation;

  void dispose() {
    _animationController.dispose();
    inputController.dispose();
  }

  List<SortItem> _makeItemsFromInts(List<int> list) {
    int id = 0;
    return list.map((v) => SortItem(id++, v)).toList();
  }

  void cycleAnimationMode() {
    switch (_animationMode) {
      case AnimationMode.tree:
        _animationMode = AnimationMode.bubble;
        break;
      case AnimationMode.bubble:
        _animationMode = AnimationMode.bars;
        break;
      case AnimationMode.bars:
        _animationMode = AnimationMode.tree;
        break;
    }
    onStateChanged();
  }

  String get animationModeLabel {
    switch (_animationMode) {
      case AnimationMode.tree:
        return "Tree View";
      case AnimationMode.bubble:
        return "Bubble View";
      case AnimationMode.bars:
        return "Bar Chart";
    }
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
    numbers = _makeItemsFromInts(_defaultNumbers);
    originalNumbers = _makeItemsFromInts(_defaultNumbers);
    _resetState();
    inputError = null;
    inputController.clear();
    onStateChanged();
  }

  void _resetState() {
    leftArray = [];
    rightArray = [];
    mergedArray = [];
    leftIndex = -1;
    rightIndex = -1;
    mergeIndex = -1;
    isMerging = false;
    isDividing = false;
    isSorting = false;
    isSorted = false;
    shouldStop = false;
    highlightedLine = -1;
    currentStep = "Ready to start sorting";
    operationIndicator = "";
    totalComparisons = 0;
    totalMerges = 0;
    treeLevels = [];
    visitedRanges.clear();
    dividingRanges.clear();
    mergingRanges.clear();
    completedRanges.clear();
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
      startMergeSort();
    }
    onStateChanged();
  }

  Future<void> _waitIfPaused() async {
    while (isPaused) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> startMergeSort() async {
    if (isSorting) return;
    if (numbers.isEmpty) return;

    isSorting = true;
    isSorted = false;
    shouldStop = false;
    isPaused = false;
    totalComparisons = 0;
    totalMerges = 0;

    currentStep = isAscending
        ? "Starting merge sort (ascending)..."
        : "Starting merge sort (descending)...";
    highlightedLine = 0;

    onStateChanged();

    _buildInitialTreeStructure();

    List<SortItem> sortedArray = List.from(numbers);
    await _mergeSort(sortedArray, 0, numbers.length - 1);

    if (!shouldStop) {
      numbers = sortedArray;
      isSorted = true;
      currentStep = "Sorting completed!";
      operationIndicator = "✅ Array successfully sorted using merge sort";
      highlightedLine = -1;
    }

    isSorting = false;
    onStateChanged();
  }

  void _buildInitialTreeStructure() {
    treeLevels.clear();
    _addTreeLevel([...numbers]);
  }

  void _addTreeLevel(List<SortItem> items) {
    if (treeLevels.length > 4) return;
    treeLevels.add(TreeLevel(items: [...items], level: treeLevels.length));
    onStateChanged();
  }

  Future<void> _mergeSort(List<SortItem> arr, int left, int right, [int level = 0]) async {
    if (shouldStop) return;
    await _waitIfPaused();

    if (left < right) {
      activeRangeLeft = left;
      activeRangeRight = right;
      activeRangeLevel = level;

      final String rangeKey = '$left-$right';
      visitedRanges.add(rangeKey);
      dividingRanges.add(rangeKey);

      isDividing = true;
      int mid = left + (right - left) ~/ 2;

      currentStep = "Dividing array from index $left to $right";
      operationIndicator = "📋 Split: [${left}-${mid}] | [${mid+1}-${right}]";
      highlightedLine = 1;

      onStateChanged();
      await Future.delayed(Duration(milliseconds: (1000 / speed).round()));

      dividingRanges.remove(rangeKey);
      onStateChanged();

      await _mergeSort(arr, left, mid, level + 1);
      if (shouldStop) return;

      await _mergeSort(arr, mid + 1, right, level + 1);
      if (shouldStop) return;

      await _merge(arr, left, mid, right, level);

      completedRanges.add(rangeKey);

      activeRangeLeft = -1;
      activeRangeRight = -1;
      activeRangeLevel = -1;
      onStateChanged();
    }
  }

  Future<void> _merge(List<SortItem> arr, int left, int mid, int right, [int level = 0]) async {
    if (shouldStop) return;
    await _waitIfPaused();

    final String rangeKey = '$left-$right';
    mergingRanges.add(rangeKey);

    activeRangeLeft = left;
    activeRangeRight = right;
    activeRangeLevel = level;

    isMerging = true;
    isDividing = false;

    List<SortItem> leftArr = [];
    List<SortItem> rightArr = [];

    for (int i = left; i <= mid; i++) {
      leftArr.add(SortItem(arr[i].id, arr[i].value));
    }
    for (int i = mid + 1; i <= right; i++) {
      rightArr.add(SortItem(arr[i].id, arr[i].value));
    }

    mergeLeftStart = left;
    mergeRightStart = mid + 1;

    leftArray = leftArr;
    rightArray = rightArr;

    currentStep = "Merging subarrays";
    operationIndicator = "🔀 Merging: [${leftArr.map((e) => e.value).join(',')}] + [${rightArr.map((e) => e.value).join(',')}]";
    highlightedLine = 3;

    onStateChanged();
    await Future.delayed(Duration(milliseconds: (800 / speed).round()));

    int i = 0, j = 0, k = left;

    while (i < leftArr.length && j < rightArr.length) {
      if (shouldStop) return;
      await _waitIfPaused();

      totalComparisons++;
      leftIndex = i;
      rightIndex = j;
      mergeIndex = k;

      bool condition = isAscending
          ? leftArr[i].value <= rightArr[j].value
          : leftArr[i].value >= rightArr[j].value;

      if (condition) {
        currentStep = "Taking ${leftArr[i].value} from left array";
        operationIndicator = "📥 ${leftArr[i].value} → position $k";
        arr[k] = SortItem(leftArr[i].id, leftArr[i].value);
        movingFromIndex = mergeLeftStart + i;
        movingToIndex = k;
        movingValue = leftArr[i].value;
        _animationController.forward(from: 0.0);
        i++;
      } else {
        currentStep = "Taking ${rightArr[j].value} from right array";
        operationIndicator = "📥 ${rightArr[j].value} → position $k";
        arr[k] = SortItem(rightArr[j].id, rightArr[j].value);
        movingFromIndex = mergeRightStart + j;
        movingToIndex = k;
        movingValue = rightArr[j].value;
        _animationController.forward(from: 0.0);
        j++;
      }

      k++;
      highlightedLine = 4;
      onStateChanged();
      await Future.delayed(Duration(milliseconds: (600 / speed).round()));
    }

    while (i < leftArr.length) {
      if (shouldStop) return;
      await _waitIfPaused();

      arr[k] = SortItem(leftArr[i].id, leftArr[i].value);
      movingFromIndex = mergeLeftStart + i;
      movingToIndex = k;
      movingValue = leftArr[i].value;
      _animationController.forward(from: 0.0);
      currentStep = "Copying remaining element ${leftArr[i].value}";
      operationIndicator = "📥 ${leftArr[i].value} → position $k";
      i++;
      k++;
      onStateChanged();
      await Future.delayed(Duration(milliseconds: (400 / speed).round()));
    }

    while (j < rightArr.length) {
      if (shouldStop) return;
      await _waitIfPaused();

      arr[k] = SortItem(rightArr[j].id, rightArr[j].value);
      movingFromIndex = mergeRightStart + j;
      movingToIndex = k;
      movingValue = rightArr[j].value;
      _animationController.forward(from: 0.0);
      currentStep = "Copying remaining element ${rightArr[j].value}";
      operationIndicator = "📥 ${rightArr[j].value} → position $k";
      j++;
      k++;
      onStateChanged();
      await Future.delayed(Duration(milliseconds: (400 / speed).round()));
    }

    totalMerges++;
    isMerging = false;
    leftIndex = -1;
    rightIndex = -1;
    mergeIndex = -1;
    leftArray = [];
    rightArray = [];

    mergingRanges.remove(rangeKey);

    currentStep = "Merge complete for range [$left-$right]";
    operationIndicator = "✅ Subarray merged successfully";

    onStateChanged();
    await Future.delayed(Duration(milliseconds: (500 / speed).round()));

    activeRangeLeft = -1;
    activeRangeRight = -1;
    activeRangeLevel = -1;
    onStateChanged();
  }
}

class TreeLevel {
  final List<SortItem> items;
  final int level;
  bool isActive;

  TreeLevel({
    required this.items,
    required this.level,
    this.isActive = false,
  });
}
