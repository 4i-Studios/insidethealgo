import 'package:flutter/material.dart';

class AnimatedBars extends StatelessWidget {
  final List<int> numbers;
  final int highlightedIndex;
  final Color Function(int index, int value) getBarColor;
  final String title;

  const AnimatedBars({
    Key? key,
    required this.numbers,
    this.highlightedIndex = -1,
    required this.getBarColor,
    this.title = 'Array State',
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (numbers.isEmpty) {
                  return const Center(child: Text('No data to display'));
                }

                double availableHeight = constraints.maxHeight - 20;
                double availableWidth = constraints.maxWidth - 20;
                int maxNumber = numbers.reduce((a, b) => a > b ? a : b);
                double barWidth = (availableWidth / numbers.length).clamp(8.0, 40.0);

                return Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: numbers.asMap().entries.map((entry) {
                        int index = entry.key;
                        int value = entry.value;
                        double barHeight = ((value / maxNumber) * (availableHeight - 20)).clamp(10.0, availableHeight - 20);

                        return Container(
                          width: barWidth,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: barHeight,
                                decoration: BoxDecoration(
                                  color: getBarColor(index, value),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                  border: Border.all(
                                    color: highlightedIndex == index
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                value.toString(),
                                style: TextStyle(
                                  fontSize: (barWidth * 0.25).clamp(8.0, 12.0),
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}