import 'package:flutter/material.dart';
import 'dart:math';

// Individual bubble widget that maintains its own value and position
class BubbleWidget extends StatelessWidget {
  final int value;
  final Color color;
  final double scale;
  final bool isSwapping;
  final double elevation;

  const BubbleWidget({
    Key? key,
    required this.value,
    required this.color,
    required this.scale,
    required this.isSwapping,
    required this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Note: size is provided by parent via constraints; parent may scale this widget.
    const double defaultBubbleSize = 40;

    return Transform.scale(
      scale: scale,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        elevation: elevation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          width: defaultBubbleSize,
          height: defaultBubbleSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(80),
                blurRadius: isSwapping ? 18 : 8,
                spreadRadius: 1,
              ),
            ],
            border: Border.all(
              color: isSwapping ? Colors.white : Colors.transparent,
              width: isSwapping ? 3 : 1,
            ),
          ),
          child: Center(
            child: Text(
              '$value',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedBubble extends StatefulWidget {
  final List<int> numbers;
  final int comparingIndex1;
  final int comparingIndex2;
  final bool isSwapping;
  final int swapFrom;
  final int swapTo;
  final double swapProgress;
  final bool isSorted;
  final int swapTick;

  const AnimatedBubble({
    Key? key,
    required this.numbers,
    required this.comparingIndex1,
    required this.comparingIndex2,
    required this.isSwapping,
    required this.swapFrom,
    required this.swapTo,
    required this.swapProgress,
    required this.isSorted,
    required this.swapTick,
  }) : super(key: key);

  @override
  State<AnimatedBubble> createState() => _AnimatedBubbleState();
}

class _AnimatedBubbleState extends State<AnimatedBubble> {
  late List<int> bubbleValues;
  late List<int> bubblePositions; // Maps value to position index
  int lastSwapTick = -1;

  @override
  void initState() {
    super.initState();
    _initializeBubbles();
  }

  @override
  void didUpdateWidget(AnimatedBubble oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the incoming list length changed or the set of items is different,
    // reinitialize bubbleValues so we track the correct identities.
    bool needsReinit = false;
    if (bubbleValues.length != widget.numbers.length) {
      needsReinit = true;
    } else {
      // if any item from bubbleValues cannot be found (by id/value) in new list, reinit
      for (final item in bubbleValues) {
        if (_indexOfItemInList(item, widget.numbers) == -1) {
          needsReinit = true;
          break;
        }
      }
    }

    if (needsReinit) {
      bubbleValues = List.from(widget.numbers);
      bubblePositions = List.generate(widget.numbers.length, (i) => i);
    } else if (!_listsEqual(oldWidget.numbers, widget.numbers) ||
        widget.swapTick != lastSwapTick) {
      // Only update positions when items remain the same but order changed
      _updateBubblePositions();
    }

    lastSwapTick = widget.swapTick;
  }

  void _initializeBubbles() {
    bubbleValues = List.from(widget.numbers);
    bubblePositions = List.generate(widget.numbers.length, (i) => i);
    lastSwapTick = widget.swapTick;
  }

  void _updateBubblePositions() {
    // Create a mapping of current array to find where each value should be
    for (int i = 0; i < widget.numbers.length; i++) {
      int value = widget.numbers[i];
      int bubbleIndex = bubbleValues.indexOf(value);
      if (bubbleIndex != -1) {
        bubblePositions[bubbleIndex] = i;
      }
    }
  }

  bool _listsEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  int _indexOfItemInList(int item, List<int> list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i] == item) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    // Make size responsive using LayoutBuilder to avoid overflow
    return LayoutBuilder(builder: (context, constraints) {
      final int count = widget.numbers.length;
      final double maxWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : MediaQuery.of(context).size.width;
      final double maxHeight = constraints.maxHeight.isFinite ? constraints.maxHeight : 200;

      // Spacing and bubble sizing
      const double minBubbleSize = 40;
      const double maxBubbleSize = 40;
      const double spacing = 8.0;

      double availableForBubbles = maxWidth - (count - 1) * spacing;
      double bubbleSize = count > 0 ? (availableForBubbles / count) : minBubbleSize;
      bubbleSize = bubbleSize.clamp(minBubbleSize, maxBubbleSize);

      // Compute total width and startX centrally
      double totalWidth = count * bubbleSize + (count - 1) * spacing;
      double startX = max(0, (maxWidth - totalWidth) / 2);

      // Vertical layout: leave some padding above and below
      double verticalPadding = 12.0;
      double baseTop = verticalPadding;

      // Arc height for swap animation proportional to bubble size
      double arcHeight = bubbleSize * 0.6;

      // Container height should fit bubbles and vertical padding
      double containerHeight = bubbleSize + verticalPadding * 2;
      // Ensure we don't exceed available maxHeight
      containerHeight = min(containerHeight, maxHeight);

      return SizedBox(
              width: double.infinity,
              height: containerHeight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  width: max(totalWidth, maxWidth),
                  height: containerHeight,
                  child: Stack(
                    children: List.generate(bubbleValues.length, (bubbleIndex) {
                      int value = bubbleValues[bubbleIndex];
                      int targetPosition = bubblePositions[bubbleIndex];

                      // Calculate target position
                      double targetLeft = startX + targetPosition * (bubbleSize + spacing);
                      double targetTop = baseTop;

                      // Check if this bubble is currently being swapped
                      bool isCurrentlySwapping = widget.isSwapping &&
                          (targetPosition == widget.swapFrom || targetPosition == widget.swapTo);

                      // Arc animation during swap
                      if (isCurrentlySwapping) {
                        double arc = sin(pi * widget.swapProgress) * arcHeight;
                        targetTop = baseTop - arc;
                      }

                      // Color legend mapping:
                      // Unsorted: blue
                      // Selected: orange  (comparingIndex1)
                      // Compared: purple  (comparingIndex2)
                      // Swapping: red
                      // Sorted: green

                      // Define colors
                      const Color colorUnsorted = Color(0xFF2196F3); // blue
                      const Color colorSelected = Color(0xFFFF9800); // orange
                      const Color colorCompared = Color(0xFF9C27B0); // purple
                      const Color colorSwapping = Color(0xFFF44336); // red
                      const Color colorSorted = Color(0xFF4CAF50); // green

                      // Default visuals
                      Color color = colorUnsorted;
                      double scale = 1.0;
                      double elevation = 6;

                      // Priority: sorted > swapping > selected/compared > unsorted
                      if (widget.isSorted) {
                        color = colorSorted;
                        scale = 1.03;
                        elevation = 8;
                      } else if (isCurrentlySwapping) {
                        color = colorSwapping;
                        scale = 1.15;
                        elevation = 16;
                      } else if (targetPosition == widget.comparingIndex1) {
                        // Selected
                        color = colorSelected;
                        scale = 1.12;
                        elevation = 12;
                      } else if (targetPosition == widget.comparingIndex2) {
                        // Compared
                        color = colorCompared;
                        scale = 1.08;
                        elevation = 10;
                      }

                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        left: targetLeft,
                        top: targetTop,
                        child: SizedBox(
                          width: bubbleSize,
                          height: bubbleSize,
                          child: BubbleWidget(
                            value: value,
                            color: color,
                            scale: scale,
                            isSwapping: isCurrentlySwapping,
                            elevation: elevation,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            );
    });
  }
}
