import 'dart:ui';
import 'package:flutter/material.dart';

/// SortingCardView displays a horizontal list of animated cards for sorting visualization.
///
/// [numbers] - List of integer values to display.
/// [comparingIndices] - Indices currently being compared (highlighted red).
/// [sortedIndices] - Indices that are sorted (highlighted green).
///
/// Use setState to update [numbers], [comparingIndices], and [sortedIndices] during sorting.
class SortingCardView extends StatefulWidget {
  final List<int> numbers;
  final List<int> comparingIndices;
  final List<int> sortedIndices;
  final Duration duration;

  const SortingCardView({
    Key? key,
    required this.numbers,
    required this.comparingIndices,
    required this.sortedIndices,
    this.duration = const Duration(milliseconds: 400),
  }) : super(key: key);

  @override
  State<SortingCardView> createState() => _SortingCardViewState();
}

class _SortingCardViewState extends State<SortingCardView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Legend
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendItem(Colors.blue, Icons.blur_on, 'Normal'),
              _legendItem(Colors.orange, Icons.compare_arrows, 'Comparing'),
              _legendItem(Colors.red, Icons.swap_horiz, 'Swapping'),
              _legendItem(Colors.green, Icons.check_circle, 'Sorted'),
            ],
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.numbers.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              final value = widget.numbers[index];
              final isComparing = widget.comparingIndices.contains(index);
              final isSorted = widget.sortedIndices.contains(index);
              // Remove isSwapping logic for clarity

              // Correct color assignment for each state
              Gradient gradient;
              Color borderColor;
              IconData statusIcon;
              Color iconColor;
              double borderWidth;
              double scale;

              if (isSorted) {
                gradient = LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                );
                borderColor = Colors.green;
                statusIcon = Icons.check_circle;
                iconColor = Colors.green;
                borderWidth = 3;
                scale = 1.08;
              } else if (isComparing) {
                gradient = LinearGradient(
                  colors: [Colors.orange.shade300, Colors.orange.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                );
                borderColor = Colors.orange;
                statusIcon = Icons.compare_arrows;
                iconColor = Colors.orange;
                borderWidth = 3;
                scale = 1.08;
              } else {
                gradient = LinearGradient(
                  colors: [Colors.blue.shade300, Colors.purple.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                );
                borderColor = Colors.blueAccent;
                statusIcon = Icons.blur_on;
                iconColor = Colors.blueAccent;
                borderWidth = 2;
                scale = 1.0;
              }

              List<BoxShadow> boxShadow = [
                BoxShadow(
                  color: borderColor.withAlpha((0.4 * 255).toInt()),
                  blurRadius: borderWidth == 3 ? 18 : 8,
                  spreadRadius: borderWidth == 3 ? 6 : 2,
                  offset: const Offset(0, 4),
                ),
              ];

              return AnimatedContainer(
                duration: widget.duration,
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                width: 80,
                height: 100,
                transform: Matrix4.identity()..scale(scale),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor, width: borderWidth),
                  boxShadow: boxShadow,
                ),
                child: Stack(
                  children: [
                    // Glassmorphism effect
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          color: Colors.white.withAlpha((0.08 * 255).toInt()),
                        ),
                      ),
                    ),
                    // Card content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$value',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Icon(statusIcon, color: iconColor, size: 22),
                        ],
                      ),
                    ),
                    // Index display
                    Positioned(
                      top: 6,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha((0.18 * 255).toInt()),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '#$index',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _legendItem(Color color, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        const SizedBox(width: 16),
      ],
    );
  }
}
