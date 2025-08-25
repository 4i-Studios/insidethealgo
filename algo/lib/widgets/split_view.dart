import 'package:flutter/material.dart';

class SplitView extends StatelessWidget {
  final Widget leftWidget;
  final Widget rightWidget;
  final double leftFlex;
  final double rightFlex;
  final Axis direction;
  final double spacing;

  const SplitView({
    Key? key,
    required this.leftWidget,
    required this.rightWidget,
    this.leftFlex = 2,
    this.rightFlex = 1,
    this.direction = Axis.horizontal,
    this.spacing = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final useVerticalLayout = screenWidth < 600;

    if (useVerticalLayout && direction == Axis.horizontal) {
      // Force vertical layout on small screens
      return Column(
        children: [
          Expanded(flex: leftFlex.toInt(), child: leftWidget),
          SizedBox(height: spacing),
          Expanded(flex: rightFlex.toInt(), child: rightWidget),
        ],
      );
    }

    if (direction == Axis.vertical) {
      return Column(
        children: [
          Expanded(flex: leftFlex.toInt(), child: leftWidget),
          SizedBox(height: spacing),
          Expanded(flex: rightFlex.toInt(), child: rightWidget),
        ],
      );
    }

    return Row(
      children: [
        Expanded(flex: leftFlex.toInt(), child: leftWidget),
        SizedBox(width: spacing),
        Expanded(flex: rightFlex.toInt(), child: rightWidget),
      ],
    );
  }
}