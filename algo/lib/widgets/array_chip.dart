import 'package:flutter/material.dart';

class ArrayChip extends StatelessWidget {
  final String label;
  final List<int> array;
  final Color color;
  final double fontSize;

  const ArrayChip({
    Key? key,
    required this.label,
    required this.array,
    required this.color,
    this.fontSize = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: [${array.join(',')}]',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}