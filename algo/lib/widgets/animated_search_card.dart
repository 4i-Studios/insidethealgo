import 'package:flutter/material.dart';

class AnimatedSearchCard extends StatelessWidget {
  final List<int> numbers;
  final int currentIndex;
  final int foundIndex;
  final bool isSearching;

  const AnimatedSearchCard({
    Key? key,
    required this.numbers,
    required this.currentIndex,
    required this.foundIndex,
    required this.isSearching,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: numbers.asMap().entries.map((entry) {
          int index = entry.key;
          int value = entry.value;

          Color bgColor = const Color(0xFFE3F2FD); // unvisited
          double scale = 1.0;
          BoxShadow? shadow;

          if (foundIndex == index) {
            bgColor = const Color(0xFF4CAF50);
            scale = 1.05; // bounce will be provided by AnimatedScale
            shadow = BoxShadow(color: const Color(0xFF4CAF50).withValues(alpha: 77), blurRadius: 8, spreadRadius: 1);
          } else if (isSearching && currentIndex == index) {
            bgColor = const Color(0xFFFF9800); // current
            scale = 1.05;
            shadow = BoxShadow(color: const Color(0xFFFF9800).withValues(alpha: 64), blurRadius: 6);
          } else if (!isSearching && foundIndex == -1 && index < currentIndex) {
            bgColor = const Color(0xFFBDBDBD);
          } else if (isSearching && index < currentIndex) {
            bgColor = const Color(0xFFBDBDBD);
          }

          Widget card = AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            // curve: Curves.easeOut,
            // margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: bgColor,
              // borderRadius: BorderRadius.circular(12),
              boxShadow: shadow != null ? [shadow] : [],
              border: Border.all(color: Colors.black12),
            ),
            child: Center(
              child: Text(
                '$value',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          );

          // Found bounce animation using TweenAnimationBuilder
          if (foundIndex == index) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.95, end: 1.05),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (context, val, child) {
                return Transform.scale(scale: val, child: child);
              },
              child: card,
            );
          }

          // Current element scale
          if (isSearching && currentIndex == index) {
            return AnimatedScale(
              scale: scale,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: card,
            );
          }

          return card;
        }).toList(),
      ),
    );
  }
}
