import 'package:flutter/material.dart';
import 'dart:async';

class SortItem {
  final int id;
  int value;
  SortItem(this.id, this.value);
}

enum AnimationMode { tree, bubble, bars }

enum NodeState { unvisited, dividing, merging, completed, merged }

class MergeSortLogic {
  final VoidCallback onStateChanged;
  final TickerProvider vsync;
  final Map<String, List<int>> mergedNodes = <String, List<int>>{};
  MergeSortLogic({required this.onStateChanged, required this.vsync}) {
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

  final List<int> _defaultNumbers = const [
    64,
    34,
    25,
    12,
    22,
    11,
    90,
    88,
    76,
    50,
  ];

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
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
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
    activeRangeLeft = -1;
    activeRangeRight = -1;
    activeRangeLevel = -1;
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
    mergedNodes.clear();
    movingFromIndex = -1;
    movingToIndex = -1;
    movingValue = null;
    mergeLeftStart = -1;
    mergeRightStart = -1;
  }

  void stopSorting() {
    shouldStop = true;
    isSorting = false;
    highlightedLine = -1;
    currentStep = "Sorting stopped by user";
    operationIndicator = "⏹️ Sorting process halted";
    _animationController.stop();
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
    speed = newSpeed.clamp(0.1, 6.0).toDouble();
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

  Duration _scaledDelay(int baseMilliseconds) {
    final double effectiveSpeed = speed <= 0 ? 0.1 : speed;
    return Duration(milliseconds: (baseMilliseconds / effectiveSpeed).round());
  }

  Future<void> _pauseAwareDelay(int baseMilliseconds) async {
    if (baseMilliseconds <= 0) return;
    final int target = _scaledDelay(baseMilliseconds).inMilliseconds;
    int elapsed = 0;
    const int step = 40;
    while (elapsed < target && !shouldStop) {
      if (isPaused) {
        await Future.delayed(const Duration(milliseconds: 100));
        continue;
      }
      final int remaining = target - elapsed;
      final int chunk = remaining < step ? remaining : step;
      await Future.delayed(Duration(milliseconds: chunk));
      elapsed += chunk;
    }
  }

  Future<void> _highlightLine(int line, {int delayMs = 0}) async {
    _setHighlightLine(line);
    if (delayMs > 0 && !shouldStop) {
      await _pauseAwareDelay(delayMs);
    }
  }

  void _setHighlightLine(int line) {
    highlightedLine = line;
    onStateChanged();
  }

  Future<void> startMergeSort() async {
    if (isSorting) return;
    if (numbers.isEmpty) return;

    _resetState();

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

    final List<SortItem> workingArray = numbers
        .map((item) => SortItem(item.id, item.value))
        .toList();
    numbers = workingArray;

    _buildInitialTreeStructure();

    await _mergeSort(numbers, 0, numbers.length - 1);

    if (!shouldStop) {
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

  Future<void> _mergeSort(
    List<SortItem> arr,
    int left,
    int right, [
    int level = 0,
  ]) async {
    if (shouldStop) return;
    await _waitIfPaused();

    final String rangeKey = '$left-$right';

    if (left >= right) {
      if (left >= 0 && left < arr.length) {
        currentStep = "Base case reached for index $left";
        operationIndicator = "🟢 Single element ${arr[left].value}";
      } else {
        currentStep = "Base case reached";
        operationIndicator = "🟢 Empty segment";
      }

      visitedRanges.add(rangeKey);
      completedRanges.add(rangeKey);

      await _highlightLine(1, delayMs: 220);
      await _highlightLine(2, delayMs: 220);
      onStateChanged();
      await _pauseAwareDelay(160);
      return;
    }

    activeRangeLeft = left;
    activeRangeRight = right;
    activeRangeLevel = level;

    visitedRanges.add(rangeKey);
    dividingRanges.add(rangeKey);
    isDividing = true;

    final int mid = left + (right - left) ~/ 2;

    currentStep = "Dividing array from index $left to $right";
    operationIndicator = "📋 Split: [${left}-${mid}] | [${mid + 1}-${right}]";

    await _highlightLine(0, delayMs: 140);
    await _highlightLine(4, delayMs: 180);

    onStateChanged();
    await _pauseAwareDelay(600);

    dividingRanges.remove(rangeKey);
    onStateChanged();

    await _highlightLine(5, delayMs: 160);
    await _mergeSort(arr, left, mid, level + 1);
    if (shouldStop) return;

    await _highlightLine(6, delayMs: 160);
    await _mergeSort(arr, mid + 1, right, level + 1);
    if (shouldStop) return;

    await _highlightLine(8, delayMs: 180);
    await _merge(arr, left, mid, right, level);

    completedRanges.add(rangeKey);

    activeRangeLeft = -1;
    activeRangeRight = -1;
    activeRangeLevel = -1;
    onStateChanged();
  }

  Future<void> _merge(
    List<SortItem> arr,
    int left,
    int mid,
    int right, [
    int level = 0,
  ]) async {
    if (shouldStop) return;
    await _waitIfPaused();

    final String rangeKey = '$left-$right';
    mergingRanges.add(rangeKey);

    activeRangeLeft = left;
    activeRangeRight = right;
    activeRangeLevel = level;

    isMerging = true;
    isDividing = false;

    final List<SortItem> leftArr = <SortItem>[];
    final List<SortItem> rightArr = <SortItem>[];

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
    operationIndicator =
        "🔀 Merging: [${leftArr.map((e) => e.value).join(',')}] + [${rightArr.map((e) => e.value).join(',')}]";

    await _highlightLine(10, delayMs: 180);
    await _highlightLine(11, delayMs: 150);
    await _highlightLine(12, delayMs: 150);

    onStateChanged();
    await _pauseAwareDelay(500);

    int i = 0, j = 0, k = left;

    while (i < leftArr.length && j < rightArr.length) {
      if (shouldStop) return;
      await _waitIfPaused();

      _setHighlightLine(14);
      await _pauseAwareDelay(140);

      totalComparisons++;
      leftIndex = i;
      rightIndex = j;
      mergeIndex = k;

      final bool takeLeft = isAscending
          ? leftArr[i].value <= rightArr[j].value
          : leftArr[i].value >= rightArr[j].value;

      if (takeLeft) {
        _setHighlightLine(15);
        await _pauseAwareDelay(110);
        _setHighlightLine(16);
        await _pauseAwareDelay(100);

        currentStep = "Taking ${leftArr[i].value} from left array";
        operationIndicator = "📥 ${leftArr[i].value} → position $k";
        arr[k] = SortItem(leftArr[i].id, leftArr[i].value);
        movingFromIndex = mergeLeftStart + i;
        movingToIndex = k;
        movingValue = leftArr[i].value;
        _animationController.forward(from: 0.0);
        i++;

        _setHighlightLine(17);
      } else {
        _setHighlightLine(18);
        await _pauseAwareDelay(110);
        _setHighlightLine(19);
        await _pauseAwareDelay(100);

        currentStep = "Taking ${rightArr[j].value} from right array";
        operationIndicator = "📥 ${rightArr[j].value} → position $k";
        arr[k] = SortItem(rightArr[j].id, rightArr[j].value);
        movingFromIndex = mergeRightStart + j;
        movingToIndex = k;
        movingValue = rightArr[j].value;
        _animationController.forward(from: 0.0);
        j++;

        _setHighlightLine(20);
      }

      k++;
      onStateChanged();
      await _pauseAwareDelay(600);
    }

    if (i < leftArr.length || j < rightArr.length) {
      _setHighlightLine(22);
      onStateChanged();
      await _pauseAwareDelay(160);
    }

    while (i < leftArr.length) {
      if (shouldStop) return;
      await _waitIfPaused();

      _setHighlightLine(23);
      await _pauseAwareDelay(120);
      _setHighlightLine(24);
      await _pauseAwareDelay(100);
      _setHighlightLine(25);

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
      await _pauseAwareDelay(400);
    }

    while (j < rightArr.length) {
      if (shouldStop) return;
      await _waitIfPaused();

      _setHighlightLine(26);
      await _pauseAwareDelay(120);
      _setHighlightLine(27);
      await _pauseAwareDelay(100);
      _setHighlightLine(28);

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
      await _pauseAwareDelay(400);
    }

    totalMerges++;
    final List<int> mergedResult = <int>[];
    for (int idx = left; idx <= right; idx++) {
      mergedResult.add(arr[idx].value);
    }
    mergedNodes[rangeKey] = mergedResult;
    completedRanges.add(rangeKey);
    isMerging = false;
    leftIndex = -1;
    rightIndex = -1;
    mergeIndex = -1;
    leftArray = [];
    rightArray = [];

    mergingRanges.remove(rangeKey);

    currentStep = "Merge complete for range [$left-$right]";
    operationIndicator = "✅ Subarray merged successfully";

    await _highlightLine(30, delayMs: 200);

    onStateChanged();
    await _pauseAwareDelay(500);

    activeRangeLeft = -1;
    activeRangeRight = -1;
    activeRangeLevel = -1;
    _setHighlightLine(-1);
    onStateChanged();
  }
}

class TreeLevel {
  final List<SortItem> items;
  final int level;
  bool isActive;

  TreeLevel({required this.items, required this.level, this.isActive = false});
}
