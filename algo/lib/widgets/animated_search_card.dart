import 'package:flutter/material.dart';

class AnimatedSearchCard extends StatelessWidget {
  final List<int> numbers;
  final int currentIndex;
  final int foundIndex;
  final bool isSearching;
  final bool searchCompleted;
  final bool isFound;
  final int? leftIndex;
  final int? rightIndex;
  final Color Function(int index)? colorBuilder;
  final String Function(int index)? labelBuilder;
  final Set<int>? examinedIndices;
  final Set<int>? discardedIndices;
  final Animation<double>? focusAnimation;
  final double itemExtent;
  final bool showIndexLabels;
  final EdgeInsets itemPadding;

  const AnimatedSearchCard({
    super.key,
    required this.numbers,
    required this.currentIndex,
    required this.foundIndex,
    required this.isSearching,
    this.searchCompleted = false,
    this.isFound = false,
    this.leftIndex,
    this.rightIndex,
    this.colorBuilder,
    this.labelBuilder,
    this.examinedIndices,
    this.discardedIndices,
    this.focusAnimation,
    this.itemExtent = 50,
    this.showIndexLabels = true,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
  });

  @override
  Widget build(BuildContext context) {
    if (numbers.isEmpty) {
      return Center(
        child: Text(
          'Add numbers to visualize the search steps.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    final pulse = _focusPulse;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double effectiveExtent = constraints.maxHeight < 70
            ? 25
            : constraints.maxHeight < 95
                ? 35
                : itemExtent;
        final bool effectiveShowLabels =
            constraints.maxHeight > 85 && showIndexLabels;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          // padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: numbers.asMap().entries.map((entry) {
              final index = entry.key;
              final value = entry.value;

              final Color tileColor = _resolveColor(index);
              final String label = labelBuilder?.call(index) ?? '';
              final bool hasLabel = label.isNotEmpty;
              final bool isCurrent = isSearching && index == currentIndex;
              final bool isFoundTile = isFound && index == foundIndex;
              final bool isExamined = examinedIndices?.contains(index) ?? false;
              final bool isDiscarded = discardedIndices?.contains(index) ?? false;
              final bool outsideRange = _isOutsideCurrentRange(index);

              final double baseScale = isFoundTile
                  ? 1.05
                  : (isCurrent ? 1.02 : 1.0);
              final double animatedScale =
                  baseScale + (isCurrent ? 0.04 * pulse() : 0.0);
              final bool shouldDim =
                  (isDiscarded ||
                  outsideRange ||
                  (searchCompleted && !isFound && !isSearching));
              final double opacity = shouldDim && !isFoundTile ? 0.35 : 1.0;

              return Padding(
                padding: itemPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 12,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: hasLabel
                            ? _PointerBadge(
                                key: ValueKey('$index-$label'),
                                label: label,
                                color: _resolvePointerColor(label, tileColor),
                              )
                            : const SizedBox(),
                      ),
                    ),
                    const SizedBox(height: 2),
                    AnimatedScale(
                      scale: animatedScale.clamp(0.9, 1.05),
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.easeOutBack,
                      child: SizedBox(
                        height: effectiveExtent * 1.05,
                        width: effectiveExtent * 1.05,
                        child: AnimatedOpacity(
                          opacity: opacity,
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                          child: _ValueTile(
                            value: value,
                            color: tileColor,
                            extent: effectiveExtent,
                            highlightExamined:
                                isExamined && !isCurrent && !isFoundTile,
                            isFound: isFoundTile,
                          ),
                        ),
                      ),
                    ),
                    if (effectiveShowLabels) ...[
                      const SizedBox(height: 2),
                      Text(
                        'idx $index',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  double Function() get _focusPulse {
    if (focusAnimation == null) {
      return () => 0.0;
    }
    return () {
      final value = focusAnimation!.value;
      return (1 - (value - 0.5).abs() * 2).clamp(0.0, 1.0);
    };
  }

  Color _resolveColor(int index) {
    if (colorBuilder != null) {
      return colorBuilder!(index);
    }
    if (isFound && index == foundIndex) {
      return const Color(0xFF4CAF50);
    }
    if (isSearching && index == currentIndex) {
      return const Color(0xFFFF9800);
    }
    if ((isSearching && index < currentIndex) ||
        (!isSearching && foundIndex == -1 && index < currentIndex)) {
      return const Color(0xFFBDBDBD);
    }
    return const Color(0xFFE3F2FD);
  }

  bool _isOutsideCurrentRange(int index) {
    if (!isSearching || leftIndex == null || rightIndex == null) {
      return false;
    }
    if (leftIndex! < 0 || rightIndex! < 0) {
      return false;
    }
    return index < leftIndex! || index > rightIndex!;
  }

  Color _resolvePointerColor(String label, Color fallback) {
    switch (label) {
      case 'L':
        return Colors.blue.shade600;
      case 'R':
        return Colors.purple.shade400;
      case 'M':
        return Colors.orange.shade400;
      case '✓':
        return Colors.green.shade600;
      default:
        return fallback;
    }
  }
}

class _ValueTile extends StatelessWidget {
  final int value;
  final Color color;
  final double extent;
  final bool highlightExamined;
  final bool isFound;

  const _ValueTile({
    required this.value,
    required this.color,
    required this.extent,
    required this.highlightExamined,
    required this.isFound,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isFound
        ? Colors.green.shade900
        : (highlightExamined
              ? Colors.orange.shade300
              : Colors.black.withValues(alpha: 0.08));
    final List<BoxShadow> boxShadow = isFound
        ? [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ]
        : highlightExamined
        ? [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.22),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
        : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ];

    return Container(
      width: extent,
      height: extent,
      decoration: BoxDecoration(
        color: color,
        // borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: isFound ? 2.2 : 1.2),
        boxShadow: boxShadow,
      ),
      alignment: Alignment.center,
      child: Text(
        '$value',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _PointerBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _PointerBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    IconData? icon;
    if (label == 'L') {
      icon = Icons.arrow_back_ios_new;
    } else if (label == 'R') {
      icon = Icons.arrow_forward_ios;
    } else if (label == 'M') {
      icon = Icons.center_focus_strong;
    } else if (label == '✓') {
      icon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
