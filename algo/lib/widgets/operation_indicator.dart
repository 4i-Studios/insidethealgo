import 'package:flutter/material.dart';

class OperationIndicator extends StatelessWidget {
  final String operation;
  final String? currentStep;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final bool isAnimated;

  const OperationIndicator({
    Key? key,
    required this.operation,
    this.currentStep,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.icon,
    this.isAnimated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: 16),
            const SizedBox(width: 8),
          ],
          Text(
            operation,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          if (currentStep != null) ...[
            const SizedBox(width: 8),
            Text(
              currentStep!,
              style: TextStyle(
                color: textColor.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );

    if (isAnimated) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: content,
      );
    }

    return content;
  }
}