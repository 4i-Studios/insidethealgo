import 'package:flutter/material.dart';

class SearchAnimation extends StatelessWidget {
  final List<int> numbers;
  final Map<String, int> indices; // e.g., {'left': 0, 'mid': 2, 'right': 4}
  final Map<String, Color> colors; // e.g., {'default': Colors.blue, 'left': Colors.orange}
  final double barWidth;
  final double maxBarHeight;

  const SearchAnimation({
    Key? key,
    required this.numbers,
    required this.indices,
    required this.colors,
    this.barWidth = 20.0,
    this.maxBarHeight = 200.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int maxNumber = numbers.isNotEmpty ? numbers.reduce((a, b) => a > b ? a : b) : 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: numbers.asMap().entries.map((entry) {
        int index = entry.key;
        int value = entry.value;

        // Determine the color of the bar
        Color barColor = colors['default'] ?? Colors.blue;
        indices.forEach((key, idx) {
          if (index == idx) {
            barColor = colors[key] ?? barColor;
          }
        });

        // Calculate the height of the bar
        double barHeight = (value / maxNumber) * maxBarHeight;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$value',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                width: barWidth,
                height: barHeight,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$index',
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}