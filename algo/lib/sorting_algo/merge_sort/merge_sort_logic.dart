import 'package:flutter/material.dart';

class MergeSortLogic extends ChangeNotifier {
  final TickerProvider tickerProvider;

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

  // Merge sort specific
  List<int> leftArray = [];
  List<int> rightArray = [];
  int leftIndex = -1;
  int rightIndex = -1;
  int mergeIndex = -1;
  List<Color> barColors = [];

  MergeSortLogic(this.tickerProvider) {
    sortAnimation = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: tickerProvider,
    );
    _initializeColors();
    arrayController.text = numbers.join(', ');
  }

  void _initializeColors() {
    barColors = List.generate(numbers.length, (index) => Colors.blue);
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
      notifyListeners();
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
    notifyListeners();
  }

  void shuffleArray() {
    if (!isSorting) {
      numbers.shuffle();
      originalNumbers = List.from(numbers);
      arrayController.text = numbers.join(', ');
      _resetSortingState();
      notifyListeners();
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
    notifyListeners();

    await _mergeSort(0, numbers.length - 1);

    isSorting = false;
    sortCompleted = true;
    currentStep = 'Sorting completed!';
    operationIndicator = 'Array is now sorted! ✨';
    highlightedLine = -1;
    _initializeColors();
    notifyListeners();
  }

  Future<void> _mergeSort(int left, int right) async {
    if (left < right) {
      highlightedLine = 1;
      int mid = (left + right) ~/ 2;

      operationIndicator = 'Dividing array: [${left}, ${right}] → [${left}, ${mid}] and [${mid + 1}, ${right}]';
      _highlightRange(left, right, Colors.orange);
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 800));

      // Recursively sort left and right halves
      await _mergeSort(left, mid);
      await _mergeSort(mid + 1, right);

      // Merge the sorted halves
      await _merge(left, mid, right);
    }
  }

  Future<void> _merge(int left, int mid, int right) async {
    highlightedLine = 5;

    // Create temporary arrays
    List<int> leftArr = numbers.sublist(left, mid + 1);
    List<int> rightArr = numbers.sublist(mid + 1, right + 1);

    leftArray = leftArr;
    rightArray = rightArr;

    operationIndicator = 'Merging: Left[${leftArr.join(',')}] Right[${rightArr.join(',')}]';
    _highlightRange(left, right, Colors.purple);
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1000));

    int i = 0, j = 0, k = left;

    // Merge the arrays
    while (i < leftArr.length && j < rightArr.length) {
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

      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 600));
    }

    // Copy remaining elements
    while (i < leftArr.length) {
      highlightedLine = 13;
      leftIndex = i;
      mergeIndex = k;
      operationIndicator = 'Copying remaining left element: ${leftArr[i]}';
      numbers[k] = leftArr[i];
      barColors[k] = Colors.green;
      i++;
      k++;
      totalSwaps++;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 400));
    }

    while (j < rightArr.length) {
      highlightedLine = 16;
      rightIndex = j;
      mergeIndex = k;
      operationIndicator = 'Copying remaining right element: ${rightArr[j]}';
      numbers[k] = rightArr[j];
      barColors[k] = Colors.green;
      j++;
      k++;
      totalSwaps++;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 400));
    }

    leftIndex = -1;
    rightIndex = -1;
    mergeIndex = -1;
    operationIndicator = 'Merged successfully!';

    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
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

  @override
  void dispose() {
    sortAnimation.dispose();
    arrayController.dispose();
    super.dispose();
  }
}