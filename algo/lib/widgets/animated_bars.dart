import 'package:flutter/material.dart';

class AnimatedElements<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, int index, T item, bool isHighlighted) itemBuilder;
  final int highlightedIndex;
  final String title;
  final Axis direction;
  final double spacing;

  // Bubble sort animation support
  final int? bubbleSelectedIndex;
  final int? bubbleCompareIndex;
  final bool bubbleIsSwapping;
  final int? bubbleSwapFrom;
  final int? bubbleSwapTo;
  final double bubbleSwapProgress; // 0.0 to 1.0

  const AnimatedElements({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.highlightedIndex = -1,
    this.title = 'Array State',
    this.direction = Axis.horizontal,
    this.spacing = 4.0,
    this.bubbleSelectedIndex,
    this.bubbleCompareIndex,
    this.bubbleIsSwapping = false,
    this.bubbleSwapFrom,
    this.bubbleSwapTo,
    this.bubbleSwapProgress = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('No data to display'))
                : direction == Axis.horizontal
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(items.length, (index) {
                            final isHighlighted = index == highlightedIndex;
                            // Bubble animation logic
                            double yOffset = 0;
                            double xOffset = 0;
                            if (bubbleSelectedIndex == index) {
                              yOffset = -24;
                            }
                            if (bubbleCompareIndex == index) {
                              yOffset = -18;
                            }
                            if (bubbleIsSwapping &&
                                (index == bubbleSwapFrom || index == bubbleSwapTo)) {
                              // Animate horizontal swap
                              double swapDistance = 56.0 + spacing; // width + spacing
                              if (index == bubbleSwapFrom && bubbleSwapTo != null) {
                                xOffset = (bubbleSwapTo! - bubbleSwapFrom!) * swapDistance * bubbleSwapProgress;
                              }
                              if (index == bubbleSwapTo && bubbleSwapFrom != null) {
                                xOffset = (bubbleSwapFrom! - bubbleSwapTo!) * swapDistance * bubbleSwapProgress;
                              }
                              yOffset = -24; // keep lifted during swap
                            }
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOut,
                                transform: Matrix4.translationValues(xOffset, yOffset, 0),
                                child: itemBuilder(context, index, items[index], isHighlighted),
                              ),
                            );
                          }),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: List.generate(items.length, (index) {
                            final isHighlighted = index == highlightedIndex;
                            // Bubble animation logic for vertical (optional)
                            double yOffset = 0;
                            if (bubbleSelectedIndex == index) {
                              yOffset = -24;
                            }
                            if (bubbleCompareIndex == index) {
                              yOffset = -18;
                            }
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: spacing / 2),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOut,
                                transform: Matrix4.translationValues(0, yOffset, 0),
                                child: itemBuilder(context, index, items[index], isHighlighted),
                              ),
                            );
                          }),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

